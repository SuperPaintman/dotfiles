{ callPackage }:

{
  textmate = callPackage ./textmate { };
  vscode = callPackage ./vscode { };
}
