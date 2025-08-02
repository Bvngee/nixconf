{
  # Common system-wide nixpkgs configurations
  config = {
    nixpkgs = {
      overlays = [ ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };
}
