{ linuxOnly, ... }:
{
  ".gtkrc-2.0".source = linuxOnly ./.gtkrc-2.0;
  ".config/gtk-3.0/settings.ini".source = linuxOnly ./gtk-3.0/settings.ini;
}
