F# Environment Setup Instructions for NVIDIA Dynamo Testing

This document provides detailed instructions to set up the Python environment correctly to run all tests in the NVIDIA Dynamo project without import errors.

## 1. Python Environment

- Use Python 3.10 or later.
- It is recommended to use a virtual environment or conda environment to isolate dependencies.

### Using virtualenv

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\\Scripts\\activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Using conda

```bash
conda create -n dynamo-env python=3.10
conda activate dynamo-env
pip install -r requirements.txt
```

## 2. Install Dependencies

- Ensure all dependencies are installed, including:

  - boto3
  - pytest
  - Other dependencies listed in `requirements.txt` or `pyproject.toml`

```bash
pip install boto3 pytest
# or
pip install -r requirements.txt
```

## 3. Set PYTHONPATH

Set the PYTHONPATH environment variable to include all relevant source directories:

```powershell
$env:PYTHONPATH = "$(Resolve-Path .)\deploy\sdk\src;$(Resolve-Path .)\dynamo\components\planner\src;$(Resolve-Path .)\lib\llm;$(Resolve-Path .)\lib\runtime;$(Resolve-Path .)\lib\tokens;$(Resolve-Path .)\dynamo\lib\runtime;$(Resolve-Path .)\dynamo\lib\llm;$(Resolve-Path .)\dynamo\lib\planner;$(Resolve-Path .)\lib\planner\src;$(Resolve-Path .)\lib\llm\src;$(Resolve-Path .)\lib\runtime\src;$(Resolve-Path .)\lib\bindings\python;$(Resolve-Path .)\lib\_core;$(Resolve-Path .)\deploy\sdk\src\dynamo\sdk;$(Resolve-Path .)\dynamo\deploy\sdk\src\dynamo\sdk;$(Resolve-Path .)\lib\bindings\python\tests"
```

## 4. Clean Up

- Remove any `__pycache__` directories and `.pyc` files to avoid import mismatches:

```bash
find . -name "__pycache__" -exec rm -rf {} +
find . -name "*.pyc" -delete
```

## 5. Run Tests

- Use the provided PowerShell script to run tests with the environment configured:

```powershell
.\run_tests_with_env.ps1
```

## 6. Troubleshooting

- If import errors persist, verify that the PYTHONPATH includes all necessary directories.
- Check for duplicate or conflicting directories in PYTHONPATH.
- Ensure no conflicting versions of packages are installed.

---

Following these steps should resolve environment setup issues and enable running the full test suite successfully.
