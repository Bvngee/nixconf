{ inputs, lib, pkgs, theme, ... }: {
  home.packages = [
    # temporary
    inputs.matugen.packages.${pkgs.system}.default
  ];

  # Matugen's module works as a NixOS module and a HM module.
  imports = [ inputs.matugen.nixosModules.default ];

  programs.matugen = lib.mkIf (theme.wallpaper != null) {
    enable = true;
    wallpaper = theme.wallpaper;
    templates = { }; # None so far - I'd rather configure using Nix
    palette = "default"; # triadic, adjacent
    jsonFormat = "hex"; #RRGGBB
    variant = "light";
  };

}




# (OLD)
# An experiment comparing Matugen to material_color_utilities_python:

# # BUDAPEST
# 
# # matugen
# "error": "#ffb4ab",
# "error_container": "#93000a",
# "inverse_on_surface": "#2f3035",
# "inverse_primary": "#005ac1",
# "inverse_surface": "#e3e2e8",
# "on_error": "#690005",
# "on_error_container": "#ffb4ab",
# "on_primary": "#002e69",
# "on_primary_container": "#d8e2ff",
# "on_primary_fixed": "#001a41",
# "on_primary_fixed_variant": "#004494",
# "on_secondary": "#253048",
# "on_secondary_container": "#d8e2ff",
# "on_secondary_fixed": "#0f1b32",
# "on_secondary_fixed_variant": "#3b475f",
# "on_surface": "#e3e2e8",
# "on_surface_variant": "#c4c6d0",
# "on_tertiary": "#44244a",
# "on_tertiary_container": "#fed6ff",
# "on_tertiary_fixed": "#2d0e34",
# "on_tertiary_fixed_variant": "#5d3a62",
# "outline": "#8e9099",
# "outline_variant": "#44474f",
# "primary": "#adc6ff",
# "primary_container": "#004494",
# "primary_fixed": "#d8e2ff",
# "primary_fixed_dim": "#adc6ff",
# "scrim": "#000000",
# "secondary": "#bbc6e4",
# "secondary_container": "#3b475f",
# "secondary_fixed": "#d8e2ff",
# "secondary_fixed_dim": "#bbc6e4",
# "shadow": "#000000",
# "source_color": "#4285f4",
# "surface": "#121317",
# "surface_bright": "#38393e",
# "surface_container": "#1e1f24",
# "surface_container_high": "#292a2e",
# "surface_container_highest": "#333539",
# "surface_container_low": "#1a1b20",
# "surface_container_lowest": "#0d0e12",
# "surface_dim": "#121317",
# "tertiary": "#e5b8e8",
# "tertiary_container": "#5d3a62",
# "tertiary_fixed": "#fed6ff",
# "tertiary_fixed_dim": "#e5b8e8"
# 
# # material_color_utilities_python 
# 'background': '#201a1a',
# 'error': '#ffb4a9',
# 'errorContainer': '#930006',
# 'inverseOnSurface': '#362f2f',
# 'inversePrimary': '#9c4043',
# 'inverseSurface': '#ede0df',
# 'onBackground': '#ede0df',
# 'onError': '#680003',
# 'onErrorContainer': '#ffb4a9',
# 'onPrimary': '#5f1319',
# 'onPrimaryContainer': '#ffdad9',
# 'onSecondary': '#442929',
# 'onSecondaryContainer': '#ffdad9',
# 'onSurface': '#ede0df',
# 'onSurfaceVariant': '#d7c1c0',
# 'onTertiary': '#412d05',most
# 'onTertiaryContainer': '#ffdeaa',
# 'outline': '#a08c8b',
# 'primary': '#ffb3b2',
# 'primaryContainer': '#7e2a2e',
# 'secondary': '#e6bcbb',
# 'secondaryContainer': '#5d3f3f',
# 'shadow': '#000000',
# 'surface': '#201a1a',
# 'surfaceVariant': '#524343',
# 'tertiary': '#e4c18d',
# 'tertiaryContainer': '#5b431a'
# 
# # material theme builder
# "primary": "#FFB3AE",
# "surfaceTint": "#FFB3AE",
# "onPrimary": "#571E1C",
# "primaryContainer": "#733330",
# "onPrimaryContainer": "#FFDAD7",
# "secondary": "#E7BDB9",
# "onSecondary": "#442927",
# "secondaryContainer": "#5D3F3D",
# "onSecondaryContainer": "#FFDAD7",
# "tertiary": "#E2C28C",
# "onTertiary": "#402D04",
# "tertiaryContainer": "#594319",
# "onTertiaryContainer": "#FFDEA6",
# "error": "#FFB4AB",
# "onError": "#690005",
# "errorContainer": "#93000A",
# "onErrorContainer": "#FFDAD6",
# "background": "#1A1111",
# "onBackground": "#F1DEDD",
# "surface": "#1A1111",
# "onSurface": "#F1DEDD",
# "surfaceVariant": "#534342",
# "onSurfaceVariant": "#D8C2BF",
# "outline": "#A08C8A",
# "outlineVariant": "#534342",
# "shadow": "#000000",
# "scrim": "#000000",
# "inverseSurface": "#F1DEDD",
# "inverseOnSurface": "#382E2D",
# "inversePrimary": "#904A46",
# "primaryFixed": "#FFDAD7",
# "onPrimaryFixed": "#3B0909",
# "primaryFixedDim": "#FFB3AE",
# "onPrimaryFixedVariant": "#733330",
# "secondaryFixed": "#FFDAD7",
# "onSecondaryFixed": "#2C1513",
# "secondaryFixedDim": "#E7BDB9",
# "onSecondaryFixedVariant": "#5D3F3D",
# "tertiaryFixed": "#FFDEA6",
# "onTertiaryFixed": "#271900",
# "tertiaryFixedDim": "#E2C28C",
# "onTertiaryFixedVariant": "#594319",
# "surfaceDim": "#1A1111",
# "surfaceBright": "#423736",
# "surfaceContainerLowest": "#140C0B",
# "surfaceContainerLow": "#231919",
# "surfaceContainer": "#271D1D",
# "surfaceContainerHigh": "#322827",
# "surfaceContainerHighest": "#3D3231"
# 
# 
# 
# # ICE
# 
# "error": "#ffb4ab",
# "error_container": "#93000a",
# "inverse_on_surface": "#303031",
# "inverse_primary": "#3a6476",
# "inverse_surface": "#e3e2e3",
# "on_error": "#690005",
# "on_error_container": "#ffb4ab",
# "on_primary": "#013546",
# "on_primary_container": "#bee9fe",
# "on_primary_fixed": "#001f2a",
# "on_primary_fixed_variant": "#204c5d",
# "on_secondary": "#293236",
# "on_secondary_container": "#dbe4e9",
# "on_secondary_fixed": "#141d21",
# "on_secondary_fixed_variant": "#3f484d",
# "on_surface": "#e3e2e3",
# "on_surface_variant": "#c5c7c9",
# "on_tertiary": "#302f3e",
# "on_tertiary_container": "#e4e0f4",
# "on_tertiary_fixed": "#1b1a28",
# "on_tertiary_fixed_variant": "#464555",
# "outline": "#8e9193",
# "outline_variant": "#444749",
# "primary": "#a3cde1",
# "primary_container": "#204c5d",
# "primary_fixed": "#bee9fe",
# "primary_fixed_dim": "#a3cde1",
# "scrim": "#000000",
# "secondary": "#bfc8cd",
# "secondary_container": "#3f484d",
# "secondary_fixed": "#dbe4e9",
# "secondary_fixed_dim": "#bfc8cd",
# "shadow": "#000000",
# "source_color": "#5f889b",
# "surface": "#121314",
# "surface_bright": "#38393a",
# "surface_container": "#1f2020",
# "surface_container_high": "#292a2b",
# "surface_container_highest": "#343536",
# "surface_container_low": "#1b1c1c",
# "surface_container_lowest": "#0d0e0f",
# "surface_dim": "#121314",
# "tertiary": "#c7c4d7",
# "tertiary_container": "#464555",
# "tertiary_fixed": "#e4e0f4",
# "tertiary_fixed_dim": "#c7c4d7"
# 
# 'background': '#191c1d',
# 'error': '#ffb4a9',
# 'errorContainer': '#930006',
# 'inverseOnSurface': '#2e3132',
# 'inversePrimary': '#00677e',
# 'inverseSurface': '#e1e3e4',
# 'onBackground': '#e1e3e4',
# 'onError': '#680003',
# 'onErrorContainer': '#ffb4a9',
# 'onPrimary': '#003542',
# 'onPrimaryContainer': '#b1ebff',
# 'onSecondary': '#1d343b',
# 'onSecondaryContainer': '#cfe7f0',
# 'onSurface': '#e1e3e4',
# 'onSurfaceVariant': '#bfc8cc',
# 'onTertiary': '#2b2e4d',
# 'onTertiaryContainer': '#dee0ff',
# 'outline': '#899296',
# 'primary': '#59d5f8',
# 'primaryContainer': '#004e60',
# 'secondary': '#b2cad3',
# 'secondaryContainer': '#344a52',
# 'shadow': '#000000',
# 'surface': '#191c1d',
# 'surfaceVariant': '#40484b',
# 'tertiary': '#c1c3eb',
# 'tertiaryContainer': '#414464'
# 
# 
# # WAIT
# 
# "error": "#ffb4ab",
# "error_container": "#93000a",
# "inverse_on_surface": "#2f3035",
# "inverse_primary": "#005ac1",
# "inverse_surface": "#e3e2e8",
# "on_error": "#690005",
# "on_error_container": "#ffb4ab",
# "on_primary": "#002e69",
# "on_primary_container": "#d8e2ff",
# "on_primary_fixed": "#001a41",
# "on_primary_fixed_variant": "#004494",
# "on_secondary": "#253048",
# "on_secondary_container": "#d8e2ff",
# "on_secondary_fixed": "#0f1b32",
# "on_secondary_fixed_variant": "#3b475f",
# "on_surface": "#e3e2e8",
# "on_surface_variant": "#c4c6d0",
# "on_tertiary": "#44244a",
# "on_tertiary_container": "#fed6ff",
# "on_tertiary_fixed": "#2d0e34",
# "on_tertiary_fixed_variant": "#5d3a62",
# "outline": "#8e9099",
# "outline_variant": "#44474f",
# "primary": "#adc6ff",
# "primary_container": "#004494",
# "primary_fixed": "#d8e2ff",
# "primary_fixed_dim": "#adc6ff",
# "scrim": "#000000",
# "secondary": "#bbc6e4",
# "secondary_container": "#3b475f",
# "secondary_fixed": "#d8e2ff",
# "secondary_fixed_dim": "#bbc6e4",
# "shadow": "#000000",
# "source_color": "#4285f4",
# "surface": "#121317",
# "surface_bright": "#38393e",
# "surface_container": "#1e1f24",
# "surface_container_high": "#292a2e",
# "surface_container_highest": "#333539",
# "surface_container_low": "#1a1b20",
# "surface_container_lowest": "#0d0e12",
# "surface_dim": "#121317",
# "tertiary": "#e5b8e8",
# "tertiary_container": "#5d3a62",
# "tertiary_fixed": "#fed6ff",
# "tertiary_fixed_dim": "#e5b8e8"
# 
# 'background': '#191c1e',
# 'error': '#ffb4a9',
# 'errorContainer': '#930006',
# 'inverseOnSurface': '#2e3133',
# 'inversePrimary': '#00658e',
# 'inverseSurface': '#e1e2e5',
# 'onBackground': '#e1e2e5',
# 'onError': '#680003',
# 'onErrorContainer': '#ffb4a9',
# 'onPrimary': '#00344c',
# 'onPrimaryContainer': '#c4e7ff',
# 'onSecondary': '#21333e',
# 'onSecondaryContainer': '#d2e5f4',
# 'onSurface': '#e1e2e5',
# 'onSurfaceVariant': '#c1c7ce',
# 'onTertiary': '#332b4b',
# 'onTertiaryContainer': '#e9ddff',
# 'outline': '#8b9298',
# 'primary': '#80cfff',
# 'primaryContainer': '#004c6c',
# 'secondary': '#b6c9d8',
# 'secondaryContainer': '#374955',
# 'shadow': '#000000',
# 'surface': '#191c1e',
# 'surfaceVariant': '#41484d',
# 'tertiary': '#ccc1e9',
# 'tertiaryContainer': '#4a4263'
# 
# 
