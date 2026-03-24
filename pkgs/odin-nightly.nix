{
  pkgs,
  inputs,
  ...
}:
pkgs.odin.overrideAttrs (prev: _: {
  src = inputs.odin-src;
  version = "${inputs.odin-src.shortRev or "nightly"}";
  patches = [
    ./raylib-system.patch
  ];

  # Same as in previous derivation, but set RAYLIB_SYSTEM by default
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp odin $out/bin/odin

    mkdir -p $out/share
    cp -r {base,core,vendor,shared} $out/share

    wrapProgram $out/bin/odin \
      --prefix PATH : ${
      pkgs.lib.makeBinPath (
        with pkgs.llvmPackages; [
          bintools
          llvm
          clang
          lld
        ]
      )
    } \
      --set-default ODIN_ROOT $out/share \
      --set-default RAYLIB_SYSTEM true

    make -C "$out/share/vendor/cgltf/src/"
    make -C "$out/share/vendor/stb/src/"
    make -C "$out/share/vendor/miniaudio/src/"

    runHook postInstall
  '';
})
