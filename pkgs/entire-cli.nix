{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_26,
}:

buildGoModule.override { go = go_1_26; } rec {
  pname = "entire-cli";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "entireio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-6/TsSmJ0z72Ta5ZihO06uV4Mik+fFpm8eCa7d5zlq24=";
  };

  vendorHash = "sha256-rh2VhdwNT5XJYCVjj8tnoY7cacEhc/kcxi0NHYFPYO8=";

  subPackages = [ "cmd/entire" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/entireio/cli/cmd/entire/cli/buildinfo.Version=${version}"
  ];

  meta = {
    description = "Entire CLI - hooks into your git workflow to capture AI agent sessions";
    homepage = "https://github.com/entireio/cli";
    license = lib.licenses.mit;
    mainProgram = "entire";
  };
}
