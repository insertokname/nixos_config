{config, pkgs, ...}:
{
    environment.systemPackages=[
        ((import custom_pkgs/pbinfo-cli.nix) {pkgs=pkgs;})
    ];
}
