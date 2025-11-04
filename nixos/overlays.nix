{ nixpkgs-unstable, ra-multiplex-src, rust-overlay }:
[
  # Import rust-overlay
  (import rust-overlay)

  # Define stable and nightly toolchains
  (final: prev: {
    rustStable = final.rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
        "clippy"
        "rustfmt"
      ];
    };

    rustNightly = final.rust-bin.nightly.latest.default.override {
      extensions = [
        "rust-src"
        "clippy"
        "rustfmt"
        "llvm-tools-preview"
      ];
    };
  })

  # Create wrapper scripts for cargo and rustc
  (final: prev: {
    cargo-wrapped = final.writeShellScriptBin "cargo" ''
      case "$1" in
        +nightly)
          shift
          exec ${final.rustNightly}/bin/cargo "$@"
          ;;
        +stable)
          shift
          exec ${final.rustStable}/bin/cargo "$@"
          ;;
        *)
          exec ${final.rustStable}/bin/cargo "$@"
          ;;
      esac
    '';

    rustc-wrapped = final.writeShellScriptBin "rustc" ''
      case "$1" in
        +nightly)
          shift
          exec ${final.rustNightly}/bin/rustc "$@"
          ;;
        +stable)
          shift
          exec ${final.rustStable}/bin/rustc "$@"
          ;;
        *)
          exec ${final.rustStable}/bin/rustc "$@"
          ;;
      esac
    '';
  })

  # Unstable packages overlay
  (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit (prev) system;
      config.allowUnfree = true;
    };
  })

  # ra-multiplex overlay
  (final: prev: {
    ra-multiplex-latest = final.rustPlatform.buildRustPackage {
      pname = "ra-multiplex";
      version = "unstable";

      src = ra-multiplex-src;

      cargoHash = "sha256-pwgNtxnO3oyX/w+tzRY5vAptw5JhpRhKCB2HYLEuA3A=";
    };
  })
]
