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
    kpatch-build -c ${kernel.configfile} -v ${kernel.dev}/vmlinux -s $PWD/source ${patch} \
             -j$NIX_BUILD_CORES

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
