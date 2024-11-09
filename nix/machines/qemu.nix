{ pkgs, ... }
:
{
	environment = {
	    systemPackages = [
		    pkgs.qemu
		    pkgs.quickemu
	    ];
	};
    # Booting UEFI
    #environment = {
        #pkgs.writeShellScriptBin "qemu-system-x86_64-uefi"
          #qemu-system-x86_64 \
            #-bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
            #"$@";
#            
    #};
}
