{ useXDG ? false, ... }:

if useXDG
then
  {
    configFile = {
      "git/config".source = ./.gitconfig;
    };
  }
else
  {
    file = {
      ".gitconfig".source = ./.gitconfig;
    };
  }
