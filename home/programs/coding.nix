{ inputs, pkgs, ... }: {
  home.packages =
    let
      # Some dynamic executables are unpatched but are loaded by patched nixpkgs
      # executables, and therefore never pick up NIX_LD_LIBRARY_PATH. For
      # example, interpreters that use dynamically linked libraries, like python3
      # libraries run by nixpkgs' python. This wraps the interpreter for ease of
      # use with those executables. WARNING: Using LD_LIBRARY_PATH like this can
      # override some of the program's dylib links in the nix store; this should
      # be generally ok though
      # TODO: make this copy/symlink ALL files of original derivation, not just bin
      # TODO: This doesn't work in homemanager-only systems, as nix-ld doesn't
      #       exist! should use lib.makeLibraryPath for both somehow
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
      clangdUnwrapped = pkgs.runCommand "clangdUnwrapped" { } ''
        mkdir -p $out/bin
        ln -s ${inputs.nixpkgs-neovim.legacyPackages.${pkgs.system}.clang.cc}/bin/clangd $out/bin/clangd-unwrapped
      '';
    in
    with pkgs; [
      # IDEs and Editors
      jetbrains.idea-community
      vscode-fhs

      # Misc
      sqlite-interactive

      # C/C++
      stdenv.cc # same C/C++ toolchain used to build nixpkgs packages
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
      mesonlsp

      # Rust
      rustup

      # Python
      (makeNixLDWrapper python3)
      pyright
      ruff
      uv

      # MicroPython
      adafruit-ampy
      mpremote

      # Java (see jdks below)
      jdt-language-server

      # Lua
      lua-language-server
      stylua

      # Shell
      nodePackages.bash-language-server
      shellcheck
      powershell-editor-services # windows stuff # 25.05
      powershell

      # Nix
      nixpkgs-fmt
      nil

      # JS/TS
      nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server # wraps tsserver
      tailwindcss-language-server
      vscode-langservers-extracted # includes html/css/json/eslint
      astro-language-server
      svelte-language-server
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

      # Typst (LaTeX alternative - not necessarily coding, but adjacent)
      typst
      tinymist
      typstyle

      # Dart / Flutter
      flutter
    ];

  programs.zed-editor = {
    enable = true;
    userSettings = {
      features.copilot = false;
      telemetry.metrics = false;
      vim_mode = true;
    };
  };

  # Setup JDKs
  # TODO: Should I use makeNixLDWrapper on java (so that downloaded JARs work)??
  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-23; # JAVA_HOME / default java
  };
  home.sessionPath = [ "$HOME/.local/jdks" ];
  home.file = # add additional JDKs to ~/.local/jdks
    let
      additionalJDKs = with pkgs; [
        jdk8 # jdk17 jdk23
        jdk11
        temurin-bin # 21
        temurin-bin-23
      ];
    in
    (builtins.listToAttrs (builtins.map
      (jdk: {
        name = ".local/jdks/${jdk.name}";
        value = { source = jdk.home; };
      })
      additionalJDKs));


  home.sessionVariables = {
    GOPATH = "$HOME/.local/share/go";
    GOMODCACHE = "$HOME/.cache/go/pkg/mod";

    PWSH_EDITOR_SERVICES_BUNDLE_PATH = "${pkgs.powershell-editor-services}/lib/powershell-editor-services";

    # Force UV to use our nix-ld-wrapped python always, instead of downloading
    # its own python binaries which won't work with precompiled libraries.`
    UV_PYTHON_DOWNLOADS="never";
  };

}
