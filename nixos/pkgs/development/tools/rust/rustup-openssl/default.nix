# Fix Rust's OpenSSL problem.
# See: https://discourse.nixos.org/t/openssl-dependency-for-rust/3186

{ stdenv, rustup, openssl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rustup-openssl";
  version = rustup.version;

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    for b in ${rustup}/bin/*; do
      if [ ! -f "$b" ]; then
        continue
      fi

      makeWrapper "$b" "$out/bin/$(basename $b)" \
        --set OPENSSL_INCLUDE_DIR "${openssl.dev}/include" \
        --set OPENSSL_LIB_DIR "${openssl.out}/lib" \
        --set OPENSSL_ROOT_DIR "${openssl.out}"
    done

    cp -r ${rustup}/share $out/share
  '';
}
