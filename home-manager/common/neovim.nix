{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    withRuby = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      gruvbox-nvim
    ];
    extraLuaConfig = ''
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.autoindent = true
      vim.opt.smartindent = true
      vim.opt.smarttab = true
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "nix",
        callback = function()
          vim.opt_local.tabstop = 2
          vim.opt_local.shiftwidth = 2
          vim.opt_local.softtabstop = 2
          vim.opt_local.expandtab = true
        end,
      })

      vim.opt.list = true
      vim.opt.listchars = "eol:.,tab:>-,trail:~,extends:>,precedes:<"

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
      vim.opt.scrolloff = 8

      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"

      vim.opt.clipboard = "unnamed"
      
      vim.opt.hlsearch = true
      vim.opt.incsearch = true
      vim.opt.ignorecase = true
      vim.opt.smartcase =true

      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      require("gruvbox").setup({
        contrast = "hard",
      })
      vim.cmd.colorscheme("gruvbox")
      
      '';
  };
}
