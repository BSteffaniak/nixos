# Auto-discovered overlay for ra-multiplex
# Enable with: enableRaMultiplex = true
{
  inputs,
  enable ? true,
  mkGitInput ? null,
}:
if !enable then
  [ ]
else
  let
    ra-multiplex-src = inputs.ra-multiplex or null;
  in
  if ra-multiplex-src == null then
    [ ]
  else
    [
      (final: prev: {
        ra-multiplex-latest = final.rustPlatform.buildRustPackage {
          pname = "ra-multiplex";
          version = "unstable";

          src = ra-multiplex-src;

          cargoHash = "sha256-pwgNtxnO3oyX/w+tzRY5vAptw5JhpRhKCB2HYLEuA3A=";
        };
      })
    ]
