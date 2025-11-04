{ nixpkgs-unstable, ra-multiplex-src }:
[
  (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit (prev) system;
      config.allowUnfree = true;
    };
  })

  (final: prev: {
    ra-multiplex-latest = final.rustPlatform.buildRustPackage {
      pname = "ra-multiplex";
      version = "unstable";

      src = ra-multiplex-src;

      cargoHash = "sha256-pwgNtxnO3oyX/w+tzRY5vAptw5JhpRhKCB2HYLEuA3A=";
    };
  })
]
