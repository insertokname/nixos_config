{ ... }: {
  flake.modules.nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      gnome-keyring
    ];
    environment.variables = {
      GNOME_DESKTOP_SESSION_ID = "this-is-deprecated";
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
