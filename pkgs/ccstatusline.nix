{
  lib,
  stdenv,
  fetchFromGitHub,
  bun2nix,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "ccstatusline";
  version = "2.0.25";

  src = fetchFromGitHub {
    owner = "sirmalloc";
    repo = "ccstatusline";
    rev = "v2.0.25";
    hash = "sha256-WC3eEIk6db41KDXOlpIHmOZW4g3qqDCYruzUE5KC3ok=";
  };

  nativeBuildInputs = [
    bun2nix.hook
    makeWrapper
  ];

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./ccstatusline-bun.nix;
  };

  bunInstallFlags =
    if stdenv.hostPlatform.isDarwin then [
      "--linker=hoisted"
      "--backend=copyfile"
    ] else [
      "--linker=hoisted"
    ];

  dontUseBunBuild = true;
  dontUseBunCheck = true;
  dontUseBunInstall = true;

  buildPhase = ''
    runHook preBuild
    bun build src/ccstatusline.ts --target=node --outfile=dist/ccstatusline.js
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/ccstatusline $out/bin
    cp dist/ccstatusline.js $out/lib/ccstatusline/
    makeWrapper ${nodejs}/bin/node $out/bin/ccstatusline \
      --add-flags "$out/lib/ccstatusline/ccstatusline.js"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Customizable status line formatter for Claude Code CLI";
    homepage = "https://github.com/sirmalloc/ccstatusline";
    license = licenses.mit;
    mainProgram = "ccstatusline";
    platforms = platforms.all;
  };
}
