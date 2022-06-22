
FROM golang:1.17.3-alpine3.13 as builder
ARG RELEASE
RUN apk --no-cache add git alpine-sdk
#RUN git clone --depth=1 -b $RELEASE https://github.com/eko/pihole-exporter.git /pihole-exporter
RUN git clone --depth=1 https://github.com/eko/pihole-exporter.git /pihole-exporter
WORKDIR /pihole-exporter
RUN GO111MODULE=on go mod vendor
RUN CGO_ENABLED=0 GOOS=$OS GOARCH=$ARCH go build -ldflags '-s -w' -o binary ./

FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV PIHOLE_EXPORTER_RELEASE=$RELEASE
#ENV PIHOLE_HOSTNAME: localhost
#ENV PIHOLE_PORT: 80
#ENV PIHOLE_PASSWORD: CHANGE_ME
WORKDIR pihole
COPY --from=builder /pihole-exporter/binary $HOME/.local/bin/pihole-exporter
USER $CONTAINERUSER
CMD ["pihole-exporter"]