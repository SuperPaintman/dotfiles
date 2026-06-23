# See: https://github.com/esmuellert/codediff.nvim
# See: https://github.com/NixOS/nixpkgs/blob/d66a65dd4ae3b6530db3f00a4edd977959528919/pkgs/applications/editors/vim/plugins/non-generated/codediff-nvim/default.nix#L12-L14
{ lib, stdenv, fetchFromGitHub, cmake, llvmPackages, neovim }:

with lib;

let
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";

  self = stdenv.mkDerivation rec {
    pname = "codediff.nvim";
    version = "2.49.2";

    src = fetchFromGitHub {
      owner = "esmuellert";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-kT5plTJP4VfN6mFkq6voDTmr9LaZ37W80UU3QUGlKkY=";
    };

    buildInputs =
      lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

    nativeBuildInputs = [
      cmake
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [ 
      # autoPatchelfHook 
    ];

    dontUseCmakeConfigure = true;
    cmakeFlags = [
      # (lib.cmakeBool "ENABLE_OPENMP" false)
    ];

    patches = [
      ./0001-no-dynamic-lib-install.patch
    ];

    CODEDIFF_LIB_NAME = "libvscode_diff_${version}.${libExt}";

    postPatch = ''
      substituteInPlace libvscode-diff/CMakeLists.txt \
        --replace-fail 'add_diff_test(' '# add_diff_test('

      substituteInPlace lua/codediff/core/diff.lua \
         --replace-fail '{{ CODEDIFF_LIB_PATH }}' "$out/lib/${CODEDIFF_LIB_NAME}"

      substituteInPlace lua/codediff/version.lua \
         --replace-fail '{{ CODEDIFF_VERSION }}' '${version}-nix'
    '';

    buildPhase = ''
      runHook preBuild
      cmake -B build -S . $cmakeFlags
      cmake --build build --target vscode_diff
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r {lua,plugin,doc,VERSION} "$out"

      mkdir -p "$out/lib"
      cp "build/libvscode-diff/libvscode_diff.${libExt}" "$out/lib/${CODEDIFF_LIB_NAME}"

      runHook postInstall
    '';

    dontFixup = true; # Don't move the doc dir.

    passthru = {
      lazy = {
        plugin = "esmuellert/codediff.nvim";
        inherit version;
        dir = self;
      };
      lazy.override = attrs: passthru.lazy // attrs;
    };
  };
in
self
