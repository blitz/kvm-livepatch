{ kernel, patch, kpatch, util-linux }:
kernel.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    kpatch

    # kpatch needs getopt
    util-linux
  ];

  pname = "livepatch";

  buildPhase = ''
    runHook preBuild

    export CACHEDIR=$(mktemp -d)
    ls -la $PWD/..
    echo PWD
    ls -la $PWD
    kpatch-build -d -c ${kernel.configfile} -v ${kernel.dev}/vmlinux -s $PWD/source ${patch} \
             --skip-distro-check \
             -j$NIX_BUILD_CORES

    echo XXXXXXXXXXX
    find . -name "*.ko"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    install -m755 *.ko $out/

    runHook postInstall
  '';

  # This does things that we don't need.
  postInstall = "";
})
