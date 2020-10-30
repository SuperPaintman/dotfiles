{ useXDG ? false, ... }:

if useXDG
then
  {
    configFile = {
      "bash/bashrc".source = ./.bashrc;
      "bash/bash_profile".source = ./.bash_profile;
      "bash/aliases.sh".source = ./.bash/aliases.sh;
      "bash/completions.sh".source = ./.bash/completions.sh;
      "bash/env.sh".source = ./.bash/env.sh;
      "bash/functions.sh".source = ./.bash/functions.sh;
      "bash/key-bindings.sh".source = ./.bash/key-bindings.sh;
      "bash/path.sh".source = ./.bash/path.sh;
      "bash/theme.sh".source = ./.bash/theme.sh;
    };
  }
else
  {
    file = {
      ".bashrc".source = ./.bashrc;
      ".bash_profile".source = ./.bash_profile;
      ".bash".source = ./.bash;
    };
  }
