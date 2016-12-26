{ config, pkgs, ... }:

{
  imports = [
    ## hardware:
    ./hardware/grub.nix
    
    ## software:
    ../profiles/virtualization.nix
  ];
}