;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))
(use-modules (gnu packages version-control))
(use-modules (gnu packages gnuzilla))
(use-modules (gnu packages vim))
(use-modules (gnu packages ssh))

(use-service-modules desktop networking ssh xorg)

(define %xorg-libinput-config
  "Section \"InputClass\"
  Identifier \"Touchpads\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsTouchpad \"on\"

  Option \"Tapping\" \"on\"
  Option \"TappingDrag\" \"on\"
  Option \"DisableWhileTyping\" \"on\"
  Option \"MiddleEmulation\" \"on\"
  Option \"ScrollMethod\" \"twofinger\"
EndSection
Section \"InputClass\"
  Identifier \"Keyboards\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsKeyboard \"on\"
EndSection
")

(operating-system
  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout (keyboard-layout "pl"))
  (host-name "vm")
  (users (cons* (user-account
                  (name "cyryl")
                  (comment "")
                  (group "users")
                  (home-directory "/home/cyryl")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "i3-wm")
            (specification->package "i3status")
            (specification->package "dmenu")
            (specification->package "st")
            (specification->package "nss-certs")
	git
	icecat
	vim
	openssh)
      %base-packages))
  (services
    (append
      (list (service gnome-desktop-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout)
                (extra-config (list %xorg-libinput-config)))))
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "19d49460-ecdd-4058-99c5-82d35b0369d3"))
            (target "cryptroot")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "btrfs")
             (dependencies mapped-devices))
           %base-file-systems)))
