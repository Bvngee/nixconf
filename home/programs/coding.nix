{ pkgs, pkgsUnstable, ... }: {
  home.packages = with pkgs; [
    # IDEs and Editors
    jetbrains.idea-community
    vscodium-fhs

    # C/C++
    gcc13 # stdenv.cc?
    gnumake
    pkgsUnstable.clang-tools_17
    gdb
    meson
    ninja
    cmake
    pkg-config

    # Rust
    rustup

    # Python
    python3 # doesn't handle python packages
    nodePackages.pyright
    pkgsUnstable.ruff

    # Java
    temurin-bin-18
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
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.eslint
    pkgsUnstable.prettierd
    sassc

    # Zig
    zig
    zls
  ];
}
