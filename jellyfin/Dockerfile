#ARG DOTNET_VERSION=6.0
#FROM 192.168.0.2:5050/dedyms/jellyfin:dev-web as web-builder
#ARG JELLYFIN_WEB_VERSION=master
#RUN curl -L https://github.com/jellyfin/jellyfin-web/archive/${JELLYFIN_WEB_VERSION}.tar.gz | tar zxf - \
# && cd jellyfin-web-* \
# && npm ci --no-audit --unsafe-perm \
# && mv dist /dist

#FROM 192.168.0.2:5050/dedyms/jellyfin:dev-dotnet as builder
#FROM 192.168.0.2:5050/dedyms/mono:latest as builder
#RUN apt update && apt install -y --no-install-recommends git
#RUN git clone --depth=1 https://github.com/jellyfin/jellyfin.git /repo
#WORKDIR /repo
# Opt out dotnet telemetry
#ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
# because of changes in docker and systemd we need to not build in parallel at the moment
# see https://success.docker.com/article/how-to-reserve-resource-temporarily-unavailable-errors-due-to-tasksmax-setting
#RUN dotnet publish Jellyfin.Server --disable-parallel --configuration Release --output="/jellyfin" --self-contained --runtime linux-x64 "-p:DebugSymbols=false;DebugType=none"



FROM 192.168.0.2:5050/dedyms/ffmpeg:6 as app
# https://askubuntu.com/questions/972516/debian-frontend-environment-variable
ARG DEBIAN_FRONTEND="noninteractive"
# http://stackoverflow.com/questions/48162574/ddg#49462622
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
# https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(Native-GPU-Support)
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"
RUN sudo mkdir -p /cache /config /config/transcodes \
    && sudo chown -R $CONTAINERUSER:$CONTAINERUSER /cache /config

#ENV HEALTHCHECK_URL=http://localhost:8096/health
# Needed for special character
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

COPY --chown=$CONTAIENRUSER:$CONTAINERUSER jellyfin /jellyfin
COPY --chown=$CONTAINERUSER:$CONTAINERUSER jellyfin-web/dist /jellyfin/jellyfin-web

EXPOSE 8096
USER $CONTAINERUSER
VOLUME /cache /config /config/transcodes
CMD ["/jellyfin/jellyfin", \
    "--datadir", "/config", \
    "--cachedir", "/cache", \
    "--ffmpeg", "/usr/local/bin/ffmpeg"]
#HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 \
#     CMD curl -Lk -fsS "${HEALTHCHECK_URL}" || exit 1
