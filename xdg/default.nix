{ linuxOnly, ... }:
{
  ".config/mimeapps.list".source = linuxOnly ./mimeapps.list;
}
