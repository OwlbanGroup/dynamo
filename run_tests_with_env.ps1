# PowerShell script to set PYTHONPATH and run tests with environment configured

$env:PYTHONPATH = "$(Resolve-Path .)\deploy\sdk\src;$(Resolve-Path .)\dynamo\components\planner\src;$(Resolve-Path .)\lib\llm;$(Resolve-Path .)\lib\runtime;$(Resolve-Path .)\lib\tokens"

pytest --disable-warnings -q
