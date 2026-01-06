# workon

Spin up isolated git worktrees and launch [Claude Code](https://claude.ai/code) to work on tasks.

## What it does

`workon` streamlines parallel development by creating isolated git worktrees for each task. No more stashing, no more branch switching chaos.

```bash
cd ~/projects/my-app
workon "add dark mode to settings page"
```

This will:
1. Generate a clean branch name using AI (e.g., `feat/dark-mode-settings`)
2. Create a worktree in `.worktrees/feat/dark-mode-settings/`
3. Run your prework script (copy `.env`, symlink `node_modules`, etc.)
4. Launch Claude Code with your task description

## Installation

```bash
git clone https://github.com/luckybucky9/workon.git
cd workon
./install.sh
```

Or manually:
```bash
curl -o ~/bin/workon https://raw.githubusercontent.com/luckybucky9/workon/main/workon
chmod +x ~/bin/workon
```

### Requirements

- Git
- [Claude Code CLI](https://claude.ai/code)
- `jq` (optional, for AI branch naming)
- `OPENAI_API_KEY` env var (optional, for AI branch naming)

## Usage

### Initialize a project

```bash
cd ~/projects/my-app
workon init
```

This creates a `.workon/` folder with prework/postwork scripts. Choose from templates:
- **nextjs** — Copy `.env.local`, symlink `node_modules`
- **node** — Copy `.env`, symlink `node_modules`
- **python** — Copy `.env`, create virtualenv
- **go** — Copy `.env`, download modules
- **rust** — Copy `.env`, symlink `target/`
- **generic** — Empty scripts for customization

### Start working on a task

```bash
workon "implement user authentication"
workon fix the memory leak in websocket handler
workon -b hotfix/urgent-fix "fix production bug"
```

### List active worktrees

```bash
workon --list
```

### Clean up when done

```bash
workon --done feat/user-authentication
```

This runs your postwork script and removes the worktree and branch.

## Configuration

### Directory structure

```
my-repo/
├── .workon/
│   ├── prework.sh      # Runs after worktree creation
│   └── postwork.sh     # Runs before worktree removal
├── .worktrees/         # Worktrees live here (gitignored)
│   ├── feat/add-auth/
│   └── fix/memory-leak/
└── src/
```

### Hook scripts

Scripts receive these environment variables:

| Variable | Description |
|----------|-------------|
| `WORKON_MAIN_REPO` | Path to the main repository |
| `WORKON_WORKTREE` | Path to the worktree |
| `WORKON_BRANCH` | Branch name |
| `WORKON_DESCRIPTION` | Task description (prework only) |

### Example prework.sh

```bash
#!/bin/bash
set -e

# Copy environment files
cp "$WORKON_MAIN_REPO/.env.local" "$WORKON_WORKTREE/.env.local"

# Symlink node_modules (saves disk space and install time)
ln -s "$WORKON_MAIN_REPO/node_modules" "$WORKON_WORKTREE/node_modules"

# Or run fresh install if you prefer isolation
# npm install
```

## Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help |
| `-v, --version` | Show version |
| `-n, --dry-run` | Preview without making changes |
| `-b, --branch NAME` | Use custom branch name |
| `--no-claude` | Create worktree without launching Claude |
| `--list` | List active worktrees |
| `--done BRANCH` | Clean up a worktree |

## Tips

### Symlink vs Copy

**Symlink `node_modules`** when you want speed and don't need to modify dependencies:
```bash
ln -s "$WORKON_MAIN_REPO/node_modules" "$WORKON_WORKTREE/node_modules"
```

**Copy or fresh install** when you might add/remove packages:
```bash
cp -r "$WORKON_MAIN_REPO/node_modules" "$WORKON_WORKTREE/node_modules"
# or
npm install
```

### Multiple worktrees

You can have many worktrees active at once. Each is a full copy of your repo on a different branch:

```bash
workon "feature A"   # Terminal 1
workon "feature B"   # Terminal 2
workon "bug fix"     # Terminal 3
```

### Without AI branch names

If you don't have `OPENAI_API_KEY` set, branch names are generated from your description:
- "add user auth" → `add-user-auth`
- "fix login bug" → `fix-login-bug`

## License

MIT
