{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  autoPatchelfHook,
  dpkg,
  xorg,
  zlib,
  freetype,
  harfbuzz,
  lcms2,
  giflib,
  libjpeg8,
  libpng,
  pcsclite,
  alsa-lib,
  version ? "888.112",
  hash ? "sha256-VnjE8Jh+hoigDAg6M0eRE96taRFH+isfcT6tp+UmkWU=",
}:

let
  channel = "release";
  platform = "linux-amd64";

  src = fetchurl {
    url = "https://github.com/jetbrains-junie/junie/releases/download/${version}/junie-${channel}-${version}-${platform}.zip";
    inherit hash;
  };
in
stdenv.mkDerivation {
  pname = "junie";
  inherit version src;

  sourceRoot = ".";
  unpackPhase = ''
    mkdir -p source
    unzip $src -d source
  '';

  nativeBuildInputs = [
    unzip
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    freetype
    harfbuzz
    lcms2
    giflib
    libjpeg8
    libpng
    pcsclite
    alsa-lib
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/junie
    cp -R source/junie-app $out/libexec/junie/junie-app
    cp -R source/junie $out/libexec/junie/junie

    chmod +x $out/libexec/junie/junie
    chmod +x $out/libexec/junie/junie-app/bin/junie

    mkdir -p $out/bin
    makeWrapper $out/libexec/junie/junie $out/bin/junie \
      --run "cd $out/libexec/junie" \
      --prefix PATH : ${lib.makeBinPath [ dpkg ]} \
      --run 'export JUNIE_DATA="''${JUNIE_DATA:-$HOME/.local/share/junie}"'

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = false;

  meta = with lib; {
    description = "Junie CLI – AI coding agent by JetBrains";
    homepage = "https://junie.jetbrains.com";
    license = licenses.unfree;
    mainProgram = "junie";
    platforms = [ "x86_64-linux" ];
  };
}
