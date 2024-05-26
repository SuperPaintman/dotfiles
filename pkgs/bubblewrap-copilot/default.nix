# This package uses Bubblewrap to isolate Node.js process that runs copilot
# extension.
#
# See: https://github.com/containers/bubblewrap
# See: https://wiki.archlinux.org/title/Bubblewrap

{ pkgs
, stdenv
, lib
, writeShellApplication
, fetchFromGitHub
, bubblewrap
, nodejs
, bash
}:

let
  roBind = path:
    let
      path' = lib.escapeShellArg path;
    in
    "--ro-bind ${path'} ${path'}";

  copilot_lua = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "858bbfa6fa81c88fb1f64107d7981f1658619e0a";
    sha256 = "sha256-x6ylgVR7nrMhvSvtwbh7CufOJO/q+30G+Tvrj3/wgZY=";
  };
in

writeShellApplication {
  name = "bubblewrap-copilot";

  # TODO(SuperPaintman): make the `/nix/store` more strict.
  text = ''
    COPILOT_CONFIG="''${XDG_CONFIG_HOME:-$HOME/.config}/github-copilot"
    if [ ! -d "$COPILOT_CONFIG" ]; then
      (umask 077 && mkdir "$COPILOT_CONFIG")
    fi
    chmod 0700 "$COPILOT_CONFIG"
    for file in "$COPILOT_CONFIG"/*; do
      if [ -f "$file" ]; then
        chmod 0600 "$file"
      fi
    done

    # It seems that Copilot doesn't need access to the program's files.
    # So, no access then.
    exec ${bubblewrap}/bin/bwrap \
      --tmpfs /tmp \
      --proc /proc \
      --dev /dev \
      ${roBind "/etc/resolv.conf"} \
      ${roBind "/nix/store"} \
      ${roBind nodejs} \
      ${roBind "${copilot_lua}/copilot"} \
      --ro-bind "${copilot_lua}/copilot" /opt/copilot \
      --bind "$COPILOT_CONFIG" "$COPILOT_CONFIG" \
      ${nodejs}/bin/node "$@"
  '';
}
