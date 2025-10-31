#!/usr/bin/env bash
sudo cp ./* /etc/nixos/

# Build a new argument array without --boot
filtered_args=()
boot=false
for arg in "$@"; do
    if [[ "$arg" != "--boot" ]] || [[ "$boot" == "true" ]]; then
        filtered_args+=("$arg")
    else
        boot=true
    fi
done

if [[ "$boot" == true ]]; then
    sudo nixos-rebuild boot "${filtered_args[@]}"
else
    sudo nixos-rebuild switch "$@"
fi
