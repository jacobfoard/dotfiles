{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_26,
}:

buildGoModule.override { go = go_1_26; } rec {
  pname = "entire-cli";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "entireio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Vg0ktRsLooLBqixTyWtAwOnt7lO6RMNcnrOAwtE6U78=";
  };

  vendorHash = "sha256-bzSJfN77v2huchYZwD8ftBRffVLP4OiZqO++KXj3onI=";

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
