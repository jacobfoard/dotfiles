{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkgs,
  go_1_26,
}:

buildGoModule.override { go = go_1_26; } rec {
  pname = "beads";
  version = "0.50.3";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vWPQuhKUHsikSvmHGqp96LpcBiFYH2nev2LzEHyLrV8=";
  };

  subPackages = [ "cmd/bd" ];
  vendorHash = "sha256-s9ELOxDHHk+RyImrPxm9DPos7Wb4AFWaNKsrgU4soow=";

  env = {
    CGO_ENABLED = 1;
  };

  ldflags = [
    "-X main.Version=${version}"
  ];

  doCheck = false;

  buildInputs = [
    pkgs.icu
  ];

  nativeBuildInputs = [
    installShellFiles
    pkgs.git
    pkgs.pkg-config
  ];
  postInstall = ''
    installShellCompletion --cmd bd \
      --bash <($out/bin/bd completion bash) \
      --fish <($out/bin/bd completion fish) \
      --zsh <($out/bin/bd completion zsh)
  '';

  meta = {
    description = "A memory upgrade for your coding agent";
    mainProgram = "bd";
    homepage = "https://github.com/steveyegge/beads";
  };
}
