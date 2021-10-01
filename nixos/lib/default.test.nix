{ lib, pkgs }:

with lib;
let
  x = pkgs.callPackage ./. { };
in
runTests {
  testCallFunctionWithFuncion = {
    expr = x.callIfFunction (args: args) 1337;
    expected = 1337;
  };

  testCallFunctionWithInt = {
    expr = x.callIfFunction 7331 1337;
    expected = 7331;
  };
}
