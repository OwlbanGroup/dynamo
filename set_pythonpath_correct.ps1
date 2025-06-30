# PowerShell script to set PYTHONPATH environment variable correctly for Dynamo SDK tests

$rootPath = Join-Path $PWD "deploy/sdk/src"
$env:PYTHONPATH = $rootPath
Write-Host "PYTHONPATH set to: $env:PYTHONPATH"
