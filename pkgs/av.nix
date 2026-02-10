{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "av";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "aviator-co";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6sPy59M9Up5+MePfs6dXp+zZX2L3BzYvawZcaQHQWaI=";
  };

  subPackages = [ "cmd/av" ];
  vendorHash = "sha256-uwBBJqbT61IqqmsN1GuB2ARBZjP/dqM/dDCrBdxajwA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aviator-co/av/internal/config.Version=v${version}"
  ];

  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd av \
      --bash <($out/bin/av completion bash) \
      --fish <($out/bin/av completion fish) \
      --zsh <($out/bin/av completion zsh)
  '';

  meta = {
    description = "A command line tool to manage stacked PRs with Aviator";
    mainProgram = "av";
    homepage = "https://github.com/aviator-co/av";
  };
}
