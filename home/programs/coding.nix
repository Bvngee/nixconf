{ pkgs, pkgsUnstable, user, ... }: {
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
    valgrind
    kdePackages.kcachegrind

    # Rust
    rustup

    # Python
    python3 # doesn't handle python packages
    nodePackages.pyright
    pkgsUnstable.ruff

    # MicroPython
    adafruit-ampy
    mpremote

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
    nodePackages.prettier
    pkgsUnstable.prettierd
    sassc

    # Zig
    zig
    zls

    # Go
    go
    gopls
  ];

  home.sessionVariables = {
    GOPATH = "/home/${user}/.local/share/go";
    GOMODCACHE = "/home/${user}/.cache/go/pkg/mod";
  };

}
