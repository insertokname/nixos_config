# Given a username and a list of feature names, returns a list of NixOS
# modules.
#
# For each feature name:
#   if self.modules.nixos.{featureName} exists, it is returned
#
#   if self.modules.homeManager.{featureName} exists, it is added to a
#   home-manager.users.{username}.imports and returned as a nixos module
#
# home-manager's NixOS module is add via the  "home-manager" feature
# (from modules/home-manager.nix). If the "home-manager" feature
# isn't present, any home manager part of listed features will be ignored.
{ self, lib, ... }:
{
  flake.lib.mkFeatureModules =
    { username, features }:
    let
      exists = n: lib.hasAttr n self.modules.nixos || lib.hasAttr n self.modules.homeManager;
      checked = map (
        n: if exists n then n else throw "mkFeatureModules: unknown feature '${n}'"
      ) features;

      nixosFeatures = lib.filter (n: lib.hasAttr n self.modules.nixos) checked;

      isHomeManagerInstalled = lib.elem "home-manager" nixosFeatures;
      homeManagerFeatures =
        if isHomeManagerInstalled then
          lib.filter (n: lib.hasAttr n self.modules.homeManager) checked
        else
          [ ];
    in
    (map (n: self.modules.nixos.${n}) nixosFeatures)
    ++ lib.optional (homeManagerFeatures != [ ]) {
      home-manager.users.${username}.imports = map (n: self.modules.homeManager.${n}) homeManagerFeatures;
    };
}
