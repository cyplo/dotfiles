{ config, pkgs, ... }:
{
    services.syncthing = {
        enable = true;
        user = "cyryl";
        dataDir = "/home/cyryl/.syncthing";
        openDefaultPorts = true;
    };
}