{ pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
  whichgpu = pkgs.writeShellScriptBin "whichgpu" ''glxinfo | grep vendor'';
  nvidiaon = pkgs.writeShellScriptBin "nvidiaon" ''
    export __NV_PRIME_RENDER_OFFLOAD=1;
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0;
    export __GLX_VENDOR_LIBRARY_NAME=nvidia;
    export __VK_LAYER_NV_optimus=NVIDIA_only;
    glxinfo | grep vendor; echo OK!;
  '';
in
  {
    environment.systemPackages = [ nvidia-offload whichgpu nvidiaon ];
    hardware.opengl.enable = true;
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.prime = {
      offload.enable = true;
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
    };
  }
