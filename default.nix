let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  inherit (pkgs)
    lib
    stdenv
    fetchFromGitHub
    python3
    perl
    universal-ctags;
in
stdenv.mkDerivation {
  name = "elixir";

  src = fetchFromGitHub {
    owner = "bootlin";
    repo = "elixir";
    rev = "0a466866430c460221f10f5464cfec72c1e110ee";
    sha256 = "RiDx0DXxAzz5f6cYNlLCCg23dfdHyYFFHyLa7tpSUqk=";
  };

  nativeBuildInputs = [
    python3
    perl
    python3.pkgs.wrapPython
  ];

  pythonPath = with python3.pkgs; [
    pytest
    bsddb3
    falcon
    jinja2
    pygments
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';

  # Do this instead of using wrapPythonPrograms, which creates a wrapper script;
  # some of the files import other files that may be executed (e.g. api.py
  # imports query.py), but importing fails if e.g. query.py is wrapped (which
  # turns it into a bash script).
  postFixup = ''
    buildPythonPath "$out $pythonPath"
    for f in $(find $out -iname '*.py'); do
        echo "Patching $f"
        patchShebangs "$f"
        patchPythonScript "$f"
    done

    wrapProgram $out/find-file-doc-comments.pl \
      --prefix PATH : "${lib.makeBinPath [ universal-ctags ]}"
    wrapProgram $out/script.sh \
      --prefix PATH : "${lib.makeBinPath [ universal-ctags ]}"
  '';
}
