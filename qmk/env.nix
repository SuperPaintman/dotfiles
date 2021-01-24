{ pkgs, writeShellScript, ... }:

writeShellScript "env" ''
  export PATH=${pkgs.arduino}/share/arduino/hardware/tools/avr/bin:$PATH
  export PATH=${pkgs.gcc-arm-embedded}/bin:$PATH
  export PATH=${pkgs.dfu-util}/bin:$PATH
  export PATH=${pkgs.dfu-programmer}/bin:$PATH
''
