# PowerShell script to set PYTHONPATH environment variable for NVIDIA Dynamo project

$sourceDirs = @(
    ".\deploy\sdk\src",
    ".\dynamo\components\planner\src",
    ".\lib\llm",
    ".\lib\runtime",
    ".\lib\tokens",
    ".\dynamo\lib\runtime",
    ".\dynamo\lib\llm",
    ".\dynamo\lib\planner",
    ".\lib\planner\src",
    ".\lib\llm\src",
    ".\lib\runtime\src",
    ".\lib\bindings\python",
    ".\lib\_core",
    ".\deploy\sdk\src\dynamo\sdk",
    ".\dynamo\deploy\sdk\src\dynamo\sdk",
    ".\lib\bindings\python\tests"
)

$fullPaths = $sourceDirs | ForEach-Object { (Resolve-Path $_).Path }
$env:PYTHONPATH = [string]::Join(";", $fullPaths)

Write-Host "PYTHONPATH set to:"
Write-Host $env:PYTHONPATH
