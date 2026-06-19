"""Guardrails for the agent.

Uses the shared lib github.com/redevops-io/agent-harness to validate/filter messages.
"""

from agent_harness import Guardrail  # github.com/redevops-io/agent-harness


class Guardrails:
    """Collection of guardrails applied to messages before sending to the LLM."""

    def __init__(self):
        self._guardrails: list[Guardrail] = []

    def add(self, guardrail: Guardrail) -> None:
        self._guardrails.append(guardrail)

    def apply(self, messages: list[dict]) -> list[dict]:
        """Run all guardrails on the message list and return (possibly filtered) messages."""
        for g in self._guardrails:
            messages = g.filter(messages)
        return messages