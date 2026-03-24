{pkgs, ...}: let
  devShellPackages = with pkgs; [
    clang_21
    raylib
    libGL

    # X11 dependencies
    libX11
    libX11.dev
    libXcursor
    libXi
    libXinerama
    libXrandr
  ];
in
  pkgs.mkShell {
    nativeBuildInputs = devShellPackages;
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath devShellPackages;
  }
