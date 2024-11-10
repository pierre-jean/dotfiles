{ ... }:

{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  # hardware.graphics.enable = true; # replace hardware.opengl.enable on unstable
  # hardware.graphics.enable32Bit = true; # replace hardware.opengl.driSupport32Bit on unstable
}
