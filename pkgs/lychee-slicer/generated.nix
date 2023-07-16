{ fetchurl, ... }:

{
  lychee-slicer = {
    pname = "lychee-slicer";
    version = "5.2.2";
    src = fetchurl {
      url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-5.2.2.AppImage";
      sha256 = "sha256-INRo3SYHPffFPTFAYGlqh09jpeA+ropWAnwqzvkbF7w=";
    };
  };
}
