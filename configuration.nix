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
		./modules/smvd-programs.nix
		./modules/smvd-devel.nix
		./modules/smvd-zephyr.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "nixos-asus";

	networking.wireless.enable = true;
	networking.wireless.userControlled.enable = true;
	networking.wireless.networks = {
		vanDelft = {
			psk = secrets.vanDelftWifiPassword;
		};
		hotspot = {
			psk = secrets.hotspotWifiPassword;
		};
		eduroam = {
			auth = ''key_mgmt=WPA-EAP
			eap=PEAP
			identity="${secrets.eduroamEmail}"	
			password="${secrets.eduroamPassword}"
			phase2="auth=MSCHAPV2"'';
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
	smvd-devel.enable = true;
	smvd-zepyhr.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	system.stateVersion = "25.05";
}
