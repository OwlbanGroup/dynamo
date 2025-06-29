# PowerShell script to set PYTHONPATH and run pytest with proper environment

$env:PYTHONPATH = "$PWD\deploy\sdk\src;$PWD\components\planner\src;$PWD\lib\runtime\src"
pytest --maxfail=1 --disable-warnings -q
