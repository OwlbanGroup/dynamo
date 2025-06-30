# PowerShell script to set PYTHONPATH and run critical-path deployment tests

# Set PYTHONPATH environment variable to include all relevant source directories
$env:PYTHONPATH = "$(Resolve-Path .)\deploy\sdk\src;$(Resolve-Path .)\dynamo\components\planner\src;$(Resolve-Path .)\lib\llm;$(Resolve-Path .)\lib\runtime;$(Resolve-Path .)\lib\tokens;$(Resolve-Path .)\dynamo\lib\runtime;$(Resolve-Path .)\dynamo\lib\llm;$(Resolve-Path .)\dynamo\lib\planner;$(Resolve-Path .)\lib\planner\src;$(Resolve-Path .)\lib\llm\src;$(Resolve-Path .)\lib\runtime\src;$(Resolve-Path .)\lib\bindings\python;$(Resolve-Path .)\lib\_core;$(Resolve-Path .)\deploy\sdk\src\dynamo\sdk;$(Resolve-Path .)\dynamo\deploy\sdk\src\dynamo\sdk;$(Resolve-Path .)\lib\bindings\python\tests"

# Run pytest with markers for end-to-end and slow tests, filtering for agg or agg_router deployments
pytest -m "e2e and slow" -k "agg or agg_router" --maxfail=1 --disable-warnings -q
