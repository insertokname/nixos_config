{ ... }:
{
  flake.modules.nixos.base = {
    users.mutableUsers = true;
    programs.fuse.userAllowOther = true;
  };
}
