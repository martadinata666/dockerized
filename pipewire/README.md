remove any pipewire and pulseaudio from system

install deps look here https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/master/.gitlab-ci.yml and libfdk-aac-dev

clone source
git clone --depth=1 -b 0.3.67 https://gitlab.freedesktop.org/pipewire/pipewire.git pipewire0367
cd pipewire0367

### Building
meson setup builddir -Dsdl2=disabled -Dexamples=disabled -Dtests=disabled -Dman=disabled -Dlibcanberra=disabled -Dflatpak=disabled -Dgsettings=disabled -Dx11=disabled -Dbluez5-backend-hfp-native=disabled -Dbluez5-backend-hsp-native=disabled
meson compile -C builddir -j3
cd builddir
sudo meson install --no-rebuild


### copy config
cp /usr/local/share/pipewire/pipewire.conf ./.config/pipewire/pipewire.conf (and also anothere config, check out the folder)

### Linking lib
sudo ln -s /usr/local/lib/arm-linux-gnueabihf/pipewire-0.3 /usr/lib/arm-linux-gnueabihf/pipewire-0.3

systemctl --user enable --now pipewire.service \                           
                      pipewire.socket \
                      pipewire-pulse.service \
                      pipewire-pulse.socket \
                      wireplumbere.service
