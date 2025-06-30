import os
import sys
import subprocess

# Set PYTHONPATH to include deploy/sdk/src and deploy/sdk/src/dynamo/sdk
pythonpath = os.environ.get("PYTHONPATH", "")
paths_to_add = [
    os.path.abspath("deploy/sdk/src"),
    os.path.abspath("deploy/sdk/src/dynamo/sdk"),
]
for p in paths_to_add:
    if p not in pythonpath:
        pythonpath = pythonpath + os.pathsep + p if pythonpath else p

env = os.environ.copy()
env["PYTHONPATH"] = pythonpath

# Tests to run
tests = [
    "tests/serve/test_helm_deploy.py",
    "tests/serve/test_helm_scaling.py",
    "tests/serve/test_helm_failure_recovery.py",
    "tests/serve/test_helm_load_performance.py",
    "deploy/sdk/src/dynamo/sdk/tests/test_owlban_data.py",
    "deploy/sdk/src/dynamo/sdk/tests/test_minimal_owlban_data.py",
]

# Run pytest with the updated PYTHONPATH
command = [sys.executable, "-m", "pytest", "-v"] + tests
result = subprocess.run(command, env=env)
sys.exit(result.returncode)
