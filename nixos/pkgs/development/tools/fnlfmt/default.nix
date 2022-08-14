{ lib, stdenv, fetchgit, makeWrapper, lua, fennel }:

let
  luaEnv = lua.withPackages (ps: [ fennel ]);
in

stdenv.mkDerivation rec {
  name = "fnlfmt";
  version = "0.2.3";

  src = fetchgit {
    url = "https://git.sr.ht/~technomancy/fnlfmt";
    rev = version;
    sha256 = "061hr7gkcc0va1dcqvq45k74jhg5d9q5jz43j6i4zjm1g3jspa8l";
  };

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    runHook preBuild

    echo "#!${luaEnv}/bin/lua" > fnlfmt
    ${fennel}/bin/fennel --compile "$src/cli.fnl" >> fnlfmt
    chmod +x fnlfmt

    ${fennel}/bin/fennel --compile "$src/fnlfmt.fnl" > fnlfmt.lua

    runHook postBuild
  '';

  passthru = {
    luaModule = lua;
    requiredLuaModules = [ fennel ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/lua/5.1"

    cp fnlfmt.lua "$out/share/lua/5.1"

    cp fnlfmt "$out/bin/fnlfmt"

    wrapProgram "$out/bin/fnlfmt" \
      --suffix LUA_PATH ';' "$out/share/lua/5.1/?.lua" \
      --suffix LUA_PATH ';' "$out/share/lua/5.1/?/init.lua"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~technomancy/fnlfmt";
    description = "A formatter for Fennel code";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [];
  };
}
