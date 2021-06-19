{ linuxOnly, ... }:
{
  ".config/polybar/config".source = linuxOnly ./config;
  ".config/polybar/colors".source = linuxOnly ./colors;
  ".config/polybar/lib".source = linuxOnly ./lib;
  ".config/polybar/modules".source = linuxOnly ./modules;
}
