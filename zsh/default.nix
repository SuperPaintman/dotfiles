{ optional, ... }:
{
  ".zshrc".source = ./.zshrc;
  ".zsh".source = ./.zsh;
  ".oh-my-zsh".source = ./.oh-my-zsh;
  ".oh-my-zsh-custom".source = ./.oh-my-zsh-custom;
  ".zshrc.local".source = optional ./.zshrc.local;
  ".zsh.local".source = optional ./.zsh.local;
}
