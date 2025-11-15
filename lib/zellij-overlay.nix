{ zellij-fork }:
[
  (
    final: prev:
    let
      # Use narHash to ensure version changes when source content changes
      # Extract first 8 chars of narHash for compact version string
      # This is PURE and guaranteed to change when source changes
      narHashShort =
        if zellij-fork.narHash != "" then
          builtins.substring 7 8 zellij-fork.narHash # Skip "sha256-" prefix
        else
          "unknown";
    in
    {
      zellij-custom =
        let
          # Zellij requires Rust 1.90.0 (specified in rust-toolchain.toml)
          # Use rust-overlay to get the exact version
          rust-toolchain = final.rust-bin.stable."1.90.0".default.override {
            extensions = [
              "rust-src"
              "clippy"
              "rustfmt"
            ];
            targets = [
              "wasm32-wasip1" # Required for Zellij plugins
              "x86_64-unknown-linux-gnu"
            ];
          };

          # Create a custom rustPlatform with the correct Rust version
          customRustPlatform = final.makeRustPlatform {
            cargo = rust-toolchain;
            rustc = rust-toolchain;
          };
        in
        customRustPlatform.buildRustPackage rec {
          pname = "zellij";
          # Version now includes narHash which changes with ANY source change
          # This guarantees a rebuild when you update the flake input
          version = "0.44.0-${zellij-fork.ref}-${narHashShort}-${builtins.substring 0 7 zellij-fork.rev}";

          src = zellij-fork.src;

          # Patch the VERSION constant directly in source code
          # This avoids modifying Cargo.toml/Cargo.lock which would break the FOD hash
          postPatch = ''
            # Replace env!("CARGO_PKG_VERSION") with our full Nix version string
            # This ensures the cache directory path includes the full version
            sed -i 's|env!("CARGO_PKG_VERSION")|"${version}"|' zellij-utils/src/consts.rs
          '';

          # This will be replaced with the correct hash after first build attempt
          cargoHash = "sha256-eK26nQYLVlqHkZu6nwWmc/12TLUsq2o47T8SlK8yvcA=";

          # Build dependencies from upstream zellij package
          nativeBuildInputs = with final; [
            pkg-config
            installShellFiles
            copyDesktopItems
            makeWrapper
            perl # Required for openssl-sys build
          ];

          buildInputs =
            with final;
            [
              openssl
              openssl.dev # Add dev output for headers
              curl
              zstd
            ]
            ++ final.lib.optionals final.stdenv.isDarwin [
              final.darwin.apple_sdk.frameworks.DiskArbitration
              final.darwin.apple_sdk.frameworks.Foundation
              final.darwin.apple_sdk.frameworks.Security
              final.libiconv
            ];

          # Use system OpenSSL instead of compiling from source
          OPENSSL_NO_VENDOR = "1";
          PKG_CONFIG_PATH = "${final.openssl.dev}/lib/pkgconfig";

          # Disable tests that might fail in nix build sandbox
          doCheck = false;

          # Set HOME for build process
          preConfigure = ''
            export HOME=$TMPDIR
          '';

          # Post-install: shell completions and man pages
          postInstall = ''
            # Install shell completions
            installShellCompletion --cmd zellij \
              --bash <($out/bin/zellij setup --generate-completion bash) \
              --fish <($out/bin/zellij setup --generate-completion fish) \
              --zsh <($out/bin/zellij setup --generate-completion zsh)

            # Install man pages
            mandir=$out/share/man
            mkdir -p $mandir/man1
          '';

          meta = with final.lib; {
            description = "Zellij - A terminal workspace (custom fork with ToggleSession support)";
            homepage = "https://zellij.dev";
            changelog = "https://github.com/zellij-org/zellij/blob/v${version}/CHANGELOG.md";
            license = licenses.mit;
            mainProgram = "zellij";
            maintainers = [ ];
            platforms = platforms.unix;
          };
        };
    }
  )
]
