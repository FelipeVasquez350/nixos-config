{ stdenv, coreutils, fetchurl, ... }:

stdenv.mkDerivation rec {
  pname = "better-docker-ps";
  version = "1.15";
  src = fetchurl {
    url =
      "https://github.com/Mikescher/better-docker-ps/releases/download/v${version}/dops_linux-amd64-static";
    sha256 = "sha256-E8AIALt0/UxcMc2oYjSZ+aQvoxm5jrJheBmxWje8CeE=";
  };

  dontUnpack = true;
  doCheck = false;
  dontConfigure = true;
  dontMake = true;

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/bin/
    ${coreutils}/bin/cp $src $out/bin/dops
    chmod +x $out/bin/dops
  '';
}
