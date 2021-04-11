{ config, pkgs, ... }:
{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    kernel.sysctl = {
      "max_user_watches" = 524288;
      "kernel.dmesg_restrict" = true;
      "kernel.unprivileged_bpf_disabled" = true;
      "kernel.unprivileged_userns_clone" = 1;
      "net.core.bpf_jit_harden" = true;
    };
  };


}

