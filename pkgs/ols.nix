{
  pkgs,
  odin-nightly,
  inputs,
  ...
}:
pkgs.ols.overrideAttrs (final: _: {
  src = inputs.ols-src;
  version = "${inputs.ols-src.shortRev or "nightly"}";
  buildInputs = [odin-nightly];
  patchPhase = ''
    substituteInPlace build.sh \
      --replace-fail "dev-\$(date -u '+%Y-%m-%d')-\$(git rev-parse --short HEAD)" \
      "nightly-${final.version}"
    runHook postPatch
  '';
})
