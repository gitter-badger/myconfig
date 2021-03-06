{ config, pkgs, ... }:

{
  imports = [
    ## hardware:
    ./hardware/grub.nix
    ./hardware/quadroFX4800.nix
    ./hardware/steamcontroller.nix

    ## software:
    ../profiles/desktop
    ../profiles/desktop/xfce.nix
    ../profiles/virtualization
    ../profiles/mail.nix
    ../profiles/desktop/imagework.nix
    ../profiles/desktop/games.nix
    ../profiles/wine.nix
    ../profiles/openssh.nix

    ../profiles/vsftp.nix

    ../profiles/desktop/vnc.nix
  ];
}
