"""Agent that talks to an OpenAI-compatible LLM endpoint.

Environment variables:
    OPENAI_BASE_URL  – base URL for the OpenAI-compatible API
    OPENAI_API_KEY   – API key
    MODEL            – model name (e.g. gpt-4o-mini)
"""

import os
from openai import OpenAI

from .tools import ToolRegistry
from .guardrails import Guardrails


class Agent:
    """A minimal agent that uses an OpenAI-compatible LLM with tools & guardrails."""

    def __init__(self):
        self.base_url = os.environ["OPENAI_BASE_URL"]
        self.api_key = os.environ["OPENAI_API_KEY"]
        self.model = os.environ["MODEL"]
        self.client = OpenAI(base_url=self.base_url, api_key=self.api_key)
        self.tools = ToolRegistry()
        self.guardrails = Guardrails()

    def run(self, user_message: str) -> str:
        """Send a message to the LLM and return the assistant reply."""
        messages = [{"role": "user", "content": user_message}]

        # Apply guardrails before sending
        messages = self.guardrails.apply(messages)

        response = self.client.chat.completions.create(
            model=self.model,
            messages=messages,
            tools=self.tools.schemas(),
        )

        reply = response.choices[0].message
        if reply.tool_calls:
            return self.tools.execute(reply.tool_calls)
        return reply.content or ""