# PowerShell script to set PYTHONPATH environment variable to project root directory for tests

$env:PYTHONPATH = "$PWD"
Write-Host "PYTHONPATH set to: $env:PYTHONPATH"
