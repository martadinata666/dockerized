

FROM 192.168.0.2:5050/dedyms/debian:latest
ENV ARCH=""
ARG DATE
ARG TARGETARCH
ARG BUILDPLATFORM
RUN echo "i am running on $BUILDPLATFORM, building for $TARGETARCH"
ENV FFMPEG_BUILD_DATE=$DATE
RUN apt update && apt install -y --no-install-recommends wget xz-utils && apt clean && rm -rf /var/lib/apt/lists*
USER $CONTAINERUSER
WORKDIR /home/$CONTAINERUSER
RUN wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-$TARGETARCH-static.tar.xz && \
    tar -xf ffmpeg-git-$TARGETARCH-static.tar.xz && \
    ls -alh && \
    mv ffmpeg-git-$DATE-$TARGETARCH-static/ffmpeg .local/bin/ && \
    mv ffmpeg-git-$DATE-$TARGETARCH-static/ffprobe .local/bin/ && \
    rm -rf ffmpeg-git-$DATE-$TARGETARCH-static
