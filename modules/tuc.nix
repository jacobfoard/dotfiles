{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "tuc";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "riquito";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JtQBEq75FCW5jttoeFaD4dBvQcWJH2ElNh1d53JAAJs=";
  };

  cargoSha256 = "sha256-eY5B+b2lJNZT2hAn5IBZ5f7pdW8+QpV6WHi4DsZQ/cI=";


  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.gpl3Only;
  };
}
