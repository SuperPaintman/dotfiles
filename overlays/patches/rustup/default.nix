# Fix Rust's OpenSSL problems.
# See: https://discourse.nixos.org/t/openssl-dependency-for-rust/3186

{ rustup, openssl, symlinkJoin, makeWrapper }:

let
  unwrapped = rustup;
in

symlinkJoin {
  pname = "${unwrapped.pname}-with-openssl-${openssl.version}";
  # name = "${unwrapped.name}-with-openssl-${openssl.version}";
  inherit (unwrapped) version;

  paths = [ unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    rm -r "$out/bin"
    mkdir "$out/bin"

    for b in ${unwrapped}/bin/*; do
      if [ ! -e "$b" ]; then
        continue
      fi

      makeWrapper "$b" "$out/bin/$(basename "$b")" \
        --set OPENSSL_INCLUDE_DIR "${openssl.dev}/include" \
        --set OPENSSL_LIB_DIR "${openssl.out}/lib" \
        --set OPENSSL_ROOT_DIR "${openssl.out}"
    done
  '';

  passthru = unwrapped.passthru // { inherit unwrapped; };
  inherit (unwrapped) meta;
}
