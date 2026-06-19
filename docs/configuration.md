# Configuration Reference

## Environment Variables

### Core Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `APP_ENV` | Application environment (`development`, `staging`, `production`) | `development` | No |
| `APP_NAME` | Application name used for logging and service discovery | `growth-engine` | No |
| `LOG_LEVEL` | Logging verbosity (`debug`, `info`, `warn`, `error`) | `info` | No |
| `LOG_FORMAT` | Log output format (`json`, `text`) | `json` | No |

### Server Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `HOST` | Server bind address | `0.0.0.0` | No |
| `PORT` | Server listen port | `8080` | No |
| `READ_TIMEOUT` | HTTP read timeout in seconds | `30` | No |
| `WRITE_TIMEOUT` | HTTP write timeout in seconds | `30` | No |

### Database Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `DATABASE_URL` | Database connection string | — | Yes |
| `DATABASE_MAX_CONNECTIONS` | Maximum database pool connections | `10` | No |
| `DATABASE_TIMEOUT` | Database query timeout in seconds | `5` | No |

### Message Broker Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `BROKER_URL` | Message broker connection string | — | Yes |
| `BROKER_QUEUE_PREFIX` | Prefix for queue names | `growth-engine` | No |
| `BROKER_CONCURRENCY` | Number of concurrent message consumers | `4` | No |

### Agent Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `AGENT_WORKTREE_BASE` | Base path for agent git worktrees | `./.sidekick-selfhosted/worktrees` | No |
| `AGENT_TIMEOUT` | Maximum agent execution time in seconds | `300` | No |
| `AGENT_MAX_RETRIES` | Maximum retry attempts for failed agent tasks | `3` | No |
| `AGENT_LOG_DIR` | Directory for agent execution logs | `./logs/agents` | No |

### Storage Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `STORAGE_BACKEND` | Storage backend type (`local`, `s3`, `gcs`) | `local` | No |
| `STORAGE_PATH` | Local storage path | `./data` | No |
| `STORAGE_S3_BUCKET` | S3 bucket name (when using S3 backend) | — | No |
| `STORAGE_GCS_BUCKET` | GCS bucket name (when using GCS backend) | — | No |

### Monitoring Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `METRICS_ENABLED` | Enable Prometheus metrics endpoint | `true` | No |
| `METRICS_PORT` | Metrics endpoint port | `9090` | No |
| `HEALTH_CHECK_INTERVAL` | Health check interval in seconds | `30` | No |

## Configuration Files

The system supports configuration via:

1. **Environment variables** (highest priority)
2. **`.env` file** in the project root
3. **`config.yaml`** or **`config.json`** in the `config/` directory
4. **Default values** (lowest priority)

### Example `.env` File

```env
APP_ENV=development
APP_NAME=growth-engine
LOG_LEVEL=debug

HOST=0.0.0.0
PORT=8080

DATABASE_URL=postgres://user:password@localhost:5432/growth_engine
DATABASE_MAX_CONNECTIONS=10

BROKER_URL=redis://localhost:6379/0

AGENT_WORKTREE_BASE=./.sidekick-selfhosted/worktrees
AGENT_TIMEOUT=300
AGENT_MAX_RETRIES=3
```

### Example `config.yaml`

```yaml
app:
  env: development
  name: growth-engine
  log:
    level: debug
    format: json

server:
  host: 0.0.0.0
  port: 8080

database:
  url: postgres://user:password@localhost:5432/growth_engine
  max_connections: 10

broker:
  url: redis://localhost:6379/0
  queue_prefix: growth-engine

agent:
  worktree_base: ./.sidekick-selfhosted/worktrees
  timeout: 300
  max_retries: 3
```

## Tools Configuration

The agent tools (as defined in `_brief.md`) are configured through the agent environment variables above. The available tools include:

- **`read_file`**: Reads UTF-8 text files relative to the working directory.
- **`write_file`**: Creates or overwrites files with exact content.
- **`edit_file`**: Replaces the first occurrence of a string in a file.
- **`list_dir`**: Lists files under a directory.
- **`run_bash`**: Executes shell commands in the working directory.
- **`finish`**: Signals subtask completion with a summary.

These tools operate within isolated git worktrees and respect the project's isolation principles.