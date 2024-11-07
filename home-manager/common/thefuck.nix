{ ... }: {
  programs.thefuck = {
    enable = true;
    enableInstantMode = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
}
