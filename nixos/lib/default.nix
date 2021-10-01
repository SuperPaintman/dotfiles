{ lib }:
let
  x = self: {
    callIfFunction = f: args: if builtins.isFunction f then (f args) else f;
  };
in
lib.makeExtensible x
