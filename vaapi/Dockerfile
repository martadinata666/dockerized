#FROM 192.168.0.2:5050/dedyms/debian:latest
FROM 192.168.0.2:5050/dedyms/ffmpeg:6.0
# https://github.com/intel/compute-runtime/releases, env to modified every release
ARG TARGETARCH
ARG DISTRO=bookworm
ARG GMMLIB_VERSION=22.3.0
ARG IGC_VERSION=1.0.12812.26
ARG NEO_VERSION=22.53.25242.13
ARG LEVEL_ZERO_VERSION=1.3.25242.13
ARG JELLYFIN_VERSION
#ARG TARGETARCH=amd64
ENV NEO_VERSION=$NEO_VERSION
ENV JELLYFIN_FFMPEG_VERSION=$JELLYFIN_VERSION

# Get Jellyfin-ffmpeg from GitHub and override to intel-media-va-driver-non-free
#RUN sudo apt update && \
#    sudo apt install -y --no-install-recommends wget && \
#    mkdir jellyfin && \
#    cd jellyfin && \
#    wget --progress=dot:mega https://github.com/martadinata666/jellyfin-ffmpeg/releases/download/v${JELLYFIN_VERSION}/jellyfin-ffmpeg5_${JELLYFIN_VERSION}-${DISTRO}_${TARGETARCH}.deb && \
#    sudo apt install -y ./jellyfin-ffmpeg5_${JELLYFIN_VERSION}-${DISTRO}_${TARGETARCH}.deb && \
#    sudo apt install -y --no-install-recommends mesa-va-drivers && \
#    sudo ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg && \
#    sudo ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe && \
#    cd .. && \
#    rm -rf jellyfin && \
#    sudo rm -rf /var/lib/apt/lists/* && \
#    sudo apt clean autoclean && \
#    sudo apt autoremove -y

# Intel VAAPI Tone mapping dependencies:
# Prefer NEO to Beignet since the latter one doesn't support Comet Lake or newer for now.
# Do not use the intel-opencl-icd package from repo since they will not build with RELEASE_WITH_REGKEYS enabled.
# libigdgmm12 from sid repo newer than repo wget --progress=dot:mega https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/libigdgmm12_${GMMLIB_VERSION}_amd64.deb && \
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        sudo apt remove --purge intel-opencl-icd && \
        sudo apt update && \
        sudo apt install -y --no-install-recommends wget ocl-icd-libopencl1 && \
        mkdir intel-compute-runtime && \
        cd intel-compute-runtime && \
        wget --progress=dot:mega https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-opencl-icd_${NEO_VERSION}_amd64.deb && \
        wget --progress=dot:mega https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-level-zero-gpu_${LEVEL_ZERO_VERSION}_amd64.deb && \
        wget --progress=dot:mega https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-core_${IGC_VERSION}_amd64.deb && \
        wget --progress=dot:mega https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-opencl_${IGC_VERSION}_amd64.deb && \
        sudo dpkg -i *.deb && \
        cd .. && \
        rm -rf intel-compute-runtime && \
        sudo apt clean autoclean -y && \
        sudo rm -rf /var/lib/apt/lists/* && \
        sudo apt autoremove -y; \
    fi;

# echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list && \
#RUN apt update && apt install --no-install-recommends -y ca-certificates gnupg wget apt-transport-https \
#    && wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add - \
#    && echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/debian bullseye main" | tee /etc/apt/sources.list.d/jellyfin.list \
#    && apt-get update \
#    && apt install --no-install-recommends --no-install-suggests -y mesa-va-drivers jellyfin-ffmpeg \
#    && apt-get remove gnupg apt-transport-https -y \
#    && apt-get clean autoclean -y \
#    && apt-get autoremove -y \
#    && rm -rf /var/lib/apt/lists/*
USER $CONTAINERUSER
CMD ["bash"]
