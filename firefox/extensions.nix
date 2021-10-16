# See: https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix

{ lib, ... }:

[
  rec {
    pname = "1password_x_password_manager";
    version = "1.22.3";
    url = "https://addons.mozilla.org/firefox/downloads/file/3677399/${pname}-${version}-fx.xpi";
    sha256 = "05ffc0d540e1635755a79a102af602adc7f91b576876b32493501b8b2a87d662";
    meta = {
      license = {
        shortName = "1pwd";
        fullName = "Service Agreement for 1Password users and customers";
        url = "https://1password.com/legal/terms-of-service/";
        free = false;
      };
    };
  }
  rec {
    pname = "tab_manager_plus_for_firefox";
    version = "5.2.0";
    url = "https://addons.mozilla.org/firefox/downloads/file/3594532/${pname}-${version}-fx.xpi";
    sha256 = "0gc9860gh55pibk26jfc2k2n661a25ghzrs883msi6m0qr9kz1d1";
    meta = with lib; {
      license = licenses.mpl20;
    };
  }
  rec {
    pname = "greasemonkey";
    version = "4.11";
    url = "https://addons.mozilla.org/firefox/downloads/file/3716451/${pname}-${version}-fx.xpi";
    sha256 = "1w3k27zy1qh4j9ap8xbngdy5kgrp88frj1zjgjj1d6vayyb5mf2y";
    meta = with lib; {
      license = licenses.mit;
    };
  }
  rec {
    pname = "turbulence_tab_manager";
    version = "0.1.0";
    url = "https://addons.mozilla.org/firefox/downloads/file/3849754/${pname}-${version}-fx.xpi";
    sha256 = "1gsx83k4icankima834nxvhh2bxjrpsi8dn8sicjhc4jmda8ys6w";
    meta = with lib; {
      license = licenses.gpl3;
    };
  }
]
