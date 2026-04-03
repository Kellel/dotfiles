{ pkgs, ... }:

let
  version = "0.118.0";

  openai-codex = pkgs.stdenv.mkDerivation {
    pname = "openai-codex";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-n3icJBOFQx8f6czScRMhHxz9hGVfFVpcBiAQtixvWi8=";
    };

    sourceRoot = ".";
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      mv codex-x86_64-unknown-linux-musl $out/bin/codex
    '';
  };
in
{
  home.packages = [ openai-codex ];
}
