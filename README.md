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
  development.dotnet.enable = true;

  # Desktop (NixOS only)
  desktop.hyprland.enable = true;

  # Services
  services.docker.enable = true;

  # etc...
};
```

### .NET Development

The .NET module provides comprehensive support for .NET development with flexible configuration options:

**Simple SDK (latest stable):**

```nix
myConfig = {
  development.dotnet.enable = true;
  # Uses .NET SDK 8.x by default with Entity Framework tools
};
```

**Multiple SDK versions:**

```nix
myConfig = {
  development.dotnet.enable = true;
  development.dotnet.sdkVersions = [ "8" "9" ];  # Install multiple versions
  development.dotnet.entityFramework.enable = true;
};
```

**Runtime-only (for deployment/production):**

```nix
myConfig = {
  development.dotnet.enable = true;
  development.dotnet.runtimeOnly = true;
  development.dotnet.runtimeVersions = [ "8" ];
  development.dotnet.aspnetcore.enable = true;
  development.dotnet.aspnetcore.versions = [ "8" ];
};
```

**Full development setup:**

```nix
myConfig = {
  development.dotnet.enable = true;
  development.dotnet.sdkVersions = [ "8" "9" ];

  # ASP.NET Core
  development.dotnet.aspnetcore.enable = true;
  development.dotnet.aspnetcore.versions = [ "8" "9" ];

  # Tools
  development.dotnet.entityFramework.enable = true;
  development.dotnet.globalTools = {
    enableOutdated = true;      # dotnet-outdated
    enableRepl = true;           # Interactive C# REPL
    enableFormatters = true;     # CSharpier, Fantomas
    enablePaket = false;         # Paket dependency manager
  };

  # Custom NuGet sources
  development.dotnet.nuget = {
    enableCustomSources = true;
    sources = {
      "myget" = "https://www.myget.org/F/my-feed/api/v3/index.json";
      "github" = "https://nuget.pkg.github.com/myorg/index.json";
    };
  };
};
```

**F# development:**

```nix
myConfig = {
  development.dotnet.enable = true;
  development.dotnet.sdkVersions = [ "9" ];
  development.dotnet.globalTools = {
    enableFormatters = true;  # Includes Fantomas for F#
    enablePaket = true;       # Popular in F# community
  };
};
```

**Available options:**

- **`sdkVersions`**: List of SDK versions (`"6"`, `"7"`, `"8"`, `"9"`, `"10"`)
- **`runtimeOnly`**: Install only runtime (no SDK)
- **`runtimeVersions`**: Runtime versions when `runtimeOnly = true`
- **`aspnetcore.enable`**: Install ASP.NET Core runtime
- **`aspnetcore.versions`**: Specific ASP.NET Core versions
- **`entityFramework.enable`**: Install Entity Framework Core tools (default: true)
- **`globalTools.enableOutdated`**: Install dotnet-outdated
- **`globalTools.enableRepl`**: Install dotnet-repl (C# REPL)
- **`globalTools.enableFormatters`**: Install CSharpier and Fantomas
- **`globalTools.enablePaket`**: Install Paket dependency manager
- **`nuget.enableCustomSources`**: Enable custom NuGet sources
- **`nuget.sources`**: Attribute set of custom NuGet sources
- **`nuget.configFile`**: Path to custom NuGet.Config file

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

### Interactive Bootstrap (Recommended)

Use the interactive bootstrap script to set up a new host configuration:

```bash
./bootstrap.sh
```

This script will:

- Detect your platform (NixOS or Darwin) and architecture
- Guide you through selecting which features to enable
- Generate a complete host configuration in `hosts/<hostname>/default.nix`
- For NixOS: copy or generate `hardware-configuration.nix`
- Provide instructions for updating the appropriate flake
- Update `rebuild.sh` to recognize the new hostname

The bootstrap script asks about:

- **Development tools**: Rust, Node.js, Go, Python, Java, Zig, Android SDK, DevOps tools
- **Desktop environment** (NixOS only): Hyprland, Waybar, GTK, X Server
- **Hardware support** (NixOS only): NVIDIA GPU, graphics, audio
- **System services**: Docker, Podman, Minecraft server, observability
- **Shell & editors**: Fish shell, Neovim (with optional nightly builds), Git config

### Hardware Detection (NixOS)

Before bootstrapping a NixOS host, you can run the hardware detection script:

```bash
./scripts/detect-hardware.sh
```

This will detect your CPU, GPU, audio, network hardware, and provide configuration suggestions.

### Manual Setup

If you prefer to set up a host manually:

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

## Home Manager Configuration

Home Manager configurations are organized to be generic and reusable across hosts:

```
home/
├── common/              # Shared cross-platform user config
│   ├── git.nix         # Git configuration
│   ├── shell.nix       # Shell setup
│   └── packages.nix    # User packages
├── modules/            # Optional home-manager modules
│   └── gtk-theming.nix # GTK theming (opt-in)
├── nixos/
│   └── default.nix     # Generic NixOS home config
└── darwin/
    └── default.nix     # Generic Darwin home config
```

### Key Principles

**Generic Base Configs:**
- `home/nixos/default.nix` and `home/darwin/default.nix` are generic templates
- They dynamically read username and settings from host configuration
- No personal preferences or hardcoded values
- Safe to use when bootstrapping new hosts

**Personal Overrides:**
- Create `hosts/<hostname>/home.nix` for host-specific home-manager config
- Contains your personal preferences (themes, packages, etc.)
- Not copied when bootstrapping new hosts

**Example: Personal GTK Theming**

Enable optional GTK theming in your host-specific home config:

```nix
# hosts/nixos-desktop/home.nix
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable GTK theming with personal preferences
  homeModules.gtkTheming = {
    enable = true;
    theme = "Juno";
    themePackage = pkgs.juno-theme;
    iconTheme = "Papirus-Dark";
    iconThemePackage = pkgs.papirus-icon-theme;
    cursorTheme = "Bibata-Modern-Classic";
    cursorThemePackage = pkgs.bibata-cursors;
    font = {
      name = "TeX Gyre Adventor";
      size = 10;
    };
  };

  # Personal packages
  home.packages = with pkgs; [
    steam
  ];
}
```

Then import it in your flake:

```nix
# nixos/flake.nix
home-manager = {
  useGlobalPkgs = true;
  useUserPackages = true;
  users.braden = {
    imports = [
      ../home/nixos          # Generic base config
      ../hosts/nixos-desktop/home.nix  # Personal overrides
    ];
  };
  extraSpecialArgs = {
    inherit inputs;
    osConfig = config;  # Pass system config to home-manager
  };
};
```

**Important:** Always pass `osConfig = config` in `extraSpecialArgs` so home-manager can read username and state version from the system configuration.

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

## Helper Scripts

### `bootstrap.sh`

Interactive script for creating new host configurations. Guides you through all configuration options and generates everything needed for a new host.

**Usage:**

```bash
./bootstrap.sh
```

### `scripts/detect-hardware.sh`

Detects hardware on NixOS systems and suggests appropriate configuration options. Identifies GPU (NVIDIA/AMD/Intel), CPU, audio hardware, network devices, Bluetooth, storage, and virtualization.

**Usage:**

```bash
./scripts/detect-hardware.sh
```

### `scripts/new-host-template.sh`

Template generator called by `bootstrap.sh`. Can be used standalone to generate host configurations programmatically.

**Usage:**

```bash
./scripts/new-host-template.sh \
  --platform nixos \
  --hostname my-laptop \
  --username myuser \
  --fullname "My Name" \
  --arch x86_64-linux \
  --rust true \
  --nodejs true
  # ... (see bootstrap.sh for all options)
```
