{ newest_pkgs, ... }: {
  home.file = {
    ".config/code-flags.conf".text =
      "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform=wayland";
  };

  programs.vscode = {
    enable = true;
    package = newest_pkgs.vscode;
  };
}
