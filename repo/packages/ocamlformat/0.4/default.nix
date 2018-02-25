world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      base-unix = opamSelection.base-unix;
      cmdliner = opamSelection.cmdliner;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocaml-migrate-parsetree = opamSelection.ocaml-migrate-parsetree;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlformat_support = opamSelection.ocamlformat_support;
      stdio = opamSelection.stdio;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ocamlformat-0.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocamlformat";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1jf0xywh93rcca0rmipxb4myqj1d6wqq0qgkff1pqx8b01nbcjxw";
    url = "https://github.com/ocaml-ppx/ocamlformat/archive/0.4.tar.gz";
  };
}

