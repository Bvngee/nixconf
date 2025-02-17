{ config, pkgs, pkgsUnstable, ... }: {
  home.packages =
    let
      # Some dynamic executables are unpatched but are loaded by patched nixpkgs
      # executables, and therefore never pick up NIX_LD_LIBRARY_PATH. For
      # example, interpreters that use dynamically linked libraries, like python3
      # libraries run by nixpkgs' python. This wraps the interpreter for ease of
      # use with those executables. WARNING: Using LD_LIBRARY_PATH like this can
      # override some of the program's dylib links in the nix store; this should
      # be generally ok though
      makeNixLDWrapper = program: (pkgs.runCommand "${program.pname}-nix-ld-wrapped" { } ''
        mkdir -p $out/bin
        for file in ${program}/bin/*; do
          new_file=$out/bin/$(basename $file)
          echo "#! ${pkgs.bash}/bin/bash -e" >> $new_file
          echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH"' >> $new_file
          echo 'exec -a "$0" '$file' "$@"' >> $new_file
          chmod +x $new_file
        done
      '');

      # I wrote a blog post about this! https://bvngee.com/blogs/clangd-embedded-development
      # I don't need all clang-tools to be unwrapped, only really clangd
      # TODO(future me): remove when PRs/Issues are resolved
      clangdUnwrapped = pkgs.runCommand "clangdUnwrapped" {} ''
        mkdir -p $out/bin
        ln -s ${pkgs.clang.cc}/bin/clangd $out/bin/clangd-unwrapped
      '';
    in
    with pkgs; [
      # IDEs and Editors
      jetbrains.idea-community
      vscodium-fhs
      pkgsUnstable.zed-editor # TODO: nixos-24.11

      # C/C++
      gcc13 # stdenv.cc?
      gnumake
      clang-tools_17
      clangdUnwrapped 
      gdb
      meson
      ninja
      cmake
      pkg-config
      valgrind
      kdePackages.kcachegrind
      pkgsUnstable.mesonlsp # 24.11

      # Rust
      rustup

      # Python
      (makeNixLDWrapper python3)
      nodePackages.pyright
      ruff

      # MicroPython
      adafruit-ampy
      mpremote

      # Java
      temurin-bin-18
      pkgsUnstable.temurin-bin-23 # TODO: nixos-24.11
      jdt-language-server

      # Lua
      lua-language-server
      stylua

      # Shell
      nodePackages.bash-language-server
      shellcheck

      # Nix
      nixpkgs-fmt
      nil

      # JS/TS
      nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server # wraps tsserver
      tailwindcss-language-server
      vscode-langservers-extracted # includes html/css/json/eslint
      pkgsUnstable.astro-language-server # 24.11
      pkgsUnstable.svelte-language-server # 24.11
      lemminx # xml lsp
      nodePackages.eslint
      nodePackages.prettier
      prettierd
      sassc
      nodePackages.ts-node

      # Zig
      zig
      zls

      # Go
      go
      gopls
    ];

  home.sessionVariables = {
    GOPATH = "/home/${config.profile.mainUser}/.local/share/go";
    GOMODCACHE = "/home/${config.profile.mainUser}/.cache/go/pkg/mod";
  };

}
