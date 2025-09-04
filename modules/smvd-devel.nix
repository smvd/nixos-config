{ config, pkgs, lib, ... }:

with lib;

{
	options = {
		smvd-devel.enable = mkOption {
			type = types.bool;
			default = false;
			description = "Enable custom shell setup";
		};
	};

	config = mkIf config.smvd-devel.enable {
		environment.systemPackages = [
			pkgs.libgcc
			pkgs.gcc
			pkgs.imgui
			pkgs.gnumake
		];
	};
}
