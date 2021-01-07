# See: https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix

{ lib, ... }:

[
  {
    pname = "1password-x-password-manager";
    version = "1.22.3";
    url = "https://addons.mozilla.org/firefox/downloads/file/3677399/1password_x_password_manager-1.22.3-fx.xpi";
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
  {
    pname = "tab-manager-plus-for-firefox";
    version = "5.2.0";
    url = "https://addons.mozilla.org/firefox/downloads/file/3594532/tab_manager_plus_for_firefox-5.2.0-fx.xpi";
    sha256 = "0gc9860gh55pibk26jfc2k2n661a25ghzrs883msi6m0qr9kz1d1";
    meta = with lib; {
      license = licenses.mpl20;
    };
  }
]
