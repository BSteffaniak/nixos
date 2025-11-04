{ rust-overlay }:
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
]
