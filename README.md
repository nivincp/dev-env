# dev-env

Minimal development environment tooling for use inside a VS Code Dev Container.

This repo is intentionally small and explicit: shell scripts over magic, reproducible setup.


## Structure

```
├── .devcontainer/
│   └── devcontainer.json   # VS Code devcontainer config (Debian + zsh)
├── scripts/
│   ├── setup.sh            # Bootstrap dev tools (asdf, Node LTS, AWS, Terraform, etc.)
│   ├── context.sh          # Generate context.md for LLMs
│   ├── aws.sh              # Common AWS CLI commands
│   ├── terraform.sh        # Terraform workflow helpers
│   ├── git.sh              # Git helpers
│   ├── utils.sh            # Small utility helpers
│   └── .zshrc              # Shell aliases (container-local)
├── stacks/
│   ├── postgres.yaml       # Local Postgres (Docker Compose)
│   ├── glances.yaml        # Glances system monitor
│   └── makefile            # Convenience targets for stacks
├── .gitignore
└── README.md
```

## Dev Container

- Base image: **Debian (trixie)**
- Default shell: **zsh**
- VS Code extensions:
  - ESLint
  - Prettier
  - Terraform
  - Hurl
  - Markdown tools

Open the repo in VS Code and choose **“Reopen in Container”**.

## Setup

Run once inside the container:

```bash
./scripts/setup.sh
```

This installs:

- asdf
- Node.js (latest LTS via asdf)
- AWS CLI v2
- Terraform
- Hurl
- Required system packages

Re-running the script is safe.

**Node.js**

Managed via asdf.

```
node -v
npm -v
```

The script always tracks the current LTS (no hard-coded versions).

## Context for LLMs

Generate a single markdown file containing the full repo context:


```bash
./scripts/context.sh .
```

Output:

- context.md (gitignored)
- Skips binaries, build artifacts, and noise
- Useful for pasting into ChatGPT / Claude / etc.

**Docker Stacks**

Postgres

```bash
make pg-up
make pg-down
make pg-psql
make pg-reset
```

Config: stacks/postgres.yaml

Glances (system monitor)

```bash
make glances-up
make glances-logs
```

Web UI: http://localhost:61208

## Helper commands

- Terraform: `./scripts/terraform.sh`
- AWS: `./scripts/aws.sh`

## Notes

- This repo assumes ARM64 Linux (devcontainers, Apple Silicon, cloud VMs)
- Tool versions are managed intentionally (asdf over system installs)
- Scripts favor clarity over abstraction

