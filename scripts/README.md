# Bootstrap Scripts

Helper scripts for creating and managing NixOS/Darwin host configurations.

## Scripts Overview

### `bootstrap.sh` (Main Script)

Interactive bootstrap script that guides you through creating a new host configuration.

**Features:**

- Auto-detects platform (NixOS/Darwin) and architecture
- Interactive prompts for all configuration options
- Generates complete host configuration
- Handles hardware-configuration.nix for NixOS
- Updates flake configuration (with guidance)
- Updates rebuild.sh automatically
- Optional git commit

**Usage:**

```bash
./bootstrap.sh
```

The script will prompt you for:

1. Platform selection (NixOS or Darwin)
2. Architecture (x86_64, aarch64)
3. Hostname and user information
4. Development tools (Rust, Node.js, Go, Python, Java, Zig, Android, DevOps)
5. Editors and shell (Neovim, Fish, Git config, CLI tools)
6. Platform-specific options:
   - **NixOS**: Desktop environment, hardware support, services
   - **Darwin**: Homebrew, system defaults, applications
7. State version

### `new-host-template.sh` (Template Generator)

Generates host configuration files from command-line arguments. Called by `bootstrap.sh` but can be used standalone.

**Usage:**

```bash
./scripts/new-host-template.sh \
  --platform nixos \
  --hostname my-laptop \
  --username myuser \
  --fullname "My Name" \
  --arch x86_64-linux \
  --rust true \
  --nodejs true \
  --go true \
  --state-version 24.11
```

**Available Options:**

Platform options:

- `--platform` - "nixos" or "darwin"
- `--hostname` - Host name
- `--username` - Primary user
- `--fullname` - Full name
- `--arch` - Architecture (x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin)
- `--state-version` - NixOS/Darwin state version

Development tools:

- `--rust`, `--nodejs`, `--go`, `--python`, `--java`, `--zig` - true/false
- `--android`, `--devops`, `--openssl` - true/false
- `--podman` (Darwin), `--docker` (NixOS) - true/false

Editors and shell:

- `--neovim`, `--neovim-nightly` - true/false
- `--fish`, `--git`, `--clitools` - true/false

NixOS-specific:

- `--desktop`, `--hyprland`, `--waybar`, `--gtk`, `--xserver` - true/false
- `--nvidia`, `--graphics` - true/false
- `--boot`, `--latest-kernel` - true/false
- `--system`, `--networking`, `--ssh`, `--security`, `--audio`, `--locale` - true/false
- `--timezone` - Timezone string
- `--docker-data-root` - Docker data directory
- `--observability`, `--minecraft`, `--nixos-clitools` - true/false

Darwin-specific:

- `--homebrew`, `--system-defaults`, `--applications` - true/false
- `--computer-name` - Display name for the computer

### `detect-hardware.sh` (Hardware Detection)

NixOS-only script that detects hardware and suggests appropriate configuration options.

**Features:**

- Detects CPU (AMD/Intel) and suggests microcode updates
- Detects GPU (NVIDIA/AMD/Intel) and suggests drivers
- Detects audio hardware
- Detects network interfaces and WiFi
- Detects Bluetooth
- Detects storage type (NVMe, SSD)
- Detects virtualization (KVM, VMware, VirtualBox)
- Detects laptop touchpad
- Provides configuration snippet suggestions

**Usage:**

```bash
./scripts/detect-hardware.sh
```

Run this before bootstrapping a NixOS host to get hardware-specific recommendations.

## Workflow Examples

### New NixOS Desktop

```bash
# 1. Detect hardware (optional but recommended)
./scripts/detect-hardware.sh

# 2. Run bootstrap
./bootstrap.sh
# - Select NixOS
# - Enable desktop, Hyprland, etc.
# - Enable NVIDIA if detected
# - Enable development tools as needed

# 3. Manually add to nixos/flake.nix (as instructed by bootstrap)

# 4. Test and apply
sudo nixos-rebuild build --flake ./nixos#new-hostname
./rebuild.sh
```

### New Darwin (macOS) Laptop

```bash
# 1. Run bootstrap
./bootstrap.sh
# - Select Darwin
# - Choose architecture (Apple Silicon vs Intel)
# - Enable development tools
# - Enable Homebrew and system defaults

# 2. Manually add to darwin/flake.nix (as instructed by bootstrap)

# 3. Test and apply
darwin-rebuild build --flake ./darwin#new-hostname
./rebuild.sh
```

### Programmatic Host Creation

```bash
# Create a minimal server configuration
./scripts/new-host-template.sh \
  --platform nixos \
  --hostname server-01 \
  --username admin \
  --fullname "Admin User" \
  --arch x86_64-linux \
  --rust false \
  --nodejs false \
  --go true \
  --desktop false \
  --boot true \
  --networking true \
  --ssh true \
  --docker true \
  --state-version 24.11

# Then manually add to nixos/flake.nix and update rebuild.sh
```

## Notes

- The bootstrap script will **not** automatically edit your flake.nix due to the complexity of the file structure. Instead, it provides you with the exact configuration block to add.
- For NixOS, make sure to generate or copy `hardware-configuration.nix` - the bootstrap script will help with this.
- Always test your configuration with `build` before applying with `switch`.
- The scripts preserve your existing hosts and configurations - they only add new ones.
- State versions should match your NixOS/Darwin release version at the time of first install.

## Troubleshooting

**"nixos-generate-config not found"**

- This command is only available on NixOS systems
- If bootstrapping from another system, you'll need to copy hardware-configuration.nix manually after installation

**"Failed to update rebuild.sh"**

- The script creates a backup at `rebuild.sh.bak`
- You can manually add the host case statement to rebuild.sh if automatic update fails

**"Configuration build failed"**

- Check that you've added the host to the correct flake (nixos/flake.nix or darwin/flake.nix)
- Verify all referenced modules exist
- Check syntax of generated configuration
