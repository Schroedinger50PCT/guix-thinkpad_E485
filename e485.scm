(use-modules (guix packages) (guix download) (guix licenses) (guix gexp) (guix git-download) (guix build-system trivial) (gnu) (gnu system nss) (gnu packages) (nongnu packages linux) (nongnu packages mozilla) (srfi srfi-1))
(use-service-modules audio dbus desktop networking mcron sound ssh xorg)
(use-package-modules admin audio
                     bash bootloaders 
                     calcurse certs curl
                     freedesktop 
                     games guile guile-xyz 
                     image 
                     maths matrix music messaging mail mpd
                     package-management 
                     web web-browsers wm 
                     shells shellutils skribilo 
                     telephony text-editors tls terminals tmux
                     image-viewers irc 
                     libreoffice 
                     video 
                     gimp graphics 
                     wget 
                     disk 
                     ncdu 
                     version-control 
                     xorg xdisorg tor i2p linux pdf fonts inkscape)
(operating-system
 (kernel linux)
 ;(kernel-arguments '("modprobe.blacklist=pcspkr,snd_pcsp")) ;Kill The Bell
  (firmware (list linux-firmware)) ;; ToDo: clean out unused firmware
  (host-name "cantaloupe")
  (timezone "Europe/Berlin")
  (locale "de_DE.utf8")
  (keyboard-layout (keyboard-layout "de" "altgr-intl"))
  (bootloader (bootloader-configuration 
               (bootloader grub-efi-bootloader) 
               (target "/boot/efi") 
               (keyboard-layout keyboard-layout)))
  (file-systems (append (list (file-system (device (uuid "root_partition_uuid")) (mount-point "/") (type "ext4")) 
                              (file-system (device (uuid "boot_partition_uuid" 'fat)) (mount-point "/boot/efi") (type "vfat"))
			      (file-system (device (uuid "SATA_drive_uuid")) (mount-point "/data") (type "ext4"))) %base-file-systems))
  (users (append (list  
          (user-account (name "alice") 
                        (comment "bobs sister")
                        (group "users") 
                        (supplementary-groups '("wheel" "netdev" "audio" "video" "lp")) 
                        (home-directory "/home/bob") 
                        (shell (file-append gash "/bin/gash")))
	  ;(user-account (name "root") 				; this is just creating a second entry for root in /etc/passwd, the old one using bash is still present after every rebuild 
          ;              (comment "I_am_Root")                  ; the correct solution would be to rebuild guix with the default user shell set to gash in shadow.scm
          ;              (group "root")  
	  ;              (shell (file-append gash "/bin/gash")))
	  ) %base-user-accounts))
  (issue "")
  (packages (append (list alsa-lib alsa-utils acpid alacritty alpine
                         blender bluez-alsa 
                         calcurse curl 
                         firefox/wayland
                         fdisk flatpak font-iosevka font-tamzen
                         gash gash-utils gnugo gimp git gpm grim
                         htop
                         i2pd imv inkscape iptables 
                         kakoune
			 lf libreoffice lmms lynx 
                         mcron mercurial mpd mpv mumble 
                         ncdu ncmpcpp
                         skribilo slurp sway
			 tor torsocks
                         wget wpa-supplicant
                         xdg-utils xrdb 
                         zathura zathura-pdf-mupdf zathura-djvu
			 nss-certs) %base-packages))
  (services (append (list
      (service gpm-service-type)
      (service tor-service-type)
      (service wpa-supplicant-service-type (wpa-supplicant-configuration (config-file "/path/to/dots/wpa_supplicant.conf") (interface "wlp4s0")))
      (service dhcp-client-service-type)
      (dropbear-service (dropbear-configuration (port-number 22) (root-login? #f) (password-authentication? #f)))
      (bluetooth-service #:auto-enable? #f)
      ;I need pulse for some university stuff
      ;(service alsa-service-type
      ;          (alsa-configuration
      ;           (alsa-plugins alsa-plugins)
      ;           ;(pulseaudio #t)
      ;           (extra-options "pcm.!spdif { type hw
      ;                                        card 1
      ;                                        device 0}
      ;                          defaults.bluealsa { interface \"hci0\"            
      ;                                              device \"E3:28:E9:23:17:75\"  
      ;                                              profile \"a2dp\"}
      ;                          pcm.!default {  type plug
      ;                                        	slave.pcm { @func getenv
      ;                                                      vars [ ALSAPCM ]
      ;                                                      default \"spdif\"}}" )))
      (service elogind-service-type (elogind-configuration 
                                    (handle-suspend-key 'ignore)	
                                    (handle-hibernate-key 'ignore) 
                                    (handle-lid-switch 'ignore) 
                                    (handle-lid-switch-docked 'ignore)))
      (service mpd-service-type (mpd-configuration 
                                 (user "mpd")
                                 ;(port "6600")
                                 (state-file "/data/mpd/state")
                                 (playlist-dir "/data/mpd/playlists")
                                 (db-file "/data/mpd/database")
                                 (music-dir "/data/music")
				 ;(outputs (list (mpd-output
					   ;(name "MPD")
                                           ; (type "alsa")
                                           ; (mixer-type 'null)
                                           ; (enabled? #t))))
                                 )))
      (modify-services %base-services (console-font-service-type config => (map (lambda (tty) (cons tty "/run/current-system/profile/share/kbd/consolefonts/TamzenForPowerline10x20.psf")) '("tty1" "tty2" "tty3" "tty4" "tty5" "tty6")))
      ;; Bashism is likely to kill your setup, be carefull when enabeling this
      ;(special-files-service-type config => `(("/bin/sh" ,(file-append gash "/bin/sh"))))
		       )))
  (name-service-switch %mdns-host-lookup-nss))
