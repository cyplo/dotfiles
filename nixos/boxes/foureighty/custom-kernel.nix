{ config, pkgs, ... }:
{
  powerManagement.cpuFreqGovernor = "ondemand";
  boot.kernelPatches = [ {
    name = "foureighty";
    patch = null;
    extraConfig = ''
      WATCH_QUEUE y
      MCORE2 y
      ENERGY_MODEL y
      INTEL_TXT y
      LOCKUP_DETECTOR y
      HARDLOCKUP_DETECTOR y
      BUG y

      DEBUG_RODATA        y
      DEBUG_SET_MODULE_RONX y
      SECURITY_SELINUX_DISABLE  n
      SECURITY_WRITABLE_HOOKS  n

      STRICT_KERNEL_RWX  y

      STRICT_DEVMEM y
      DEBUG_CREDENTIALS     y
      DEBUG_NOTIFIERS       y
      DEBUG_PI_LIST         y
      DEBUG_PLIST           y
      DEBUG_SG              y
      SCHED_STACK_END_CHECK  y

      SHUFFLE_PAGE_ALLOCATOR  y
      SLUB_DEBUG y

      PAGE_POISONING            y
      PAGE_POISONING_NO_SANITY  y
      PAGE_POISONING_ZERO       y

      SECURITY_SAFESETID  y

      PANIC_TIMEOUT  -1

      GCC_PLUGINS  y
      GCC_PLUGIN_LATENT_ENTROPY  y

      GCC_PLUGIN_STRUCTLEAK  y
      GCC_PLUGIN_STRUCTLEAK_BYREF_ALL  y
      GCC_PLUGIN_STACKLEAK  y
      GCC_PLUGIN_RANDSTRUCT y
      GCC_PLUGIN_RANDSTRUCT_PERFORMANCE  y

      ACPI_CUSTOM_METHOD  n
      PROC_KCORE          n
      INET_DIAG           n

      INET_DIAG_DESTROY  option no
      INET_RAW_DIAG      option no
      INET_TCP_DIAG      option no
      INET_UDP_DIAG      option no
      INET_MPTCP_DIAG    option no


      CC_STACKPROTECTOR_STRONG y

      KFENCE y
    '';
  } ];
}
