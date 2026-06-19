# System Architecture

## Overview

The system follows a layered architecture with two primary components:

1. **OSS Core** — The open-source foundation providing base infrastructure, data models, and APIs.
2. **Agent Layer** — An autonomous agent orchestration layer built on top of the OSS core.

## Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│                 Agent Layer                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ Sidekick │  │ Worker   │  │ Orchestrator │  │
│  │ Agent    │  │ Agents   │  │ Service      │  │
│  └──────────┘  └──────────┘  └──────────────┘  │
├─────────────────────────────────────────────────┤
│                  OSS Core                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ API      │  │ Data     │  │ Task Queue   │  │
│  │ Gateway  │  │ Models   │  │ & Scheduler  │  │
│  └──────────┘  └──────────┘  └──────────────┘  │
├─────────────────────────────────────────────────┤
│              Infrastructure                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ Storage  │  │ Message  │  │ Monitoring   │  │
│  │ Layer    │  │ Broker   │  │ & Logging    │  │
│  └──────────┘  └──────────┘  └──────────────┘  │
└─────────────────────────────────────────────────┘
```

## OSS Core

The OSS core provides:

- **API Gateway**: Entry point for all external requests, handling authentication, rate limiting, and request routing.
- **Data Models**: Core domain entities including users, projects, tasks, and configurations.
- **Task Queue & Scheduler**: Manages asynchronous task execution with priority queuing and retry logic.

## Agent Layer

The agent layer extends the OSS core with autonomous capabilities:

- **Sidekick Agent**: A primary autonomous agent that operates within isolated git worktrees to perform coding tasks.
- **Worker Agents**: Specialized agents that handle specific subtasks (documentation, testing, deployment).
- **Orchestrator Service**: Coordinates agent workflows, manages state, and ensures task completion.

## Key Design Principles

- **Isolation**: Each agent operates in its own git worktree/branch to prevent conflicts.
- **Idempotency**: Operations are designed to be safely retried.
- **Minimal Changes**: Agents make the smallest correct change to satisfy acceptance criteria.
- **Convention over Configuration**: Agents follow existing project conventions.

## Tools Reference

The agent layer uses a set of tools defined in the project brief (`_brief.md`):

- **File Tools**: `read_file`, `write_file`, `edit_file` for manipulating source files.
- **Execution Tools**: `run_bash` for running shell commands, build, test, and lint operations.
- **Navigation Tools**: `list_dir` for exploring the filesystem.
- **Completion Tool**: `finish` to signal subtask completion with a summary.