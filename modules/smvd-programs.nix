{ config, pkgs, lib, ... }:

with lib;

{
	options = {
		smvd-programs.enable = mkOption {
			type = types.bool;
			default = false;
			description = "Enable programs";
		};
	};

	config = mkIf config.smvd-desktop.enable {
		environment.systemPackages = [
			pkgs.inkscape
		];
	};
}
