{ ... }: {
  flake.modules.nixos.programming = { pkgs-master, ... }: {
    environment.systemPackages = [
      (pkgs-master.writeShellApplication {
        name = "zexlaude";

        text = ''
          mkdir -p ~/.claude_alternate_accounts/zexlaude/
          export CLAUDE_CONFIG_DIR=~/.claude_alternate_accounts/zexlaude/

          exec ${pkgs-master.claude-code}/bin/claude "$@"
        '';
      })
    ];
  };
}
