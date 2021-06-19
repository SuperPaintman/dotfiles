{ linuxOnly, ... }:
{
  ".config/rofi/config.rasi".source = linuxOnly ./config.rasi;
  ".config/rofi/colors.rasi".source = linuxOnly ./colors.rasi;
  ".config/rofi/theme.rasi".source = linuxOnly ./theme.rasi;
  ".config/rofi/lib".source = linuxOnly ./lib;
  ".config/rofi/modes".source = linuxOnly ./modes;
}
