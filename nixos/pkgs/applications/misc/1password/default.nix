{ stdenv, fetchzip, autoPatchelfHook, fetchurl, xar, cpio, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "1password";
  version = "1.8.0";
  src =
    if stdenv.isLinux && stdenv.hostPlatform.system == "x86_64-linux"
    then
      fetchzip
        {
          url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
          sha256 = "0v3s0k0w526pzqa1r4n4zkfjkxfjw1blf7f0h57fwh915hcvc4lx";
          stripRoot = false;
        }
    else throw "Architecture not supported";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ xar cpio ];

  postPhases = [ "postInstall" ];

  unpackPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat Payload | cpio -i
  '';

  installPhase = ''
    install -D op $out/bin/op
  '';

  postInstall = ''
    installShellCompletion --bash --name op <($out/bin/op completion bash)
    installShellCompletion --zsh --name _op <($out/bin/op completion zsh)
  '';

  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = [ installShellFiles ] ++ stdenv.lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/op --version
  '';

  meta = with stdenv.lib; {
    description = "1Password command-line tool";
    homepage = "https://support.1password.com/command-line/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI";
    maintainers = with maintainers; [ joelburget marsam ];
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
