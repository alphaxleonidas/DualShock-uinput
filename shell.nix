{ pkgs ? import <nixpkgs> {} }:

let
  myPython = pkgs.python3.withPackages (ps: with ps; [
    evdev
    python-uinput
    pyudev # <-- Added pyudev here
    pip
    virtualenv
  ]);
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    myPython
    stdenv.cc
    linuxHeaders
    systemd
  ];

  shellHook = ''
    export CFLAGS="-I${pkgs.linuxHeaders}/include"
    export LDFLAGS="-L${pkgs.systemd}/lib"
    export LD_LIBRARY_PATH="${pkgs.systemd}/lib:$LD_LIBRARY_PATH"
  '';
}
