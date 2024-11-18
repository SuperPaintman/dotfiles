{ macOSOnly, ... }:
{
  ".config/alacritty/alacritty.toml".source = ./alacritty.toml;
  ".config/alacritty/default.toml".source = ./default.toml;
  ".config/alacritty/colors.toml".source = ./colors.toml;
  ".config/alacritty/macos.toml".source = macOSOnly ./macos.toml;
}
