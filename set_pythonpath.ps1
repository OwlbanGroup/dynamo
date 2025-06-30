# PowerShell script to set PYTHONPATH environment variable for Dynamo SDK tests

$env:PYTHONPATH = "$PWD/deploy/sdk/src;$PWD/deploy/sdk/src/dynamo/sdk"
Write-Host "PYTHONPATH set to: $env:PYTHONPATH"
