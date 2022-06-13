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

  testExecuteCommandWithOKScript = {
    expr = x.executeCommand "test" ''
      echo Hello
    '';
    expected = { stdout = "Hello\n"; stderr = ""; code = 0; };
  };

  testExecuteCommandWithBadScript = {
    expr = x.executeCommand "test" ''
      echo Bad >&2
      exit 23
    '';
    expected = { stdout = ""; stderr = "Bad\n"; code = 23; };
  };

  testExecuteWithOKScript = {
    expr = x.execute "test" ''
      echo Hello
    '';
    expected = "Hello\n";
  };

  testExecuteJSWithOKScript = {
    expr = x.executeJS "test" ''
      console.log("Hello, JS");
    '';
    expected = "Hello, JS\n";
  };

  testFromYAML = {
    expr = x.fromYAML ''
      - Hello
      - 42
      - far:
          away: true
    '';
    expected = [ "Hello" 42 { far.away = true; } ];
  };

  testToYAML = {
    expr = x.toYAML {
      hello = "world";
      answer = 42;
      far.away = true;
    };
    expected = ''
      answer: 42
      far:
        away: true
      hello: world
    '';
  };

  testColorsToRGB = {
    expr = x.colors.toRGB "#ABCDEF";
    expected = { r = 171; g = 205; b = 239; };
  };

  testColorsToRGBA = {
    expr = x.colors.toRGBA "#ABCDEF";
    expected = { r = 171; g = 205; b = 239; a = 1; };
  };

  testColorsLighten = {
    expr = x.colors.lighten 10 "#f00";
    expected = "#FF3333";
  };

  testColorsBrighten = {
    expr = x.colors.brighten 10 "#f00";
    expected = "#FF1919";
  };

  testColorsDarken = {
    expr = x.colors.darken 10 "#f00";
    expected = "#CC0000";
  };
}
