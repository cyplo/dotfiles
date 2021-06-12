{ config, pkgs, inputs, ... }:
{
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
    '';
  };

  services.matrix-synapse = {
    enable = true;
    server_name = "cyplo.dev";
    enable_registration = false;
    listeners = [
      {
        port = 8008;
        bind_address = "brix";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = [ "client" "federation" ];
            compress = false;
          }
        ];
      }
    ];
    app_service_config_files = [
    ];
    extraConfig = ''
      experimental_features: { spaces_enabled: true }
    '';
    package = inputs.nixpkgs-nixos-unstable.legacyPackages."x86_64-linux".matrix-synapse;
  };

  networking.firewall.allowedTCPPorts = [ 8008 ];
}
