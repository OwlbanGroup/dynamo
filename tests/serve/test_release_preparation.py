import unittest
import subprocess

class TestReleasePreparation(unittest.TestCase):
    def test_build_release_binaries(self):
        """Test that release binaries can be built successfully."""
        result = subprocess.run(["cargo", "build", "--release"], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, f"Cargo build failed: {result.stderr}")

    def test_copy_binaries(self):
        """Test that release binaries exist and can be copied."""
        import os
        binaries = ["http", "llmctl", "dynamo-run", "metrics", "mock_worker"]
        for binary in binaries:
            path = os.path.join("target", "release", binary)
            self.assertTrue(os.path.exists(path), f"Binary not found: {path}")

    def test_docker_build(self):
        """Test that the Docker image can be built."""
        result = subprocess.run(["./container/build.sh", "--framework", "vllm"], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, f"Docker build failed: {result.stderr}")

    def test_docker_compose_up(self):
        """Test that docker-compose can bring up services."""
        result = subprocess.run(["docker-compose", "up", "-d"], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, f"Docker-compose up failed: {result.stderr}")

    def test_service_response(self):
        """Test that the Dynamo service responds to a test request."""
        import requests
        import time

        # Wait for service to be ready
        time.sleep(10)

        url = "http://localhost:8000/v1/chat/completions"
        headers = {"Content-Type": "application/json"}
        data = {
            "model": "deepseek-ai/DeepSeek-R1-Distill-Llama-8B",
            "messages": [{"role": "user", "content": "Hello, how are you?"}],
            "stream": False,
            "max_tokens": 300
        }
        response = requests.post(url, json=data, headers=headers)
        self.assertEqual(response.status_code, 200, f"Service response failed: {response.text}")

if __name__ == "__main__":
    unittest.main()
