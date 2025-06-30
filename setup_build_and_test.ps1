# PowerShell script to build and install the ai-dynamo Python package with Rust bindings and run tests

# Activate Python virtual environment if exists
if (Test-Path -Path ".\\venv\\Scripts\\Activate.ps1") {
    Write-Host "Activating virtual environment..."
    . .\\venv\\Scripts\\Activate.ps1
} else {
    Write-Host "No virtual environment found. Please create one with 'python -m venv venv' and activate it."
    exit 1
}

# Upgrade pip and install hatch build backend
Write-Host "Upgrading pip and installing hatch..."
pip install --upgrade pip
pip install hatch

# Build and install the package in editable mode
Write-Host "Building and installing ai-dynamo package..."
hatch build
pip install --force-reinstall --no-deps --editable .

# Set PYTHONPATH environment variable to include all relevant source directories
$env:PYTHONPATH = "$(Resolve-Path .)\deploy\sdk\src;$(Resolve-Path .)\dynamo\components\planner\src;$(Resolve-Path .)\lib\llm;$(Resolve-Path .)\lib\runtime;$(Resolve-Path .)\lib\tokens;$(Resolve-Path .)\dynamo\lib\runtime;$(Resolve-Path .)\dynamo\lib\llm;$(Resolve-Path .)\dynamo\lib\planner;$(Resolve-Path .)\lib\planner\src;$(Resolve-Path .)\lib\llm\src;$(Resolve-Path .)\lib\runtime\src;$(Resolve-Path .)\lib\bindings\python;$(Resolve-Path .)\lib\_core;$(Resolve-Path .)\deploy\sdk\src\dynamo\sdk;$(Resolve-Path .)\dynamo\deploy\sdk\src\dynamo\sdk;$(Resolve-Path .)\lib\bindings\python\tests"

# Run pytest with markers for end-to-end and slow tests, filtering for agg or agg_router deployments
Write-Host "Running critical-path deployment tests..."
pytest -m "e2e and slow" -k "agg or agg_router" --maxfail=1 --disable-warnings -q
