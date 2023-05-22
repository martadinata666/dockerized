# Build Pulseaudio for Pi Bullseye

#### Notice $ and # , to know with privileges on.

### Clone repository
#### As current stable v16.1 change pulse-version `v16.1`

```$ git clone --depht=1 -b pulse-version https://github.com/pulseaudio/pulseaudio.git```

### Install build dependencies, here depedencies for headless. On GUI system may different.
```
# apt install --no-install-recommends build-essential libsndfile1-dev libspeexdsp-dev libtool libglib2.0-dev libjson-c-dev gettext libtdb-dev \
  libbluetooth-dev libsbc-dev ninja libdbus-1-dev meson libsoxr-dev libwebrtc-audio-processing-dev \
  check libcap-dev libudev-dev libsamplerate0-dev libwrap0-dev xmltoman libasound2-dev libgstreamermm-1.0-dev \
  libice-dev libsm-dev libxtst-dev libsystemd-dev libltdl-dev libopenaptx-dev libfreeaptx-dev libldacbt-abr-dev libldacbt-enc-dev \
  gstreamer1.0-alsa gstreamer1.0-x doxygen
```

### Run meson command
```
$ cd pulseaudio
$ meson setup build
```

#### Meson will generate pulseaudio compile configuration based on installed `-dev` packages, with packages above the configuration shown below
```
pi@PiAudio pulseaudio % meson build                                
The Meson build system
Version: 1.0.0
Source dir: /home/pi/Documents/pulseaudio
Build dir: /home/pi/Documents/pulseaudio/build
Build type: native build
Program git-version-gen found: YES (/home/pi/Documents/pulseaudio/git-version-gen)
WARNING: You should add the boolean check kwarg to the run_command call.
         It currently defaults to false,
         but it will default to true in future releases of meson.
         See also: https://github.com/mesonbuild/meson/issues/9300
Project name: pulseaudio
Project version: 16.1
C compiler for the host machine: cc (gcc 12.2.0 "cc (Debian 12.2.0-14) 12.2.0")
C linker for the host machine: cc ld.bfd 2.40
C++ compiler for the host machine: c++ (gcc 12.2.0 "c++ (Debian 12.2.0-14) 12.2.0")
C++ linker for the host machine: c++ ld.bfd 2.40
Host machine cpu family: arm
Host machine cpu: arm
Found pkg-config: /usr/bin/pkg-config (1.8.1)
Run-time dependency bash-completion found: YES 2.11
Checking for type "_Bool" : YES 
Checking for size of "void *" : 4
Has header "arpa/inet.h" : YES 
Has header "byteswap.h" : YES 
Has header "dlfcn.h" : YES 
Has header "execinfo.h" : YES 
Has header "grp.h" : YES 
Has header "langinfo.h" : YES 
Has header "linux/sockios.h" : YES 
Has header "locale.h" : YES 
Has header "netdb.h" : YES 
Has header "netinet/in.h" : YES 
Has header "netinet/in_systm.h" : YES 
Has header "netinet/ip.h" : YES 
Has header "netinet/tcp.h" : YES 
Has header "pcreposix.h" : NO 
Has header "poll.h" : YES 
Has header "pwd.h" : YES 
Has header "regex.h" : YES 
Has header "sched.h" : YES 
Has header "stdint.h" : YES 
Has header "sys/atomic.h" : NO 
Has header "sys/capability.h" : YES 
Has header "sys/conf.h" : NO 
Has header "sys/dl.h" : NO 
Has header "sys/eventfd.h" : YES 
Has header "sys/filio.h" : NO 
Has header "sys/ioctl.h" : YES 
Has header "sys/mman.h" : YES 
Has header "sys/prctl.h" : YES 
Has header "sys/resource.h" : YES 
Has header "sys/select.h" : YES 
Has header "sys/socket.h" : YES 
Has header "sys/syscall.h" : YES 
Has header "sys/uio.h" : YES 
Has header "sys/un.h" : YES 
Has header "sys/wait.h" : YES 
Has header "syslog.h" : YES 
Has header "xlocale.h" : NO 
Has header "valgrind/memcheck.h" : NO 
Has header "pthread.h" : YES 
Header "pthread.h" has symbol "PTHREAD_PRIO_INHERIT" : YES 
Check usable header "cpuid.h" : NO 
Checking for function "accept4" : YES 
Checking for function "clock_gettime" : YES 
Checking for function "ctime_r" : YES 
Checking for function "fchmod" : YES 
Checking for function "fchown" : YES 
Checking for function "fork" : YES 
Checking for function "fstat" : YES 
Checking for function "getaddrinfo" : YES 
Checking for function "getgrgid_r" : YES 
Checking for function "getgrnam_r" : YES 
Checking for function "getpwnam_r" : YES 
Checking for function "getpwuid_r" : YES 
Checking for function "gettimeofday" : YES 
Checking for function "getuid" : YES 
Checking for function "lrintf" : YES 
Checking for function "lstat" : YES 
Checking for function "memfd_create" : YES 
Checking for function "mkfifo" : YES 
Checking for function "mlock" : YES 
Checking for function "nanosleep" : YES 
Checking for function "open64" : YES 
Checking for function "paccept" : NO 
Checking for function "pipe" : YES 
Checking for function "pipe2" : YES 
Checking for function "posix_fadvise" : YES 
Checking for function "posix_madvise" : YES 
Checking for function "posix_memalign" : YES 
Checking for function "ppoll" : YES 
Checking for function "readlink" : YES 
Checking for function "setegid" : YES 
Checking for function "seteuid" : YES 
Checking for function "setpgid" : YES 
Checking for function "setregid" : YES 
Checking for function "setresgid" : YES 
Checking for function "setresuid" : YES 
Checking for function "setreuid" : YES 
Checking for function "setsid" : YES 
Checking for function "sig2str" : NO 
Checking for function "sigaction" : YES 
Checking for function "strerror_r" : YES 
Checking for function "strtod_l" : YES 
Checking for function "strtof" : YES 
Checking for function "symlink" : YES 
Checking for function "sysconf" : YES 
Checking for function "uname" : YES 
Header "sys/syscall.h" has symbol "SYS_memfd_create" : YES 
Checking for function "dgettext" : YES 
Header "signal.h" has symbol "SIGXCPU" : YES 
Header "netinet/in.h" has symbol "INADDR_NONE" : YES 
Header "unistd.h" has symbol "environ" : YES 
Header "sys/soundcard.h" has symbol "SOUND_PCM_READ_RATE" : YES 
Header "sys/soundcard.h" has symbol "SOUND_PCM_READ_CHANNELS" : YES 
Header "sys/soundcard.h" has symbol "SOUND_PCM_READ_BITS" : YES 
Library m found: YES
Run-time dependency threads found: YES
Checking for function "pthread_getname_np" with dependency threads: YES 
Checking for function "pthread_setaffinity_np" with dependency threads: YES 
Checking for function "pthread_setname_np" with dependency threads: YES 
Library cap found: YES
Library rt found: YES
Checking for function "shm_open" with dependency -lrt: YES 
Library dl found: YES
Checking for function "dladdr" with dependency -ldl: YES 
Checking for function "iconv_open" : YES 
Library execinfo found: NO
Run-time dependency dbus-1 found: YES 1.14.4
Run-time dependency glib-2.0 found: YES 2.74.5
Run-time dependency sndfile found: YES 1.2.0
Run-time dependency libsystemd found: YES 252
Run-time dependency x11-xcb found: YES 1.8.3
Has header "sys/soundcard.h" : YES 
Did not find CMake 'cmake'
Found CMake: NO
Run-time dependency fftw3f found: NO (tried pkgconfig and cmake)
Run-time dependency libasyncns found: NO (tried pkgconfig and cmake)
Run-time dependency gtk+-3.0 found: NO (tried pkgconfig and cmake)
Library ltdl found: YES
Run-time dependency tdb found: YES 1.4.7
Run-time dependency alsa found: YES 1.2.8
Run-time dependency gio-2.0 found: YES 2.74.5
Run-time dependency orc-0.4 found: YES 0.4.33
Program orcc found: YES (/usr/bin/orcc)
Dependency samplerate skipped: feature samplerate disabled
Run-time dependency speexdsp found: YES 1.2.1
Run-time dependency soxr found: YES 0.1.3
Run-time dependency webrtc-audio-processing found: YES 0.3
Run-time dependency systemd found: YES 252
Run-time dependency libelogind found: NO (tried pkgconfig and cmake)
Library wrap found: YES
Has header "tcpd.h" : YES 
Checking for function "hosts_access" with dependency -lwrap: YES 
Run-time dependency xcb found: YES 1.15
Run-time dependency ice found: YES 1.0.10
Run-time dependency sm found: YES 1.2.3
Run-time dependency xtst found: YES 1.2.3
Checking for function "XSetIOErrorExitHandler" with dependency x11-xcb: YES 
Run-time dependency avahi-client found: NO (tried pkgconfig and cmake)
Run-time dependency sbc found: YES 2.0
Run-time dependency bluez found: YES 5.66
Run-time dependency jack found: NO (tried pkgconfig and cmake)
Run-time dependency lirc found: NO (tried pkgconfig and cmake)
Run-time dependency openssl found: NO (tried pkgconfig, system and cmake)
Run-time dependency libudev found: YES 252
Run-time dependency gstreamer-1.0 found: YES 1.20.5
Run-time dependency gstreamer-app-1.0 found: YES 1.20.5
Run-time dependency gstreamer-rtp-1.0 found: YES 1.20.5
Dependency gstreamer-1.0 found: YES 1.20.5 (cached)
Dependency gstreamer-app-1.0 found: YES 1.20.5 (cached)
Run-time dependency check found: YES 0.15.2
Configuring doxygen.conf using configuration
Program msgfmt found: YES (/usr/bin/msgfmt)
Program msginit found: YES (/usr/bin/msginit)
Program msgmerge found: YES (/usr/bin/msgmerge)
Program xgettext found: YES (/usr/bin/xgettext)
Program perl found: YES (/usr/bin/perl)
Program xmllint found: NO
Configuring default.pa.5.xml using configuration
Configuring pacmd.1.xml using configuration
Configuring pasuspender.1.xml using configuration
Configuring pulse-cli-syntax.5.xml using configuration
Configuring pulse-daemon.conf.5.xml using configuration
Configuring pulseaudio.1.xml using configuration
Configuring start-pulseaudio-x11.1.xml using configuration
Configuring pacat.1.xml using configuration
man/meson.build:58: WARNING: The variable(s) 'DEFAULT_MONITOR', 'DEFAULT_SINK', 'DEFAULT_SOURCE' in the input file 'man/pacat.1.xml.in' are not present in the given configuration data.
Configuring pactl.1.xml using configuration
Configuring pulse-client.conf.5.xml using configuration
Configuring padsp.1.xml using configuration
Configuring pax11publish.1.xml using configuration
Configuring version.h using configuration
Configuring client.conf using configuration
src/pulsecore/meson.build:176: WARNING: Module SIMD has no backwards or forwards compatibility and might not exist in future releases.
Compiler supports mmx: NO
Compiler supports sse: NO
Checking if "neon code" compiles: YES 
Compiler supports neon: YES
Configuring start-pulseaudio-x11 using configuration
Configuring 00-pulseaudio-x11 using configuration
Program desktop-file-validate found: NO
Program m4 found: YES (/usr/bin/m4)
Configuring daemon.conf.tmp using configuration
Has header "sys/un.h" : YES (cached)
Checking for function "mkfifo" : YES (cached)
Configuring default.pa.tmp using configuration
Configuring system.pa.tmp using configuration
Configuring pulseaudio.service using configuration
Configuring pulseaudio-x11.service using configuration
Has header "linux/input.h" : YES 
Checking for function "mkfifo" : YES (cached)
Has header "sys/eventfd.h" : YES (cached)
Header "signal.h" has symbol "SIGXCPU" : YES (cached)
Checking for function "pthread_setaffinity_np" with dependency threads: YES (cached)
Program test-daemon.meson.sh found: YES (/bin/sh /home/pi/Documents/pulseaudio/src/tests/test-daemon.meson.sh)
Configuring padsp using configuration
Configuring config.h using configuration
Configuring libpulse.pc using configuration
Configuring libpulse-simple.pc using configuration
Configuring libpulse-mainloop-glib.pc using configuration
Program m4 found: YES (/usr/bin/m4)
Configuring PulseAudioConfig.cmake.tmp using configuration
Configuring PulseAudioConfigVersion.cmake using configuration
Message: 
    ---{ pulseaudio 16.1 }---
    
    prefix:                        /usr/local
    bindir:                        /usr/local/bin
    libdir:                        /usr/local/lib/arm-linux-gnueabihf
    libexecdir:                    /usr/local/libexec
    mandir:                        /usr/local/share/man
    datadir:                       /usr/local/share
    sysconfdir:                    /usr/local/etc
    localstatedir:                 /var/local
    modlibexecdir:                 /usr/local/lib/arm-linux-gnueabihf/pulseaudio/modules
    alsadatadir:                   /usr/local/share/pulseaudio/alsa-mixer
    System Runtime Path:           /var/local/run/pulse
    System State Path:             /var/local/lib/pulse
    System Config Path:            /var/local/lib/pulse
    Bash completions directory:    /usr/share/bash-completion/completions
    Zsh completions directory:     /usr/local/share/zsh/site-functions
    Compiler:                      gcc 12.2.0
    
    Enable pulseaudio daemon:      true
    Enable pulseaudio client:      true
    
    Enable memfd shared memory:    true
    Enable X11:                    true
    Enable D-Bus:                  true
    Enable GLib 2:                 true
    Enable systemd integration:    true
    Enable FFTW:                   false
    Enable IPv6:                   true
    Enable Gcov coverage:          false
    Enable Valgrind:               false
    Enable man pages:              true
    Enable unit tests:             true
    
    --- Pulseaudio client features ---
    
    Enable Gtk+ 3:                 false
    Enable Async DNS:              false
    Enable OSS Wrapper:            true
    
    --- Pulseaudio daemon features ---
    
    Safe X11 I/O errors:           true
    Enable Avahi:                  false
    Enable OSS Output:             true
    Enable Alsa:                   true
    Enable Jack:                   false
    Enable LIRC:                   false
    Enable GSettings:              true
    Enable BlueZ 5:              true
      Enable native headsets:    true
      Enable  ofono headsets:    true
      Enable GStreamer based codecs: true
    Enable GStreamer:              true
    Enable libsamplerate:          false
    Enable ORC:                    true
    Enable Adrian echo canceller:  true
    Enable Speex (resampler, AEC): true
    Enable SoXR (resampler):       true
    Enable WebRTC echo canceller:  true
    
    Enable udev:                   true
      Enable HAL->udev compat:     true
    Enable systemd units:          true
    Enable elogind:                false
    Enable TCP Wrappers:           true
    Enable OpenSSL (for Airtunes): false
    Database:                      tdb
    Legacy Database Entry Support: true
    module-stream-restore:
      Clear old devices:           false
    Running from build tree:       true
    System User:                   pulse
    System Group:                  pulse
    Access Group:                  pulse-access
Build targets in project: 233
NOTICE: Future-deprecated features used:
 * 0.56.0: {'dependency.get_pkgconfig_variable', 'meson.source_root', 'meson.build_root'}

Found ninja-1.11.1 at /usr/bin/ninja

```
### Run ninja build command
```
$ ninja -C build
```

### Installing new pulseaudio
```
$ cd build
# meson install --no-rebuild
```

### The pulseaudio will installed and override system installed pulseaudio, reboot system. Check running pulseaudio by run
```
# pactl info
```

#### Result
```
Server String: /run/user/1000/pulse/native
Library Protocol Version: 35
Server Protocol Version: 35
Is Local: yes
Client Index: 3
Tile Size: 65496
User Name: pi
Host Name: PiAudio
Server Name: pulseaudio
Server Version: 16.1
Default Sample Specification: s16le 2ch 44100Hz
Default Channel Map: front-left,front-right
Default Sink: alsa_output.usb-FiiO_K3-00.iec958-stereo
Default Source: alsa_output.usb-FiiO_K3-00.iec958-stereo.monitor
Cookie: 265e:39cc

```

### Override pulseaudio.service or Create new one at `/etc/systemd/system/pulseaudio.service`
```
#/etc/systemd/system/pulseaudio.service
# systemd service spec for pulseaudio running in system mode -- not recommended though!
# on arch, put it under /etc/systemd/system/pulseaudio.service
# start with: systemctl start pulseaudio.service
# enable on boot: systemctl enable pulseaudio.service 
[Unit]
Description=Pulseaudio sound server
After=avahi-daemon.service network.target

[Service]
ExecStart=/usr/local/bin/pulseaudio --disallow-exit
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=30
User=pi
WorkingDirectory=/home/pi


[Install]
WantedBy=multi-user.target

```

#### NB: I prefer wipe out system installed pulseaudio, just for preventing library clash.
