{ config, pkgs, lib, ... }:
{ 
  home.packages = with pkgs; [
    sqlite
  ];

  programs = {
    zoxide = {
      enable = true;
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh"; 
      defaultKeymap = "viins";

      initExtra =
        ''
          # zsh-histdb
          autoload -Uz add-zsh-hook
        '';
      
      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        update = "sudo nixos-rebuild switch --flake .#";
      };
      
      plugins = [
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./.;
          file = "p10k-config.zsh";
        }
        {
          name = "zsh-histdb";
          src = pkgs.fetchFromGitHub {
            owner = "larkery";
            repo = "zsh-histdb";
            rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
            sha256 = lib.fakeSha256;
          };
        }
      ];
      
      zplug = {
        enable = true;
        plugins = [
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
    };
  };
}
