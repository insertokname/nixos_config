{ inputs, ... }:
{
  flake.modules.nixos.fekete = { pkgs, username, ... }: {
    imports = [ inputs.nixvirt.nixosModules.default ];

    boot.kernelModules = [ "nbd" ];

    virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      qemu_kvm
      virt-viewer
    ];

    users.users.${username}.extraGroups = [
      "libvirtd"
      "kvm"
    ];

    virtualisation.libvirt.enable = true;
  };

}
