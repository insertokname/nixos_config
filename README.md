## My NixOs config

This config is made for multiple computers and so it is organized by "hardware" and "configurations"

configurations represents everything related to user space customization (like window managers, programs, etc...)

while hardware represents every machine specific setting that must remain constant in a system like (boot options, specific device drivers, screen resolution, etc...)

## Running the config

If you want to run this for some reason its pretty easy, the only thing you have to do is copy over your hardware specific settings into the harware folder (there are only a few of those thankfully) and select your user space config

Requirements:
- obviously NixOs

*Clone the repo with:*

```
git clone https://github.com/insertokername/nixos_config.git
cd nixos_config
```

Quick rundown:
Now we need to make a "hardware profile" for you pc. We need to specify some stuff so that your pc can boot and so that you will have functional users. This is all defined in the "hardware" folder and we will be defining your hardware config under "example". 
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
obviously your boot settings will most likely be different

*And we're almost done, we just have to select our new hardware config:*
```
echo "example" > cur_hardware
```
***The "cur_hardware" file is gitignored and represents what hardaware you are currently on. If you ever decide to move your hardware profile out of ./hardware/example you will have to change the contents of ./cur_hardware to match its name***


That's all! We are going to rebuild our system using:
```
sudo nixos-rebuild switch --flake path:.#{SELECTED CONFIGURATION} --impure
```

**please don't forget to read last two "IMPORTANT" paragraphs!**

On subsequent rebuilds the same command is required. If you want to switch configurations just change the {SELECTED CONFIGURATION} to whatever you want.

**for faster builds comment out `./configurations/fekete/custom_pkgs.nix` from `flake.nix` this disables some custom packages i built for myself**

**IMPORTANT: when first booting up a custom config a user named "test" will be provided, this users password is also "test" and it is defined in plain text under `hardware/example/users.nix`, this i very unsafe for obvious reasons! If you are planning on actually using this config please make sure to delete this user and define your own WITHOUT specifing the password in plain text. Read about it [here](https://nlewo.github.io/nixos-manual-sphinx/configuration/user-mgmt.xml.html).**

**VERY IMPORTANT: the "test" user overwrites any users in your current nixos instalation so you should copy over your previous user from `/etc/nixos/configuration.nix` to `hardware/example/users.nix`**

**Errors may occur when rclone is not configurated on the user but the rclone service is included in the hardware profile, in this case disable the rclone service, install rclone, configure it according to what the service requires, and then re enable the service and rebuild nixos**