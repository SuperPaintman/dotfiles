{ optional, ... }:
{
  ".gitconfig".source = ./.gitconfig;
  ".git-global".source = ./.git-global;
  ".gitconfig.local".source = optional ./.gitconfig.local;
}
