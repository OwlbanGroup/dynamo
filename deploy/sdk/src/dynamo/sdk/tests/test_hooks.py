# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Tests for startup and shutdown hooks in Dynamo services.

This file contains unit tests for the basic hook functionality and
tests for async init hooks in web workers with a frontend.
"""

import asyncio
from unittest.mock import MagicMock, patch

import pytest

from dynamo.sdk.cli.serve_dynamo import run_shutdown_hooks, run_startup_hooks
from dynamo.sdk.lib.decorators import async_on_start, on_shutdown


class MockServiceWithHooks:
    """Mock service class with startup and shutdown hooks for testing."""

    def __init__(self):
        self.sync_hook_called = False
        self.async_hook_called = False
        self.another_hook_called = False
        self.shutdown_hook_called = False
        self.hook_execution_order = []
        self.app = None  # Add app attribute for the web worker test

    @async_on_start
    async def async_startup_hook(self):
        """Async startup hook that should be called during startup."""
        await asyncio.sleep(0.1)  # Simulate some async work
        self.async_hook_called = True
        if hasattr(self, "hook_execution_order"):
            self.hook_execution_order.append("async_startup_hook")

    @async_on_start
    def sync_startup_hook(self):
        """Sync startup hook that should be called during startup."""
        self.sync_hook_called = True
        if hasattr(self, "hook_execution_order"):
            self.hook_execution_order.append("sync_startup_hook")

    @async_on_start
    async def another_startup_hook(self):
        """Another async startup hook."""
        await asyncio.sleep(0.1)  # Simulate some async work
        self.another_hook_called = True
        if hasattr(self, "hook_execution_order"):
            self.hook_execution_order.append("another_startup_hook")

    @on_shutdown
    def shutdown_hook(self):
        """Shutdown hook that should be called during shutdown."""
        self.shutdown_hook_called = True
        if hasattr(self, "hook_execution_order"):
            self.hook_execution_order.append("shutdown_hook")

    def regular_method(self):
        """Regular method that should not be called during startup."""
        raise Exception("This method should not be called")


@pytest.mark.asyncio
async def test_run_startup_hooks():
    """Test that startup hooks are properly called."""
    # Create an instance of our mock service
    service = MockServiceWithHooks()

    # Run the startup hooks
    await run_startup_hooks(service)

    # Verify that all startup hooks were called
    assert service.sync_hook_called, "Sync startup hook was not called"
    assert service.async_hook_called, "Async startup hook was not called"
    assert service.another_hook_called, "Another startup hook was not called"

    # Verify that shutdown hooks were not called
    assert (
        not service.shutdown_hook_called
    ), "Shutdown hook was incorrectly called during startup"


def test_run_shutdown_hooks():
    """Test that shutdown hooks are properly called."""
    # Create an instance of our mock service
    service = MockServiceWithHooks()

    # Run the shutdown hooks
    run_shutdown_hooks(service)

    # Verify that shutdown hooks were called
    assert service.shutdown_hook_called, "Shutdown hook was not called"

    # Verify that startup hooks were not called during shutdown
    assert (
        not service.sync_hook_called
    ), "Startup hook was incorrectly called during shutdown"
    assert (
        not service.async_hook_called
    ), "Startup hook was incorrectly called during shutdown"
    assert (
        not service.another_hook_called
    ), "Startup hook was incorrectly called during shutdown"


@pytest.mark.asyncio
async def test_run_startup_hooks_with_exception():
    """Test that exceptions in startup hooks are properly propagated."""

    # Create a mock service with a failing startup hook
    class MockServiceWithFailingHook:
        @async_on_start
        async def failing_hook(self):
            raise ValueError("Hook failure")

    service = MockServiceWithFailingHook()

    # Run the startup hooks and expect an exception
    with pytest.raises(ValueError, match="Hook failure"):
        await run_startup_hooks(service)


@pytest.mark.asyncio
async def test_run_startup_hooks_with_logging():
    """Test that startup hooks are properly logged."""
    service = MockServiceWithHooks()

    # Mock the logger to verify log messages
    with patch("dynamo.sdk.cli.serve_dynamo.logger") as mock_logger:
        await run_startup_hooks(service)

        # Verify that debug logs were created for each hook
        mock_logger.debug.assert_any_call("Running startup hook: async_startup_hook")
        mock_logger.debug.assert_any_call("Running startup hook: sync_startup_hook")
        mock_logger.debug.assert_any_call("Running startup hook: another_startup_hook")

        # Verify completion logs
        mock_logger.debug.assert_any_call(
            "Completed async startup hook: async_startup_hook"
        )
        mock_logger.info.assert_any_call("Completed startup hook: sync_startup_hook")
        mock_logger.debug.assert_any_call(
            "Completed async startup hook: another_startup_hook"
        )


def test_run_shutdown_hooks_with_exception():
    """Test that exceptions in shutdown hooks are properly propagated."""

    # Create a mock service with a failing shutdown hook
    class MockServiceWithFailingShutdownHook:
        @on_shutdown
        def failing_hook(self):
            raise ValueError("Shutdown hook failure")

    service = MockServiceWithFailingShutdownHook()

    # Run the shutdown hooks and expect an exception
    with pytest.raises(ValueError, match="Shutdown hook failure"):
        run_shutdown_hooks(service)


# Tests for web worker hooks


@pytest.mark.asyncio
async def test_run_startup_hooks_in_web_worker():
    """Test that startup hooks are properly called in a web worker environment."""
    # Create an instance of our mock service
    service = MockServiceWithHooks()

    # Run the startup hooks
    await run_startup_hooks(service)

    # Verify that all startup hooks were called
    assert service.sync_hook_called, "Sync startup hook was not called"
    assert service.async_hook_called, "Async startup hook was not called"
    assert service.another_hook_called, "Another startup hook was not called"

    # Verify that shutdown hooks were not called
    assert (
        not service.shutdown_hook_called
    ), "Shutdown hook was incorrectly called during startup"

    # Verify the execution order
    assert "sync_startup_hook" in service.hook_execution_order
    assert "async_startup_hook" in service.hook_execution_order
    assert "another_startup_hook" in service.hook_execution_order


def test_run_shutdown_hooks_in_web_worker():
    """Test that shutdown hooks are properly called in a web worker environment."""
    # Create an instance of our mock service
    service = MockServiceWithHooks()

    # Run the shutdown hooks
    run_shutdown_hooks(service)

    # Verify that shutdown hooks were called
    assert service.shutdown_hook_called, "Shutdown hook was not called"

    # Verify that startup hooks were not called during shutdown
    assert (
        not service.sync_hook_called
    ), "Startup hook was incorrectly called during shutdown"
    assert (
        not service.async_hook_called
    ), "Startup hook was incorrectly called during shutdown"
    assert (
        not service.another_hook_called
    ), "Startup hook was incorrectly called during shutdown"

    # Verify the execution order
    assert "shutdown_hook" in service.hook_execution_order


@pytest.mark.asyncio
async def test_run_startup_hooks_with_logging_in_web_worker():
    """Test that startup hooks are properly logged in a web worker environment."""
    service = MockServiceWithHooks()

    # Mock the logger to verify log messages
    with patch("dynamo.sdk.cli.serve_dynamo.logger") as mock_logger:
        await run_startup_hooks(service)

        # Verify that debug logs were created for each hook
        mock_logger.debug.assert_any_call("Running startup hook: async_startup_hook")
        mock_logger.debug.assert_any_call("Running startup hook: sync_startup_hook")
        mock_logger.debug.assert_any_call("Running startup hook: another_startup_hook")

        # Verify completion logs
        mock_logger.debug.assert_any_call(
            "Completed async startup hook: async_startup_hook"
        )
        mock_logger.info.assert_any_call("Completed startup hook: sync_startup_hook")
        mock_logger.debug.assert_any_call(
            "Completed async startup hook: another_startup_hook"
        )


@pytest.mark.asyncio
async def test_web_worker_with_hooks():
    """Test that hooks are properly called in the web worker context."""
    # Create a mock for the dyn_web_worker function
    mock_service = MockServiceWithHooks()

    # Mock the FastAPI app
    mock_app = MagicMock()
    mock_service.app = mock_app

    # Run startup hooks
    await run_startup_hooks(mock_service)

    # Verify hooks were called
    assert mock_service.sync_hook_called, "Sync hook was not called"
    assert mock_service.async_hook_called, "Async hook was not called"
    assert mock_service.another_hook_called, "Another hook was not called"

    # Verify execution order
    assert "sync_startup_hook" in mock_service.hook_execution_order
    assert "async_startup_hook" in mock_service.hook_execution_order
    assert "another_startup_hook" in mock_service.hook_execution_order

    # Verify shutdown hooks were not called
    assert not mock_service.shutdown_hook_called, "Shutdown hook was incorrectly called"


@pytest.mark.asyncio
async def test_run_startup_hooks_with_exception_in_web_worker():
    """Test that exceptions in startup hooks are properly propagated in a web worker."""

    # Create a mock service with a failing startup hook
    class MockServiceWithFailingHook:
        @async_on_start
        async def failing_hook(self):
            raise ValueError("Hook failure in web worker")

    service = MockServiceWithFailingHook()

    # Run the startup hooks and expect an exception
    with pytest.raises(ValueError, match="Hook failure in web worker"):
        await run_startup_hooks(service)


def test_run_shutdown_hooks_with_exception_in_web_worker():
    """Test that exceptions in shutdown hooks are properly propagated in a web worker."""

    # Create a mock service with a failing shutdown hook
    class MockServiceWithFailingShutdownHook:
        @on_shutdown
        def failing_hook(self):
            raise ValueError("Shutdown hook failure in web worker")

    service = MockServiceWithFailingShutdownHook()

    # Run the shutdown hooks and expect an exception
    with pytest.raises(ValueError, match="Shutdown hook failure in web worker"):
        run_shutdown_hooks(service)
