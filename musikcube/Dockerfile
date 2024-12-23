FROM 192.168.0.2:5050/dedyms/debian:dev as fetcher
ARG VERSION=3.0.4
RUN curl -L https://github.com/clangen/musikcube/releases/download/$VERSION/musikcube_${VERSION}_linux_x86_64.tar.bz2 -o musikcube.tar.bz2 && \
    tar -xvf musikcube.tar.bz2 && \
    mv musikcube_${VERSION}_linux_x86_64 musikcube


FROM 192.168.0.2:5050/dedyms/ffmpeg:6
COPY --from=fetcher $HOME/musikcube /usr/local/bin/musikcube
RUN sudo apt update && \
    sudo apt install --no-install-recommends -y libpulse0
CMD ["/usr/local/bin/musikcube/musikcubed","--foreground"]
