#FROM golang:1.17.1-alpine AS builder
#RUN apk --no-cache add gcc musl-dev
FROM 192.168.0.2:5050/dedyms/cadvisor:dev AS tukang
RUN git clone --depth=1 -b v1.0.0 https://github.com/PremoWeb/chadburn.git ${GOPATH}/src/github.com/PremoWeb/Chadburn
WORKDIR ${GOPATH}/src/github.com/PremoWeb/Chadburn
#COPY . ${GOPATH}/src/github.com/PremoWeb/Chadburn
RUN go build -o /go/bin/chadburn .

FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --from=tukang /go/bin/chadburn /usr/bin/chadburn
ENTRYPOINT ["/usr/bin/chadburn"]
CMD ["daemon"]
