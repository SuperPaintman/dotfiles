{ stdenv
, fetchurl
, fetchFromGitHub
}:

let
  schemastore = fetchFromGitHub {
    owner = "schemastore";
    repo = "schemastore";
    rev = "3c02713273319ad981595dd7b3bd9362503d4599";
    hash = "sha256-Mr3VWhkh2eHS0gxGrcC1EQEKJxiPHXygyWNpvzvoiQA=";
  };

  compose-spec = fetchFromGitHub {
    owner = "compose-spec";
    repo = "compose-spec";
    rev = "d91f6c75f7f68f148b361472b36abda21dc79e44";
    hash = "sha256-nq7o7HZl8EhphqSpxVPQKVFV+EmDfF1ObLCXJEuSGRA=";
  };

  openapi-specification = fetchFromGitHub {
    owner = "OAI";
    repo = "OpenAPI-Specification";
    rev = "78170608af208da8165ab095715e5cb9ff715f47";
    hash = "sha256-gij5AHzQ1sSJNSE83VfjccTbLEDjRtcM/aN8AslJ4+c=";
  };
in

stdenv.mkDerivation rec {
  name = "jsonschemas";

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out"
    mkdir -p "$out/json.schemastore.org"
    mkdir -p "$out/github.com/compose-spec/compose-spec/schema"
    mkdir -p "$out/github.com/OAI/OpenAPI-Specification"

    cp ${schemastore}/src/schemas/json/*.json "$out/json.schemastore.org"
    cp ${compose-spec}/schema/*.json "$out/github.com/compose-spec/compose-spec/schema"
    cp -r ${openapi-specification}/schemas "$out/github.com/OAI/OpenAPI-Specification"
  '';
}
