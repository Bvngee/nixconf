{ pkgs, ... }: {
    home.packages = with pkgs; [
        # Misc/Related
        jetbrains.idea-community
        vscodium-fhs

        # C/C++
        clang-tools 
        gcc

        # Rust
        rustup

        # Python
        python3 # doesn't handle packages

        # Java
        temurin-jre-bin-18

        # Lua
        nil
        lua-language-server
        stylua
    ];
}
