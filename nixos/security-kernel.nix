{ config, pkgs, ... }:
{
  boot.kernelPatches = [ {
    name = "cyplo-hardened";
    patch = null;
    extraConfig = ''
      LOCKUP_DETECTOR y
      HARDLOCKUP_DETECTOR y
      BUG y

      SECURITY_SELINUX_DISABLE  n

      STRICT_KERNEL_RWX  y

      DEBUG_CREDENTIALS      y
      DEBUG_NOTIFIERS        y
      DEBUG_SG               y
      SCHED_STACK_END_CHECK  y

      SHUFFLE_PAGE_ALLOCATOR  y

      SLUB_DEBUG  y

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
    '';
  } ];
}
