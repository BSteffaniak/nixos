# NixOs Configuration

## How to apply changes

`sudo cp ./* /etc/nixos/ && sudo nixos-rebuild switch`

## How to update flake

`nix flake update`

## How to upgrade packages

`sudo cp ./* /etc/nixos/ && sudo nixos-rebuild switch --upgrade`
