# Nix/NixOS flake for Odin Compiler

This flake will provide a Git version of Odin compiler and OLS tools.

## To Start
In your `flake.nix` file add:

```nix
inputs = {
    odin-nightly = {
        url = "github:Yappaholic/odin-nightly";
        inputs.nixpgks.follows = "nixpkgs";
    };    
    ...
}
# then in your NixOS configuration you can add
modules = [
    (nixpkgs.overlays = [inputs.odin-nightly.overlays.default])
];
```

After that adding `ols` or `odin` packages to your configuration will pull
latest versions and build them from source.
