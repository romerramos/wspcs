# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.2] - 2025-08-26

### Added

- **Workspace command support** - Added `command` field to workspace configuration
  - Allows running custom commands in the first window of the tmux session
  - Perfect for workspace-wide monitoring tools (htop, docker stats, etc.)
  - Optional field - workspace behaves normally if not specified
- **Project command support** - Added `command` field to project configuration
  - Allows running custom commands in the terminal pane of each project window
  - Defaults to "clear" if not specified, maintaining backward compatibility
  - Perfect for project-specific commands (npm run dev, make watch, etc.)

## [0.0.1] - 2025-08-24

### 🎉 Initial Release

This is the **initial pre-production release** of Workspace Manager (`wspcs`) - a tmux workspace automation tool that streamlines development environment setup through YAML configuration files.

### Added

#### Core Features

- **Automated tmux session management** - Create and manage tmux sessions from YAML config
- **Multi-project workspace support** - Handle multiple projects in a single session
- **Smart window layout** - Auto-splits windows (75% nvim, 25% terminal)
- **Session detection** - Attaches to existing sessions or creates new ones
- **Path validation** - Checks project directories before creating windows

#### Installation & Distribution

- **One-line installation** via curl pipe to bash
- **Cross-platform binaries** for macOS (Intel/ARM), Linux (x86_64/ARM64), Windows
- **Automated build system** with Makefile for all platforms
- **Clean uninstall script** for easy removal

#### Developer Experience

- **Simple YAML configuration** with name and projects array
- **Command-line interface** with `-f` flag for config files
- **Comprehensive documentation** with examples and usage patterns
- **Example configuration** included for quick start

### Project Structure

```
wspcs/
├── main.go              # CLI entry point
├── config/              # YAML parsing package
├── tmux/               # tmux session management
├── scripts/            # Install/uninstall scripts
├── resources/          # Example configurations
├── Makefile           # Cross-platform build
└── README.md          # Complete documentation
```

### Technical Details

- **Language**: Go 1.25.0
- **Dependencies**: `gopkg.in/yaml.v3`
- **Platforms**: macOS, Linux, Windows (AMD64/ARM64)
- **Installation**: `/usr/local/bin` or `~/.local/bin`

### Usage

```bash
# Install
curl -sSL https://raw.githubusercontent.com/romerramos/wspcs/main/scripts/install.sh | bash

# Run with config file
wspcs -f my-workspace.yml
```

### Notes

This initial release provides a solid foundation for tmux workspace automation. Future enhancements may include additional window layouts, custom commands, and extended configuration options.

---

_This release represents a simple workspace management solution ready for development use._
