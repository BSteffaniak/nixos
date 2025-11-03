nixpkgs-unstable:
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
      version = "unstable-2024-08-30";

      src = final.fetchFromGitHub {
        owner = "pr2502";
        repo = "ra-multiplex";
        rev = "master";
        sha256 = "12x3rm9swnx21wllpbfwg5q4jvjr5ha6jn13dg2gjsbp0swbzqly";
      };

      cargoHash = "sha256-PnZh6wBMul3D4lsUQdn7arF2Qng2vdqtZHpPOtN59eU=";
    };
  })
]
