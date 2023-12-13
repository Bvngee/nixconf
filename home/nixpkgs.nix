{ ... }: {
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

}
