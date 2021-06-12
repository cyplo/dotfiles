{ config, pkgs, ... }:
{
  nix.allowedUsers = [ "@users" ];
  security.lockKernelModules = false;
  security.protectKernelImage = true;
  security.forcePageTableIsolation = true;
  security.virtualisation.flushL1DataCache = "always";
  security.apparmor.enable = true;
  services.haveged.enable = true;
  boot.kernelParams = [
    "page_poison=1"
    "page_alloc.shuffle=1"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  boot.kernel.sysctl."net.core.bpf_jit_enable" = false;
  boot.kernel.sysctl."kernel.ftrace_enabled" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" =  "1";
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" =  true;
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" =  false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" =  false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" =  false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" =  false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" =  false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" =  false;
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" =  false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" =  false;
}
