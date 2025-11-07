{ rust-overlay }:
[
  # Import rust-overlay
  (import rust-overlay)

  # Define stable and nightly toolchains
  # These are always available in the overlay, but only included in systemPackages
  # based on the myConfig.development.rust.includeStable/includeNightly options
  (final: prev: {
    # Helper function to build extension list
    # Allows creating toolchains with configurable rust-src
    mkRustExtensions =
      {
        includeRustSrc ? true,
        extraExtensions ? [ ],
      }:
      (if includeRustSrc then [ "rust-src" ] else [ ]) ++ extraExtensions;

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

    # Configurable versions of the toolchains
    mkRustStable =
      {
        includeRustSrc ? true,
      }:
      final.rust-bin.stable.latest.default.override {
        extensions = final.mkRustExtensions {
          inherit includeRustSrc;
          extraExtensions = [
            "rust-analyzer"
            "clippy"
            "rustfmt"
          ];
        };
      };

    mkRustNightly =
      {
        includeRustSrc ? true,
      }:
      final.rust-bin.nightly.latest.default.override {
        extensions = final.mkRustExtensions {
          inherit includeRustSrc;
          extraExtensions = [
            "clippy"
            "rustfmt"
            "llvm-tools-preview"
          ];
        };
      };
  })

  # Create wrapper scripts for cargo and rustc
  # These wrappers support +nightly/+stable syntax for switching between toolchains
  # Only installed when both stable and nightly are enabled
  (final: prev: {
    mkCargoWrapper =
      {
        rustStable ? final.rustStable,
        rustNightly ? final.rustNightly,
      }:
      final.writeShellScriptBin "cargo" ''
        case "$1" in
          +nightly)
            shift
            exec ${rustNightly}/bin/cargo "$@"
            ;;
          +stable)
            shift
            exec ${rustStable}/bin/cargo "$@"
            ;;
          *)
            exec ${rustStable}/bin/cargo "$@"
            ;;
        esac
      '';

    mkRustcWrapper =
      {
        rustStable ? final.rustStable,
        rustNightly ? final.rustNightly,
      }:
      final.writeShellScriptBin "rustc" ''
        case "$1" in
          +nightly)
            shift
            exec ${rustNightly}/bin/rustc "$@"
            ;;
          +stable)
            shift
            exec ${rustStable}/bin/rustc "$@"
            ;;
          *)
            exec ${rustStable}/bin/rustc "$@"
            ;;
        esac
      '';

    # Default wrappers for backward compatibility
    cargo-wrapped = final.mkCargoWrapper { };
    rustc-wrapped = final.mkRustcWrapper { };
  })
]
