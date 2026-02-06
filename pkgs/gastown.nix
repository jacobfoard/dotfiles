{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  beads,
}:

buildGoModule rec {
  pname = "gastown";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mtouqawxbaLruvBNuXSyYCwREEg1mi0SFQRLfOdJQxI=";
  };

  subPackages = [ "cmd/gt" ];
  vendorHash = "sha256-ripY9vrYgVW8bngAyMLh0LkU/Xx1UUaLgmAA7/EmWQU=";

  ldflags = [
    "-X github.com/steveyegge/gastown/internal/cmd.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    beads
  ];
  postInstall = ''
    installShellCompletion --cmd gt \
      --bash <($out/bin/gt completion bash) \
      --fish <($out/bin/gt completion fish) \
      --zsh <($out/bin/gt completion zsh)
  '';

  meta = {
    description = "multi-agent workspace manager";
    mainProgram = "gt";
    homepage = "https://github.com/steveyegge/gastown";
  };
}
