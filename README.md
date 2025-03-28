# My NixOS and Home Manager configurations.

Todo: add explanations of everything.

# Useful notes for myself:

sudo nix-collect-garbage --delete-older-than 14d

Note on buildInputs vs nativeBuildInputs (which I always mix up):
- Think of cross compilation!
  * *native*buildInputs are native binaries for the build computer, i.e. build deps.
  * buildInputs *may not* be native to the build computer, i.e. runtime deps.
In the case of native compilation (not cross), these both use the build computer's os/arch.
- Note that pkgs.callPackage secretly uses pkgs.buildPackages.X for things inside of
nativeBuildInputs, which is why cross compilation is mostly invisible to the package.nix
author :O (and why you should always callPackage so things get resolved properly)
- see https://jade.fyi/blog/flakes-arent-real/ cross compilation section

Notes on `ln -s input $out` vs `cp input $out`:
- if input resolves to a full store path, ln -s simply saves space and should be used.
- if you ln -s a single file from a 10gb store path into $out, now $out depends
on the entire 10gb store path which cannot be gc'ed.
- if cp is used, the data is duplicated; this may be what you want (eg copying only
  some files from drv A to drv B saves space if A doesn't depend on B from anything else)
- see https://discourse.nixos.org/t/symlinking-vs-copying-into-out/11132

Note on manually stepping through the build process of a derivation:
- use `nix develop nixpkgs#program` in a new empty directory, but STAY IN BASH. For some
  reason when entering ZSH you lose certain things like genericBuild and runPhase.
- you can manually `runPhase unpackPhase` for every single phase (listed here: 
  https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases ), OR you can just run `genericBuild`

To see the difference / what changes between generations:

`nix profile diff-closures --profile /nix/var/nix/profiles/system`
