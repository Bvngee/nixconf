{ lib, ... }:
let
  inherit (lib)
    substring
    length
    stringToCharacters
    removePrefix
    foldl
    foldl'
    imap0
    genList;
in
rec {
  # TODO: add all of this to new custom lib?

  # Color related functions
  # all modified from https://gist.github.com/corpix/f761c82c9d6fdbc1b3846b37e1020e11
  # and Fufexan

  addHashtag = c: "#${c}";
  stripHashtag = c: removePrefix "#" c;

  # convert rrggbb hex code to rgba(r, g, b)
  hexToRgb = color:
    let
      c = stripHashtag color;
      r = toString (hexToDecimal (substring 0 2 c));
      g = toString (hexToDecimal (substring 2 2 c));
      b = toString (hexToDecimal (substring 4 2 c));
    in
    "rgb(${r}, ${g}, ${b})";

  # convert rrggbb hex code to rgba(r, g, b, a)
  # with passed in string alpha value (eg. "0.75")
  hexToRgba = color: alpha:
    let
      c = stripHashtag color;
      r = toString (hexToDecimal (substring 0 2 c));
      g = toString (hexToDecimal (substring 2 2 c));
      b = toString (hexToDecimal (substring 4 2 c));
    in
    "rgba(${r}, ${g}, ${b}, ${alpha})";

  # convert a hex value to an integer
  hexToDecimal = v:
    let
      hexToInt = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
        "A" = 10;
        "B" = 11;
        "C" = 12;
        "D" = 13;
        "E" = 14;
        "F" = 15;
      };
      chars = stringToCharacters v;
    in
    foldl
      (a: v: a + v)
      0
      (imap0
        (k: v: hexToInt."${v}" * (pow 16 ((length chars) - k - 1)))
        chars);

  #  pow =
  #    let
  #      pow' = base: exponent: value:
  #        # FIXME: It will silently overflow on values > 2**62 :(
  #        # The value will become negative or zero in this case
  #        if exponent == 0
  #        then 1
  #        else if exponent <= 1
  #        then value
  #        else (pow' base (exponent - 1) (value * base));
  #    in
  #    base: exponent: pow' base exponent base;
  pow = base: exp: foldl' (a: x: x * a) 1 (genList (_: base) exp);
}
