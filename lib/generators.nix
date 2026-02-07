{ lib, ... }:

with lib;

rec {
  /* */
  mkWTKKeyBinding = keys: description: { inherit keys description; };

  /* */
  toWTKConfig = groups:
    let
      normalizeWTKConfig = groups:
        let
          groups' = sortProperties (mapAttrsToList
            (name: bindings: {
              inherit name bindings;
            })
            groups);
        in
        {
          groups = map
            (group: {
              inherit (group) name;
              bindings = if group.bindings ? _type && group.bindings._type == "order" then group.bindings.content else group.bindings;
            })
            groups';
        };
    in
    lib.generators.toJSON { } (normalizeWTKConfig groups);
}
