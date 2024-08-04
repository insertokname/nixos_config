{ ... }: {
  programs.vscode = { enable = true; };

  home.file = {
    ".config/code-flags.conf".text =
      "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform=wayland";
  };
}
