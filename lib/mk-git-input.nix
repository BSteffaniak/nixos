{ lockFile }:
inputName: input:
let
  lockData = builtins.fromJSON (builtins.readFile lockFile);
  inputLock = lockData.nodes.${inputName} or { };
in
{
  src = input;
  inherit inputName;
  rev = inputLock.locked.rev or "unknown";
  ref = inputLock.original.ref or "unknown";
  narHash = inputLock.locked.narHash or "";
}
