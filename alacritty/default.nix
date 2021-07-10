{ macOSOnly, ... }:
{
  ".config/alacritty/alacritty.yml".source = ./alacritty.yml;
  ".config/alacritty/default.yml".source = ./default.yml;
  ".config/alacritty/colors.yml".source = ./colors.yml;
  ".config/alacritty/macos.yml".source = (macOSOnly ./macos.yml);
}
