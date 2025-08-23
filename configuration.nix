{config, lib, pkgs, ... }:

let
	secrets = import ./secrets.nix;
in
{
	imports =
	[
		./hardware-configuration.nix
		./modules/smvd-desktop.nix
		./modules/smvd-shell.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "nixos-asus";

	networking.wireless.enable = true;
	networking.wireless.networks = {
		vanDelft = {
			psk = secrets.vanDelftWifiPassword;
		};
	};

	time.timeZone = "Europe/Amsterdam";
	i18n.defaultLocale = "en_US.UTF-8";

	services.pipewire = {
		enable = true;
		pulse.enable = true;
	};

	users.users.smvd = {
		isNormalUser = true;
		extraGroups = [ "wheel" ];
	};

	services.openssh.enable = true;

	smvd-desktop.enable = true;
	smvd-shell.enable = true;
	smvd-programs.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	system.stateVersion = "25.05";
}
