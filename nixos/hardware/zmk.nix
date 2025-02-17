{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    dtc
    # zmkBATx ?
  ];
}
