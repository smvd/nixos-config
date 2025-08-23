{ config, pkgs, lib, ... }:

with lib;

{
	options = {
		smvd-shell.enable = mkOption {
			type = types.bool;
			default = false;
			description = "Enable custom shell setup";
		};
	};

	config = mkIf config.smvd-shell.enable {
		environment.systemPackages = [
			pkgs.bat
			pkgs.unzip
			pkgs.jq
			pkgs.killall
			pkgs.btop
			pkgs.git
			pkgs.micro
			pkgs.wget
		];
	};
}
