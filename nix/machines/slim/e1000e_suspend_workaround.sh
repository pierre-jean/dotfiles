#!/bin/sh
case $1/$2 in
	pre/*)
	sudo ip link set down enp0s31f6
	sudo modprobe -r e1000e
	;;
	post/*)
	sudo modprobe e1000e
	sudo ip link set up enp0s31f6
	;;
esac
