{ linuxOnly, ... }:
{
  ".config/rofi/lib".source = linuxOnly ./lib;
  ".config/rofi/modes".source = linuxOnly ./modes;
}
