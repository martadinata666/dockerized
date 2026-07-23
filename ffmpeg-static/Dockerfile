FROM 192.168.0.2:6060/dedyms/debian:latest as tukang
ENV ARCH=""
ARG DATE
ARG VERSION
ARG TARGETARCH
ARG BUILDPLATFORM
RUN echo "i am running on $BUILDPLATFORM, building for $TARGETARCH"
ENV FFMPEG_BUILD_DATE=$DATE
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends wget xz-utils aria2
USER $CONTAINERUSER
WORKDIR $HOME
# https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
RUN aria2c -x 16 -s 100 -j 100 -c http://192.168.0.2:25000/ffmpeg/ffmpeg-release-$TARGETARCH-static.tar.xz && \
    tar -xf ffmpeg-release-$TARGETARCH-static.tar.xz && \
    tree
RUN sudo mv ffmpeg-*-static/ffmpeg /usr/local/bin/ffmpeg && \
    sudo mv ffmpeg-*-static/ffprobe /usr/local/bin/ffprobe

FROM scratch
ARG VERSION
ENV FFMPEG_VERSION=$VERSION
COPY --from=tukang /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=tukang /usr/local/bin/ffprobe /usr/local/bin/ffprobe
