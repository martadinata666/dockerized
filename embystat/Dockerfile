#syntax=docker/dockerfile:1.4
FROM 192.168.0.2:5050/dedyms/debian:latest
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV EMBYSTAT_LISTENURL=http://*
ENV EMBYSTAT_PORT=6555
ENV PATH="/opt/embystat/:$PATH"
RUN apt update && apt install -y --no-install-recommends libicu67 libssl1.1 && apt clean && rm -rf /var/lib/apt/lists/*

COPY --chown=$CONTAINERUSER:$CONTAINERUSER embystat /opt/embystat
WORKDIR /opt/embystat
VOLUME /app/data
EXPOSE 6555/tcp
CMD /opt/embystat/EmbyStat --enable-updates false --log-dir /home/debian/embystat/log --config-dir /home/debian/embystat --data-dir /home/debian/embystat
