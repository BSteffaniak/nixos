#!/usr/bin/env bash
sudo cp ./* /etc/nixos/
sudo nixos-rebuild switch $@
