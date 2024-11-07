{ pkgs } : {
	packages.default = pkgs.cowsay;
	packages.cli = import ./cli.nix { inherit pkgs; };
}
