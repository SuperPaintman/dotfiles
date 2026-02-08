{ pkgs, ... }:

{
  config = {
    _module.args.libx = (import ../lib { inherit pkgs; }).x;
  };
}
