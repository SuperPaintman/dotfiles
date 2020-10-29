{ useXDG ? false, ... }:

if useXDG
then
  {
    configFile = {
      "zsh/.zshrc".source = ./.zshrc;
      "zsh/completions.zsh".source = ./.zsh/completions.zsh;
      "zsh/config.zsh".source = ./.zsh/config.zsh;
      "zsh/functions.zsh".source = ./.zsh/functions.zsh;
      "zsh/key-bindings.zsh".source = ./.zsh/key-bindings.zsh;
      "zsh/oh-my-zsh-config.zsh".source = ./.zsh/oh-my-zsh-config.zsh;
      "zsh/theme.zsh".source = ./.zsh/theme.zsh;
      "zsh/.oh-my-zsh".source = ./.oh-my-zsh;
      "zsh/.oh-my-zsh-custom".source = ./.oh-my-zsh-custom;
    };
  }
else
  {
    file = {
      ".zshrc".source = ./.zshrc;
      ".zsh".source = ./.zsh;
      ".oh-my-zsh".source = ./.oh-my-zsh;
      ".oh-my-zsh-custom".source = ./.oh-my-zsh-custom;
    };
  }
