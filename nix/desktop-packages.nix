{ pkgs, ...}:
	with pkgs;
[
	# terminal emulators
	alacritty

	# graphics
	inkscape
	gimp
	sxiv

	# 3d
	openscad

	# office
	libreoffice

	# mail
	thunderbird

	# browsers
	lagrange
	qutebrowser
	firefox
	mullvad-browser
	google-chrome

	# social
	signal-desktop
	slack

	# password management
	bitwarden

	# network
	transmission_4-gtk
	mullvad-vpn

	# ide
	jetbrains.rider
]
