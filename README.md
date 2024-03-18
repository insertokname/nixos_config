## My NixOs config

This config is made for multiple computers and so it is organized by "hardware" and "configurations"

configurations represents everything related to user space customization (like window managers, programs, etc...)

while hardware represents every "hardware" setting that must remain constant in a system like (boot options, specific device drivers, screen resolution, etc...)

## Running the config

If you want to run this for some reason its pretty easy, the only thing you have to do is copy over your hardware specific settings into the harware folder (there are only a few of those thankfully) and select your user space config

Requirements:
- obviously NixOs

*Clone the repo with:*

```
git clone https://github.com/insertokername/nixos_config.git
```

*Now you have to copy over your harware settings*
```
sudo cp /etc/nixos/hardware-configuration.nix ./hardware/example
```

*Copy all lines from `/etc/nixos/configuration.nix` that start with boot into `hardware/example/boot.nix`. It should look something like this:*

```
{...}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
}
```
obviously your will most likely be different

*And we're almost done, we just have to select our new hardware config:*
```
echo {device = "example";} > cur_device.nix
git add -f cur_device.nix
```

That's all! We are going to rebuild our system using:
```
sudo nixos-rebuild switch --flake .#{SELECTED CONFIGURATION} --impure
```

On subsequent rebuilds the same command is required. If you want to switch configurations just change the {SELECTED CONFIGURATION} to whatever you want.

**Important: when first booting up a custom config a user named "test" will be provided, this users password is also "test" and it is defined in plain text under `hardware/example/users.nix`, this i very unsafe for obvious reasons! If you are planning on actually using this config please make sure to delete this user and define your own WITHOUT specifing the password in plain text. Read about it [here](https://nlewo.github.io/nixos-manual-sphinx/configuration/user-mgmt.xml.html).**
