"""Tool implementations for the agent.

Uses open-source components from the shared lib github.com/redevops-io/agent-harness.
"""

import json

from agent_harness import Tool, ToolSpec  # github.com/redevops-io/agent-harness


class ToolRegistry:
    """Registry of tools the agent can invoke."""

    def __init__(self):
        self._tools: dict[str, Tool] = {}

    def register(self, tool: Tool) -> None:
        self._tools[tool.name] = tool

    def schemas(self) -> list[dict]:
        """Return OpenAI-compatible tool schemas."""
        return [ToolSpec.from_tool(t).to_openai() for t in self._tools.values()]

    def execute(self, tool_calls: list) -> str:
        """Execute tool calls and return a concatenated result string."""
        results = []
        for tc in tool_calls:
            tool = self._tools.get(tc.function.name)
            if tool is None:
                results.append(f"Unknown tool: {tc.function.name}")
                continue
            # tc.function.arguments is a JSON string per the OpenAI tool-call API.
            try:
                arguments = json.loads(tc.function.arguments or "{}")
            except (json.JSONDecodeError, TypeError):
                results.append(f"Invalid arguments for tool: {tc.function.name}")
                continue
            result = tool.run(**arguments)
            results.append(str(result))
        return "\n".join(results)