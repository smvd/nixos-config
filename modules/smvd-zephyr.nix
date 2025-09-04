{ config, pkgs, lib, ... }:

with lib;

{
	options = {
		smvd-zepyhr.enable = mkOption {
			type = types.bool;
			default = false;
			description = "Enable custom zephyr setup";
		};
	};

	config = mkIf config.smvd-zepyhr.enable {
		environment.systemPackages = [
			pkgs.dtc
			pkgs.ninja
			pkgs.git
			pkgs.cmake
			pkgs.gperf
			pkgs.ccache
			pkgs.dfu-util
			pkgs.wget
			pkgs.xz
			pkgs.file
			pkgs.gnumake
			pkgs.python313
			pkgs.python313Packages.pip
			pkgs.python313Packages.setuptools
			pkgs.python313Packages.wheel
			pkgs.python313Packages.tkinter
		];
	};
}
