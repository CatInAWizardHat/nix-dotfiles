{
  config,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nix-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    ghostty = "ghostty";
    vim = "vim";
  };
in {
  home.username = "hastur";
  home.homeDirectory = "/home/hastur";
  home.stateVersion = "25.11";
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake ~/nix-dotfiles#nixos";
	home-check = "echo home-manager is working";
      };
      initExtra = ''
        export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
      '';
    };
    zsh = {
      enable = true;
      shellAliases = {
        home-check = "echo home-manager is working";
      };
    };
    fish = {
      enable = true;
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "Alex";
          email = "125680751+CatInAWizardHat@users.noreply.github.com";
        };
	init = {
	  defaultBranch = "main";
	};
	signing = {
	  key = "/home/hastur/.ssh/id_ed25519.pub";
	  signByDefault = true;
	};
	gpg = {
	  format = "ssh";
	};
      };
    };
  };

  xdg.configFile =
    builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    neovim
    ripgrep
    fzf
    gcc
    rofi
    nixpkgs-fmt
    alejandra
    playerctl
    brightnessctl
    vis
    lua-language-server
    nil
    rofi
    fastfetch
    vis
  ];
}
