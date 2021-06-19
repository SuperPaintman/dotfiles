{ optional, ... }:
{
  ".bashrc".source = ./.bashrc;
  ".bash_profile".source = ./.bash_profile;
  ".bash".source = ./.bash;
  ".bashrc.local".source = optional ./.bashrc.local;
  ".bash_profile.local".source = optional ./.bash_profile.local;
  ".bash.local".source = optional ./.bash.local;
}
