{ self, lib, config, ... }:
{
  options.moduleDependencies = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.listOf lib.types.str);
    default = { };
    description = "Map from feature name to the features it requires.";
  };

  config.flake.lib.mkFeatureModules =
    { username, features }:
    let
      nixosMods = self.modules.nixos;
      hmMods = self.modules.homeManager or { };

      exists = n: nixosMods ? ${n} || hmMods ? ${n};
      depsOf = n: lib.unique (config.moduleDependencies.${n} or [ ]);

      unknown = lib.filter (n: !exists n) features;

      unknownDepKeys = lib.filter (n: !exists n) (lib.attrNames config.moduleDependencies);

      missing = lib.concatMap (
        n: map (d: "  '${n}' requires '${d}', which is not enabled")
          (lib.filter (d: !lib.elem d features) (depsOf n))
      ) features;

      checked =
        if unknown != [ ] then
          throw "mkFeatureModules: unknown feature(s): ${lib.concatStringsSep ", " unknown}"
        else if unknownDepKeys != [ ] then
          throw "mkFeatureModules: > declared for unknown feature(s): ${lib.concatStringsSep ", " unknownDepKeys}"
        else if missing != [ ] then
          throw "mkFeatureModules: unmet dependencies:\n${lib.concatStringsSep "\n" missing}"
        else
          features;

      nixosFeatures = lib.filter (n: nixosMods ? ${n}) checked;

      isHomeManagerInstalled = lib.elem "home-manager" nixosFeatures;
      homeManagerFeatures =
        if isHomeManagerInstalled then lib.filter (n: hmMods ? ${n}) checked else [ ];
    in
    (map (n: nixosMods.${n}) nixosFeatures)
    ++ lib.optional (homeManagerFeatures != [ ]) {
      home-manager.users.${username}.imports = map (n: hmMods.${n}) homeManagerFeatures;
    };
}