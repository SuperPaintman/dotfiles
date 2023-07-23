{ lib, ... }:

with lib;

let
  toHEXNumber = v:
    if v == 0 then "0"
    else if v == 1 then "1"
    else if v == 2 then "2"
    else if v == 3 then "3"
    else if v == 4 then "4"
    else if v == 5 then "5"
    else if v == 6 then "6"
    else if v == 7 then "7"
    else if v == 8 then "8"
    else if v == 9 then "9"
    else if v == 10 then "A"
    else if v == 11 then "B"
    else if v == 12 then "C"
    else if v == 13 then "D"
    else if v == 14 then "E"
    else if v == 15 then "F"
    else
      assertMsg false "Invalid hex number.";

  toHEXColorChannel = c:
    let
      c1 = c / 16;
      c2 = c - (c1 * 16);
    in
    "${toHEXNumber c1}${toHEXNumber c2}";
in

rec {
  toHEXColor = color: "#${toHEXColorChannel color.r}${toHEXColorChannel color.g}${toHEXColorChannel color.b}";
}
