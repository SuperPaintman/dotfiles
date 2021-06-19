{ linuxOnly, ... }:
{
  ".config/awesome/rc.lua".source = linuxOnly ./rc.lua;
  ".config/awesome/prelude.lua".source = linuxOnly ./prelude.lua;
  ".config/awesome/colors.lua".source = linuxOnly ./colors.lua;
  ".config/awesome/keys.lua".source = linuxOnly ./keys.lua;
  ".config/awesome/apps.lua".source = linuxOnly ./apps.lua;
  ".config/awesome/lib".source = linuxOnly ./lib;
  ".config/awesome/modules".source = linuxOnly ./modules;
  ".config/awesome/theme".source = linuxOnly ./theme;
  ".config/awesome/icons".source = linuxOnly ./icons;
  ".config/awesome/widgets".source = linuxOnly ./widgets;
  ".config/awesome/daemons".source = linuxOnly ./daemons;
  ".config/awesome/hosts".source = linuxOnly ./hosts;
  ".config/awesome/vendor".source = linuxOnly ./vendor;
  ".config/awesome/autostart.sh".source = linuxOnly ./autostart.sh;
}
