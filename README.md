# Braden's Nix Configuration

Modular, cross-platform Nix configuration supporting NixOS and macOS (nix-darwin).

## Split Flake Design

This repository uses **two separate flakes** in subdirectories to optimize dependencies:

- **`nixos/flake.nix`** - NixOS configurations only (no Darwin/Homebrew dependencies)
- **`darwin/flake.nix`** - macOS (Darwin) configurations with Homebrew integration

This ensures that building NixOS configurations doesn't download unnecessary Darwin-specific inputs like Homebrew repositories.

## Structure

```
.
├── nixos/
│   ├── flake.nix            # NixOS flake (no Darwin dependencies)
│   └── flake.lock           # NixOS locked dependencies
│
├── darwin/
│   ├── flake.nix            # Darwin flake (with Homebrew)
│   └── flake.lock           # Darwin locked dependencies
│
├── rebuild.sh               # Auto-detecting rebuild script (chooses correct flake)
│
├── hosts/                   # Per-machine configurations
│   ├── nixos-desktop/      # NixOS desktop PC
│   ├── macbook-air/        # MacBook Air (Apple Silicon)
│   └── mac-studio/         # Mac Studio
│
├── modules/                 # Reusable modules
│   ├── common/             # Cross-platform modules
│   │   ├── development/    # Dev tools (rust, node, go, python, etc.)
│   │   ├── shell/          # Shell configuration (fish, git)
│   │   ├── editors/        # Text editors (neovim)
│   │   └── cli-tools/      # CLI utilities (tmux, fzf, ripgrep, etc.)
│   │
│   ├── nixos/              # NixOS-specific modules
│   │   ├── boot/           # Boot configuration
│   │   ├── hardware/       # Hardware support (nvidia, graphics)
│   │   ├── desktop/        # Desktop environment (hyprland, waybar, gtk)
│   │   ├── services/       # System services (docker, observability, minecraft)
│   │   └── system/         # System configuration (networking, security, audio)
│   │
│   └── darwin/             # macOS-specific modules
│       ├── homebrew.nix    # Homebrew integration
│       ├── system-defaults.nix  # macOS system preferences
│       └── applications.nix     # Application management
│
├── home/                    # Home Manager configurations
│   ├── common/             # Cross-platform home config
│   ├── nixos/              # NixOS-specific home config
│   └── darwin/             # macOS-specific home config
│
└── lib/                     # Helper functions
    └── default.nix
```

## Quick Start

The `rebuild.sh` script automatically detects your platform and uses the correct flake.

```bash
# Auto-detect and rebuild
./rebuild.sh

# On NixOS: uses nixos#nixos-desktop
# On Darwin: uses darwin#macbook-air or mac-studio
```

### Manual Usage

**NixOS:**

```bash
# Build without applying
sudo nixos-rebuild build --flake ./nixos#nixos-desktop

# Apply configuration
sudo nixos-rebuild switch --flake ./nixos#nixos-desktop

# Boot into new config (safer)
sudo nixos-rebuild boot --flake ./nixos#nixos-desktop
```

**macOS (Darwin):**

```bash
# Build without applying
darwin-rebuild build --flake ./darwin#macbook-air

# Apply configuration
darwin-rebuild switch --flake ./darwin#macbook-air
```

## Available Hosts

- **nixos-desktop**: NixOS desktop PC with NVIDIA GPU, Hyprland, development tools
- **macbook-air**: MacBook Air (Apple Silicon) with development tools
- **mac-studio**: Mac Studio with development tools

## Customization

Each host can enable/disable features via the `myConfig` options in `hosts/*/default.nix`:

```nix
myConfig = {
  # Development
  development.rust.enable = true;
  development.nodejs.enable = true;
  development.go.enable = true;

  # Desktop (NixOS only)
  desktop.hyprland.enable = true;

  # Services
  services.docker.enable = true;

  # etc...
};
```

## Adding Packages

Understanding where to add packages based on their purpose and scope:

### Cross-Platform Packages (All Hosts)

**System-Level CLI Tools:**

- **Location:** `modules/common/cli-tools/default.nix`
- **Use for:** Command-line utilities, system tools (tmux, fzf, ripgrep, htop, etc.)
- **Example:**
  ```nix
  environment.systemPackages = with pkgs; [
    # ... existing packages
    yq  # Add new CLI tool here
  ];
  ```

**Development Tools:**

- **Location:** `modules/common/development/` (language-specific files)
- **Use for:** Programming language toolchains, build tools, linters
- **Example:** Add to `devops.nix` for infrastructure tools, or create new module
  ```nix
  # modules/common/development/devops.nix
  environment.systemPackages = with pkgs; [
    # ... existing packages
    terraform  # Add new devops tool
  ];
  ```

**User Applications (GUI/Desktop):**

- **Location:** `home/common/packages.nix`
- **Use for:** Personal applications, GUI tools, user-specific packages
- **Scope:** Installed for your user across all platforms
- **Example:**
  ```nix
  home.packages = with pkgs; [
    # ... existing packages
    spotify  # Add desktop app
  ];
  ```

### Platform-Specific Packages

**NixOS Only:**

- **Location:** Appropriate module in `modules/nixos/*/`
  - Desktop apps: `modules/nixos/desktop/*.nix`
  - System services: `modules/nixos/services/*.nix`
- **Example:**
  ```nix
  # modules/nixos/desktop/hyprland.nix
  environment.systemPackages = with pkgs; [
    # ... existing packages
    waybar-experimental  # Add Wayland-specific tool
  ];
  ```

**Darwin (macOS) Only:**

- **Location:** `modules/darwin/*.nix` or `home/darwin/default.nix`
- **Example:**
  ```nix
  # home/darwin/default.nix
  home.packages = with pkgs; [
    # ... existing packages
    rectangle  # Add macOS-specific app
  ];
  ```

**Single Host Only:**

- **Location:** `hosts/<hostname>/default.nix`
- **Use for:** Machine-specific packages (testing, hardware-specific tools)
- **Example:**
  ```nix
  # hosts/nixos-desktop/default.nix
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages."${pkgs.system}".default
    specialized-tool  # Only on this machine
  ];
  ```

### Quick Decision Guide

| I want to add...                    | Where?                                      |
| ----------------------------------- | ------------------------------------------- |
| CLI tool for all machines           | `modules/common/cli-tools/default.nix`      |
| Language toolchain (rust, go, etc.) | `modules/common/development/<language>.nix` |
| Desktop app for me (all platforms)  | `home/common/packages.nix`                  |
| NixOS desktop tool                  | `modules/nixos/desktop/*.nix`               |
| macOS-specific app                  | `home/darwin/default.nix`                   |
| Testing on one machine only         | `hosts/<hostname>/default.nix`              |

### After Adding Packages

1. Rebuild to test:

   ```bash
   sudo nixos-rebuild build --flake ./nixos#nixos-desktop  # NixOS
   # or
   darwin-rebuild build --flake ./darwin#macbook-air  # Darwin
   ```

2. Compare what changed:

   ```bash
   nvd diff /run/current-system ./result
   ```

3. Apply if satisfied:
   ```bash
   ./rebuild.sh
   ```

## Adding a New Host

1. Create a new directory in `hosts/` (e.g., `hosts/new-laptop/`)
2. Create `hosts/new-laptop/default.nix` based on existing examples
3. Add the host to the appropriate flake:
   - For NixOS: Edit `nixos/flake.nix` and add to `nixosConfigurations`
   - For Darwin: Edit `darwin/flake.nix` and add to `darwinConfigurations`
4. Update `rebuild.sh` to recognize the new hostname and point to correct flake directory

## Module System

All modules use NixOS module system options for configurability:

- **Common modules**: Available on all platforms
- **NixOS modules**: Linux-specific features
- **Darwin modules**: macOS-specific features

This allows sharing development tools, shell configurations, and CLI utilities across all machines while keeping platform-specific features separate.

### System vs User Packages

- **System packages** (`environment.systemPackages`): Available to all users, included in system PATH
- **User packages** (`home.packages`): Installed per-user via Home Manager, in user profile
- **Rule of thumb**: System services/tools → system packages; personal apps → user packages

## Updating

**NixOS:**

```bash
cd nixos
nix flake update                           # Update all inputs
nix flake lock --update-input nixpkgs     # Update specific input
cd ..
./rebuild.sh
```

**Darwin:**

```bash
cd darwin
nix flake update                           # Update all inputs
nix flake lock --update-input nixpkgs-darwin  # Update specific input
cd ..
./rebuild.sh
```
