# Workspace Manager

A tmux workspace manager that creates development environments based on YAML configuration files.

## Features

- Creates tmux sessions with multiple project windows
- Automatically opens nvim in each project directory
- Splits windows with terminal panes for easy development workflow
- Attaches to existing sessions or creates new ones

## Prerequisites

- tmux installed and available in PATH

## Installation

### One-Line Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/romerramos/wspcs/main/scripts/install.sh | bash
```

This will automatically:

- Detect your OS and architecture
- Download the appropriate binary
- Install to `/usr/local/bin` (or `~/.local/bin` if no sudo access)
- Make it executable and available in your PATH

### Uninstall

```bash
curl -sSL https://raw.githubusercontent.com/romerramos/wspcs/main/scripts/uninstall.sh | bash
```

### Manual Installation

#### Quick Build (Current Platform)

```bash
go build -o wspcs
```

#### Cross-Platform Build

The project includes a Makefile for building across multiple platforms:

```bash
# Build for all platforms
make all

# Build for specific platforms
make mac-amd64      # macOS Intel
make mac-arm64      # macOS Apple Silicon
make linux-amd64    # Linux x86_64
make linux-arm64    # Linux ARM64
make windows-amd64  # Windows x86_64

# Clean build artifacts
make clean
```

Built binaries will be placed in the `dist/` directory with platform-specific names:

- `wspcs-mac-amd64`
- `wspcs-mac-arm64`
- `wspcs-linux-amd64`
- `wspcs-linux-arm64`
- `wspcs-windows-amd64.exe`

## Usage

```bash
./wspcs -f <workspace-config-file>
```

### Example

```bash
./wspcs -f my-workspace.yml
```

## Workspace Configuration

Create a YAML file with your workspace configuration:

```yaml
name: "my-workspace"
projects:
  - name: "frontend"
    path: "/path/to/frontend"
  - name: "backend"
    path: "/path/to/backend"
  - name: "docs"
    path: "/path/to/documentation"
```

### Configuration Format

- `name`: The name of the tmux session
- `projects`: Array of projects to include
  - `name`: Display name for the tmux window
  - `path`: Absolute path to the project directory

## How it Works

1. **Session Check**: Checks if a tmux session with the given name already exists
2. **Attach or Create**: If exists, attaches to it. Otherwise, creates a new session
3. **Project Windows**: For each project:
   - Creates a new tmux window
   - Sets working directory to project path
   - Splits window vertically (75% nvim, 25% terminal)
   - Opens nvim in the main pane
   - Clears the terminal pane
4. **Attach**: Finally attaches to the session

## Window Layout

Each project gets a tmux window with this layout:

```
┌─────────────────────────┐
│                         │
│        nvim             │
│                         │
├─────────────────────────┤
│      terminal           │
└─────────────────────────┘
```

## Example Workspace File

See `workspace.example.yml` for a complete example configuration.

