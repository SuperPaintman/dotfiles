{ lib, vscode-utils, makeWrapper, sumneko-lua-language-server }:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "lua";
    publisher = "sumneko";
    version = "2.4.7";
    sha256 = "1wdsrhg0qnxksqlz1pmvhpwpzir4c9n7rmrm96z3brgqfnpc2zsw";
  };

  nativeBuildInputs = [ makeWrapper ];

  # See: https://github.com/sumneko/lua-language-server/wiki/Precompiled-Binaries.
  postInstall = ''
    rm -r $out/share/vscode/extensions/sumneko.lua/server/bin/Windows
    rm -r $out/share/vscode/extensions/sumneko.lua/server/bin/macOS
    rm $out/share/vscode/extensions/sumneko.lua/server/bin/Linux/lua-language-server

    makeWrapper \
      "${sumneko-lua-language-server}/bin/lua-language-server" \
      "$out/share/vscode/extensions/sumneko.lua/server/bin/Linux/lua-language-server"
  '';
}
