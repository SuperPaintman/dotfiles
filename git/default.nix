{ optional, ... }:
{
  ".gitconfig".source = ./.gitconfig;
  ".gitconfig.local".source = optional ./.gitconfig.local;
}
