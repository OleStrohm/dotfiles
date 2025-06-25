# This is based on the nixCats kickstart example.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };
  };

  outputs = { nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

    dependencyOverlays = /* (import ./overlays inputs) ++ */ [
      (utils.standardPluginOverlay inputs)
      (self: super:
        let
          cargo-test-nvim = super.vimUtils.buildVimPlugin {
            pname = "cargo_test.nvim";
            version = "2025-06-25";
            src = super.fetchFromGitHub {
              owner = "olestrohm";
              repo = "cargo_test.nvim";
              rev = "c2eb1965011726c1df1dd635e5155fe7bf914d3e";
              sha256 = "sha256-6pXliY4csL3vsfvLS+CCR/0HwxAcGZnD3RVLPDZKGEM=";
            };
            disabled = super.lua.luaversion != "5.1";
            propagatedBuildInputs = [ super.vimPlugins.telescope-nvim ];
            meta.homepage = "https://github.com/OleStrohm/cargo_test.nvim";
            meta.hydraPlatforms = [ ];
          };
        in
        {
          vimPlugins = super.vimPlugins // {
            inherit cargo-test-nvim;
          };
        }
      )
    ];

    categoryDefinitions = { pkgs, ... }: {
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          ripgrep
          fd
          nix-doc
          lua-language-server
          nixd
          stylua
          markdownlint-cli
        ];
      };

      startupPlugins = with pkgs.vimPlugins; {
        general = [
          lazy-nvim # Package manager
          plenary-nvim # Common library
          # General
          tokyonight-nvim
          todo-comments-nvim
          mini-nvim
          vim-sleuth
          comment-nvim
          which-key-nvim
          nvim-web-devicons
          leap-nvim
          # Status line
          lualine-nvim
          # Telescope
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim
          # LSP
          nvim-lspconfig
          lazydev-nvim
          conform-nvim
          FTerm-nvim
          fidget-nvim
          blink-cmp
          luasnip
          (nvim-treesitter.withPlugins (plugins: with plugins; [ rust nix lua cpp ]))
          nvim-lint
          cargo-test-nvim
          # Debugging
          nvim-dap-lldb
          nvim-dap
          nvim-dap-ui
          nvim-nio
          pkgs.vscode-extensions.vadimcn.vscode-lldb
        ];
      };
    };

    packageDefinitions = {
      nvim = { ... }: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          aliases = [ "vim" ];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          hosts.python3.enable = false;
          hosts.node.enable = false;
        };
        categories = {
          general = true;
          have_nerd_font = true;
        };
      };
    };

    defaultPackageName = "nvim";
  in


  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages = utils.mkAllWithDefault defaultPackage;

    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
  in {

    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });
}
