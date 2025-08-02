{ lib, rustPlatform, pkg-config, libusb1, fetchFromGitHub, ... }:
rustPlatform.buildRustPackage {
  pname = "mow";
  version = "4452efd";

  src = fetchFromGitHub {
    owner = "korkje";
    repo = "mow";
    rev = "4452efd6b8e3c072e1996ff0fdaa3dab7967d3dd";
    hash = "sha256-OZm7zK7uKN6nJeq/R/jl+tpGc0a33fFEhfyQGZOmSM0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  cargoHash = "sha256-oAm81BMsPCSy5LT+1jjcNedqu2m1V7HAyZ1SCpNtutw=";

  meta = {
    description = "Cross platform CLI tool for Model O Wireless";
    homepage = "https://github.com/korkje/mow";
    license = lib.licenses.mit;
  };
}
