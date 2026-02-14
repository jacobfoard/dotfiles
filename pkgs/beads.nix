{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkgs,
  go_1_26,
}:

buildGoModule.override { go = go_1_26; } rec {
  pname = "beads";
  version = "0.49.6";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zopOpBqaHC2t+tGYtrHyalOUsFDZai2NmZZOKJs2vfQ=";
  };

  subPackages = [ "cmd/bd" ];
  vendorHash = "sha256-RyOxrW0C+2E+ULhGeF2RbUhaUFt58sux7neHPei5QJI=";

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
