{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "av";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "aviator-co";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GkYsQouncVrYp0Gg0vinKrPSlT9UKJi2RZ4zp1M9BbE=";
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
