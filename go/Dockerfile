FROM 192.168.0.2:5050/dedyms/debian:latest
ARG TARGETARCH
ENV GO_VERSION=1.20.2
ENV PATH="/usr/local/go/bin:$PATH"
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends \
                tar \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
                unzip
RUN curl -L https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz -o go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && \
    rm go${GO_VERSION}.linux-${TARGETARCH}.tar.gz