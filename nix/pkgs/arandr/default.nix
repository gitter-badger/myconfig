{ stdenv, fetchurl, xrandr, python2Packages, git }:

let
  inherit (python2Packages) buildPythonApplication docutils pygtk;
in buildPythonApplication rec {
  name = "arandr-0.1.9";

  # src = fetchurl {
  #   url = "http://christian.amsuess.com/tools/arandr/files/${name}.tar.gz";
  #   sha256 = "1i3f1agixxbfy4kxikb2b241p7c2lg73cl9wqfvlwz3q6zf5faxv";
  # };
  # src = fetchgit {
  #   url = "git://anonscm.debian.org/arandr/arandr.git";
  #   rev = "790cd346bbd57426930a2b3beb654cf3a39712fd";
  # };
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=arandr/arandr.git;a=snapshot;h=790cd346bbd57426930a2b3beb654cf3a39712fd;sf=tgz";
    sha256 = "1i3f1agixxbfy4kxikb2b241p7c2lg73cl9wqfvlwz3q6zf5faxv";
  };

  patches = [
      ./0001-Added-scale-and-scale_from.patch
  ];
  patchPhase = ''
    ${git}/bin/git init
    for i in $patches; do
      ${git}/bin/git apply $i
    done
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  buildInputs = [ docutils ];
  propagatedBuildInputs = [ xrandr pygtk ];

  meta = {
    homepage = http://christian.amsuess.com/tools/arandr/;
    description = "A simple visual front end for XRandR";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
  };
}
