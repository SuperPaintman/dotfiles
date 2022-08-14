{ stdenv, lib, lua }:

stdenv.mkDerivation rec {
  name = "fennel";
  version = "1.1.0";

  src = builtins.fetchTarball {
    url = "https://fennel-lang.org/downloads/${name}-${version}.tar.gz";
    sha256 = "1m4sv8lq26dyx8vvq9l6rv7j9wd20ychyqddrb0skfi14ccb3bhx";
  };

  buildInputs = [
    lua
  ];

  phases = "installPhase";
  installPhase = ''
    mkdir -p "$out" "$out/bin" "$out/share/lua/5.1"

    cp "$src/fennel" "$out/bin/fennel"
    chmod +x "$out/bin/fennel"
    sed -i 's%^#!/usr/bin/env lua$%#!${lua}/bin/lua%' "$out/bin/fennel"

    cp "$src/fennel.lua" "$out/share/lua/5.1/fennel.lua"
  '';

  passthru = {
    luaModule = lua;
    requiredLuaModules = [];
  };

  meta = with lib; {
    homepage = "https://github.com/bakpakin/Fennel";
    description = "Lua Lisp Language";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [];
  };
}
