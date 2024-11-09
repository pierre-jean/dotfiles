{ pkgs } : {
	packages.default = pkgs.cowsay;
	packages.cli = import ./cli.nix { inherit pkgs; };
	packages.desktop = import ./desktop.nix { inherit pkgs; };
}
