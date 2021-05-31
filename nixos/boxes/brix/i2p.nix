{ config, pkgs, ... }:
{
  services.i2pd = {
    enable = true;
    bandwidth = 1024; # kb/s
    proto.http.enable = true;
    proto.httpProxy.enable = true;
  };
}
