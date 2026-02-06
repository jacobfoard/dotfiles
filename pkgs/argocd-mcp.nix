{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "argocd-mcp";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "argoproj-labs";
    repo = "mcp-for-argocd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mNcxf1Nc5o5F4H6pWQ4j3JTcHbhCk+ZhVYoywVU4zlU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-deoqHsCEvnVMVPhJDdvHm9k2B4IseXvziVtL1XztP7s=";
    fetcherVersion = 2;
  };

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/argocd-mcp $out/bin
    cp -r dist node_modules package.json $out/lib/node_modules/argocd-mcp/
    ln -s $out/lib/node_modules/argocd-mcp/dist/index.js $out/bin/argocd-mcp
    runHook postInstall
  '';

  meta = with lib; {
    description = "Argo CD MCP Server - Model Context Protocol server for Argo CD";
    homepage = "https://github.com/argoproj-labs/mcp-for-argocd";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "argocd-mcp";
    platforms = platforms.all;
  };
})
