# Fast and Minimal Pipewire Installation on RPI

* Remove any pipewire and pulseaudio from system

* Install deps look here [pipewire build deps](https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/master/.gitlab-ci.yml) and `libfdk-aac-dev`

* Clone source
```
git clone --depth=1 -b RELEASEVERSION https://gitlab.freedesktop.org/pipewire/pipewire.git pipewire
cd pipewire
```
### Building
```
meson setup builddir -Dsdl2=disabled -Dexamples=disabled -Dtests=disabled -Dman=disabled -Dlibcanberra=disabled -Dflatpak=disabled -Dgsettings=disabled -Dx11=disabled -Dbluez5-backend-hfp-native=disabled -Dbluez5-backend-hsp-native=disabled
```
```
meson compile -C builddir -j3
```
```
cd builddir
```
```
sudo meson install --no-rebuild
```

### Meson configuration result, as this is headless build, disabling many things
```
wireplumber 0.4.14

    Lua version                    : 5.4.4 (built-in)
    systemd conf data              : YES
    libsystemd                     : YES
    libelogind                     : NO

  For documentation
    Python 3 Sphinx related modules: NO
    Doxygen                        : YES
    sphinx-build                   : NO

  For introspection
    Python 3 lxml module           : NO
    Doxygen                        : YES
    g-ir-scanner                   : NO

pipewire 0.3.71

    systemd conf data                       : YES
    libsystemd                              : YES
    intl support                            : YES
    pipewire-alsa                           : YES
    OpenSSL (for raop-sink)                 : NO
    lilv (for lv2 plugins)                  : NO
    RLIMITs                                 : with limits.d file affecting matching PAM users
    PAM defaults                            : without limits.d file affecting all PAM users (not needed with modern systemd or kernel)
    Manpage generation                      : NO

  Misc dependencies
    dbus (Bluetooth, rt, portal, pw-reserve): YES
    SDL2 (video examples)                   : NO
    opus (Bluetooth, RTP)                   : YES
    readline (for pw-cli)                   : NO
    X11 (x11-bell)                          : NO
    libcanberra (x11-bell)                  : NO
    GLib-2.0 (Flatpak support)              : NO
    GIO (GSettings)                         : NO
    WebRTC Echo Canceling                   : YES

  pw-cat/pw-play/pw-dump/filter-chain
    sndfile                                 : YES

  filter-chain
    libmysofa                               : NO

  Streaming between daemons
    libpulse                                : YES
    Avahi DNS-SD (Zeroconf)                 : NO
    ROC                                     : NO

  Backend
    libusb (Bluetooth quirks)               : NO
    gstreamer-device-provider               : YES
    ALSA                                    : YES
    Bluetooth audio                         : YES
    JACK2                                   : NO
    libcamera                               : NO
    Compress-Offload                        : YES
    Udev                                    : YES
    V4L2 kernel header                      : YES
    V4L2 enabled                            : YES

  GStreamer modules
    glib-2.0                                : YES
    gobject-2.0                             : YES
    gmodule-2.0                             : YES
    gio-2.0                                 : YES
    gio-unix-2.0                            : YES
    gstreamer-1.0                           : YES
    gstreamer-plugins-base-1.0              : YES
    gstreamer-video-1.0                     : YES
    gstreamer-audio-1.0                     : YES
    gstreamer-allocators-1.0                : YES

  Bluetooth audio codecs
    SBC                                     : YES
    LDAC                                    : YES
    LDAC ABR                                : YES
    aptX                                    : YES
    AAC                                     : YES
    LC3plus                                 : NO
    Opus                                    : YES
    LC3                                     : NO

  Optional programs
    find (for header testing)               : YES

  Session managers
    Build media-session                     : NO
    Build wireplumber                       : YES
    Default session-manager                 : wireplumber

  pw-cat/pw-play/pw-dump tool
    Build pw-cat tool                       : YES
    Build pw-cat with FFmpeg integration    : NO

  Optional Modules
    jack-tunnel                             : NO
    rt                                      : with RTKit
    portal                                  : YES
    pulse-tunnel                            : YES
    zeroconf-discover                       : NO
    raop-discover (needs Avahi)             : NO
    raop-sink (requires OpenSSL)            : NO
    roc-sink                                : NO
    roc-source                              : NO
    x11-bell                                : NO
    avb                                     : YES

  Subprojects
    lua                                     : YES
    wireplumber                             : YES

  User defined options
    bluez5-backend-hfp-native               : disabled
    bluez5-backend-hsp-native               : disabled
    examples                                : disabled
    flatpak                                 : disabled
    gsettings                               : disabled
    libcanberra                             : disabled
    man                                     : disabled
    sdl2                                    : disabled
    tests                                   : disabled
    x11                                     : disabled

```

### Copy config
```
cp /usr/local/share/pipewire/pipewire.conf ./.config/pipewire/pipewire.conf (and also anothere config, check out the folder)
```

### Linking lib
```
sudo ln -s /usr/local/lib/arm-linux-gnueabihf/pipewire-0.3 /usr/lib/arm-linux-gnueabihf/pipewire-0.3
```

```
systemctl --user enable --now pipewire.service \
                      pipewire.socket \
                      pipewire-pulse.service \
                      pipewire-pulse.socket \
                      wireplumbere.service
```

