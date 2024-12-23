FROM 192.168.0.2:5050/dedyms/debian:dev as tukang
#https://git.ffmpeg.org/gitweb/ffmpeg.git
ARG FFMPEG_VERSION=n7.1
ARG KEYRING=/usr/share/keyrings/debian-archive-keyring.gpg
RUN echo "deb [signed-by=$KEYRING] http://deb.debian.org/debian/ stable non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/non-free.list
#RUN echo "deb [signed-by=$KEYRING] http://deb.debian.org/debian/ stable non-free" | sudo tee /etc/apt/sources.list.d/non-free.list
RUN sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  git-lfs \
  libass-dev \
  libfreetype-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libtool \
  libvorbis-dev \
  libwebp-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  nasm \
  libx264-dev \
  libx265-dev \
  libnuma-dev \
  libvpx-dev \
  libopus-dev \
  libdav1d-dev \
  libunistring-dev \
  libaom-dev \
  libsvtav1enc-dev \
  libva-dev \
  ocl-icd-opencl-dev \
  libdrm-dev \
  libxml2-dev \
  libpciaccess-dev \
  libsrt-gnutls-dev \
  libvpl-dev \
  libfdk-aac-dev \
  libvpl2
RUN git clone --depth=1 -b $FFMPEG_VERSION https://git.ffmpeg.org/ffmpeg.git ffmpeg

WORKDIR $HOME/ffmpeg
RUN PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig ./configure \
  --pkg-config-flags=--static \
  --extra-version=vaapi \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --bindir="/usr/local/bin" \
  --enable-static \
  --disable-asm \
  --disable-debug \
  --disable-doc \
  --disable-ffplay \
  --enable-vaapi \
  --enable-opencl \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libsvtav1 \
  --enable-libdav1d \
  --enable-libvorbis \
  --enable-libwebp \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvpl \
  --enable-libsrt \
  --disable-sdl2 \
  --disable-libxcb \
  --disable-xlib \
  --enable-iconv \
  --enable-libfdk-aac \
  --enable-nonfree
RUN make -j$(nproc) && \
    sudo make install
RUN ffmpeg -version && \
    ffmpeg -hide_banner -hwaccels

FROM 192.168.0.2:5050/dedyms/debian:latest
ARG KEYRING=/usr/share/keyrings/debian-archive-keyring.gpg
#RUN echo "deb [signed-by=$KEYRING] http://deb.debian.org/debian/ unstable non-free" | sudo tee /etc/apt/sources.list.d/non-free.list
RUN echo "deb [signed-by=$KEYRING] http://deb.debian.org/debian/ stable non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/non-free.list
#ARG IGC_VERSION=1.0.14828.8
# Higher version need higher libc6(2.38 vs 2.36),bookworm on slower side
ARG NEO_VERSION=24.39.31294.12
#ARG LEVEL_ZERO_VERSION=1.3.26918.9
#RUN echo '/opt/intel/mediasdk/lib' | sudo tee /etc/ld.so.conf.d/imsdk.conf && \
RUN  sudo apt update && sudo apt install -y --no-install-recommends \
  wget \
  ocl-icd-libopencl1 \
  libass9 \
  libfreetype6 \
  libgnutls30 \
  libmp3lame0 \
  libvorbis0a \
  libvorbisenc2 \
  libvorbisfile3 \
  zlib1g \
  libx264-164 \
  libx265-199 \
  libnuma1 \
  libvpx7 \
  libopus0 \
  libdav1d6 \
  libunistring2 \
  libwebp7 \
  libwebpmux3 \
  libwebpdemux2 \
  libaom3 \
  libsvtav1enc1 \
  libva-drm2 \
  mesa-va-drivers \
  libva-x11-2 \
  libpciaccess0 \
  libsrt1.5-gnutls \
  intel-media-va-driver-non-free \
  vainfo \
  libfdk-aac2 \
  libmfx1 \
  libvpl2 && \
  sudo apt remove -y --purge *-dev && \
  sudo apt clean && \
  sudo rm -rf /var/lib/apt/lists/*
RUN     mkdir intel-compute-runtime && \
        cd intel-compute-runtime && \
        wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17791.9/intel-igc-core_1.0.17791.9_amd64.deb && \
        wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17791.9/intel-igc-opencl_1.0.17791.9_amd64.deb && \
        wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-level-zero-gpu-dbgsym_1.6.31294.12_amd64.ddeb && \
        wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-level-zero-gpu_1.6.31294.12_amd64.deb && \
        wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-opencl-icd-dbgsym_24.39.31294.12_amd64.ddeb && \
        wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-opencl-icd_24.39.31294.12_amd64.deb && \
        wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/libigdgmm12_22.5.2_amd64.deb && \
        sudo dpkg -i *.deb && \
        cd .. && \
        rm -rf intel-compute-runtime
COPY --from=tukang /usr/local/bin /usr/local/bin
RUN ffmpeg -version && \
    ffmpeg -hide_banner -hwaccels



###################################

#RUN git clone --depth=1 https://github.com/Intel-Media-SDK/MediaSDK msdk
#WORKDIR $HOME/msdk
#RUN mkdir build/ && \
#    cd build && \
#    cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_WAYLAND=OFF -DENABLE_X11_DRI3=OFF -DENABLE_OPENCL=ON  -DBUILD_SAMPLES=OFF -DBUILD_TUTORIALS=OFF && \
#    make -j$(nproc) && \
#    sudo make install && \
#    echo '/opt/intel/mediasdk/lib' | sudo tee /etc/ld.so.conf.d/imsdk.conf

#RUN git clone --depth=1 https://github.com/oneapi-src/oneVPL.git vpl
#WORKDIR $HOME/vpl
#RUN mkdir build/ && \
#    cd build && \
#    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/lib/vpl && \
#    cmake --build . --config Release && \
#    sudo cmake --build . --config Release --target install
##################################
