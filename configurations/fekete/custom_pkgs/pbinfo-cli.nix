{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "pbinfo-cli";
  version = "1.0.0";

  src = pkgs.fetchgit {
    url = "https://github.com/insertokername/pbinfo-cli";
    rev = "810be7cb7e59866d13a420bf54d262b59c6744ec";
    sha256 = "sha256-xK28xjLVbTh2ZRMAtUqR2hMAFlHgU/upRwQSRUQzpxc=";
  };

  buildInputs = [
    pkgs.rustPlatform.cargoSetupHook
    pkgs.cargo
    pkgs.openssl
    pkgs.pkg-config
  ];

  cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-VngQt1thF/PSaep5TyOvdKf37iY45VXrQsS8Xzf+MWA=";
  };

  configurePhase = ''
    cargo build --release
  '';

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/bin
    mv target/release/pbinfo-cli $out/bin
  '';
}
