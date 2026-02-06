{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kubectl-cnpg";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${version}";
    hash = "sha256-9NfjrVF0OtDLaGD5PPFSZcI8V3Vy/yOTm/JwnE3kMZE=";
  };

  vendorHash = "sha256-QNtKtHTxOgm6EbOSvA2iUE0hjltwTBNkA1mIC3N+AbM=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubectl-cnpg \
      --bash <($out/bin/kubectl-cnpg completion bash) \
      --fish <($out/bin/kubectl-cnpg completion fish) \
      --zsh <($out/bin/kubectl-cnpg completion zsh)
  '';

  meta = with lib; {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = licenses.asl20;
  };
}
