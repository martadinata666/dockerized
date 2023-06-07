FROM 192.168.0.2:5050/dedyms/debian:dev as musl
#COPY x86_64-linux-musl-cross.tgz aarch64-linux-musl-cross.tgz $HOME && \
#    sudo tar zxf ./x86_64-linux-musl-cross.tgz -C /opt && \
#    sudo tar zxf ./aarch64-linux-musl-cross.tgz -C /opt && \
#    rm ./x86_64-linux-musl-cross.tgz && \
#    rm ./aarch64-linux-musl-cross.tgz

### Add musl-gcc aarch64 and x86_64
## musl.cc love to low bandwith, manually download musl add to repo, self host the musl
RUN wget --progress=dot:mega -t 10-c http://192.168.0.2:25000/musl/x86_64-linux-musl-cross.tar.gz && \
    sudo tar zxf ./x86_64-linux-musl-cross.tar.gz -C /opt && \
    wget --progress=dot:mega -t 10 -c http://192.168.0.2:25000/musl/aarch64-linux-musl-cross.tar.gz && \
    sudo tar zxf ./aarch64-linux-musl-cross.tar.gz -C /opt && \
    wget --progress=dot:mage -t 10 -c http://192.168.0.2:25000/musl/armv7l-linux-musleabihf-cross.tar.gz && \
    sudo tar zxf ./armv7l-linux-musleabihf-cross.tar.gz -C /opt && \
    rm ./x86_64-linux-musl-cross.tar.gz && \
    rm ./aarch64-linux-musl-cross.tar.gz && \
    rm ./armv7l-linux-musleabihf-cross.tar.gz && \
    ls -al /opt

FROM 192.168.0.2:5050/dedyms/debian:latest
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse \
    CARGO_NET_GIT_FETCH_WITH_CLI=true \
    RUSTUP_HOME=$HOME/rustup \
    CARGO_HOME=$HOME/cargo \
    CARGO_INCREMENTAL=true \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER="x86_64-linux-gnu-gcc" \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER="x86_64-linux-musl-gcc" \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER="aarch64-linux-gnu-gcc" \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER="aarch64-linux-musl-gcc" \
    CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER="arm-linux-gnueabihf-gcc" \
    CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER="armv7l-linux-musleabihf-gcc" \
    CC_armv7_unknown_linux_musleabihf="armv7l-linux-musleabihf-gcc" \
    CC_x86_64_unknown_linux_musl="x86_64-linux-musl-gcc" \
    CC_aarch64_unknown_linux_musl="aarch64-linux-musl-gcc" \
    PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true \
    OPENSSL_STATIC=true \
    PATH="/opt/armv7l-linux-musleabihf-cross/:/opt/armv7l-linux-musleabihf-cross/bin/:/opt/aarch64-linux-musl-cross/:/opt/aarch64-linux-musl-cross/bin/:/opt/x86_64-linux-musl-cross/:/opt/x86_64-linux-musl-cross/bin/:$HOME/cargo/bin/:$PATH" \
    RUSTUP_VERSION=1.26.0 \
    RUST_VERSION=1.70.0

# Set openssl envenv per arch split to minimize confusion
ENV X86_64_UNKNOWN_LINUX_GNU_OPENSSL_DIR=/opt/lib/openssl-static-gnu \
    X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/opt/lib/openssl-static-gnu/include \
    X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/opt/lib/openssl-static-gnu/lib64 \
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_DIR=/opt/lib/openssl-static-musl \
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_INCLUDE_DIR=/opt/lib/openssl-static-musl/include \
    X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_LIB_DIR=/opt/lib/openssl-static-musl/lib64

ENV AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_DIR=/opt/lib/openssl-static-aarch64-gnu \
    AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/opt/lib/openssl-static-aarch64-gnu/include \
    AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/opt/lib/openssl-static-aarch64-gnu/lib \
    AARCH64_UNKNOWN_LINUX_MUSL_OPENSSL_DIR=/opt/lib/openssl-static-aarch64-musl \
    AARCH64_UNKNOWN_LINUX_MUSL_OPENSSL_LIB_DIR=/opt/lib/openssl-static-aarch64-musl/lib \
    AARCH64_UNKNOWN_LINUX_MUSL_OPENSSL_INCLUDE_DIR=/opt/lib/openssl-static-aarch64-musl/include

ENV ARMV7_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_DIR=/opt/lib/openssl-static-arm-gnueabihf \
    ARMV7_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_INCLUDE_DIR=/opt/lib/openssl-static-arm-gnueabihf/include \
    ARMV7_UNKNOWN_LINUX_GNUEABIHF_OPENSSL_LIB_DIR=/opt/lib/openssl-static-arm-gnueabihf/lib \
    ARMV7_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_DIR=/opt/lib/openssl-static-arm-musleabihf \
    ARMV7_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_LIB_DIR=/opt/lib/openssl-static-arm-musleabihf/lib \
    ARMV7_UNKNOWN_LINUX_MUSLEABIHF_OPENSSL_INCLUDE_DIR=/opt/lib/openssl-static-arm-musleabihf/include

RUN set -eux; \
    sudo apt-get update; \
    sudo apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        ; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu' ;; \
        i386) rustArch='i686-unknown-linux-gnu' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${rustArch}/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    sudo apt-get remove -y --auto-remove \
        wget \
        ; \
    sudo rm -rf /var/lib/apt/lists/*;

# Install build deps and add sccache 
ARG SCCACHE_VERSION=v0.5.1
ARG SCCACHE_FILE=sccache-$SCCACHE_VERSION-x86_64-unknown-linux-musl
ARG SCCACHE_URL=https://github.com/mozilla/sccache/releases/download
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends curl git wget pkg-config curl tar jq gcc g++ && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/* && \
    curl -L $SCCACHE_URL/$SCCACHE_VERSION/$SCCACHE_FILE.tar.gz | tar xz && \
    sudo mv $SCCACHE_FILE/sccache /usr/local/bin/sccache && \
    sudo chmod +x /usr/local/bin/sccache

### Arm64 deps
RUN sudo dpkg --add-architecture arm64 && \
    sudo apt update && \
    sudo apt install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libc6-arm64-cross libc6-dev-arm64-cross && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*

### armhf deps
RUN sudo dpkg --add-architecture armhf && \
    sudo apt update && \
    sudo apt install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libc6-armhf-cross libc6-dev-armhf-cross && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*

## Add musl target collections
RUN rustup target add x86_64-unknown-linux-musl && \
    rustup target add aarch64-unknown-linux-gnu && \
    rustup target add aarch64-unknown-linux-musl && \
    rustup target add armv7-unknown-linux-gnueabihf && \
    rustup target add armv7-unknown-linux-musleabihf

### Copy musl from
COPY --from=musl /opt /opt

### Build openssl GNU and MUSL
ARG SSL_VER="3.1.0"
ARG SSL_DIR=/opt/lib/openssl-static-gnu
ARG SSL_aarch64_DIR=/opt/lib/openssl-static-aarch64-gnu
ARG SSL_MUSL_DIR=/opt/lib/openssl-static-musl
ARG SSL_aarch64_MUSL_DIR=/opt/lib/openssl-static-aarch64-musl
ARG SSL_ARMHF_DIR=/opt/lib/openssl-static-arm-gnueabihf
ARG SSL_ARMHF_MUSL_DIR=/opt/lib/openssl-static-arm-musleabihf
# Build openssl (used in curl and pq)
# Would like to use zlib here, but can't seem to get it to work properly
# TODO: fix so that it works

# OPENSSL BUILD DEP
RUN sudo apt update && \
    sudo apt install -y make  && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://www.openssl.org/source/openssl-$SSL_VER.tar.gz | tar xz && \
    cd openssl-$SSL_VER && \
    ./Configure no-zlib no-shared -fPIC --prefix=$SSL_DIR --openssldir=$SSL_DIR/openssl linux-x86_64 && \
    env C_INCLUDE_PATH=$SSL_DIR/include make depend 2> /dev/null && \
    make -j$(nproc) && sudo make install_sw && cd ../ && rm -rf openssl-$SSL_VER

RUN curl -sSL https://www.openssl.org/source/openssl-$SSL_VER.tar.gz | tar xz && \
    cd openssl-$SSL_VER && \
    ./Configure no-zlib no-shared -fPIC --prefix=$SSL_aarch64_DIR --openssldir=$SSL_aarch64_DIR/openssl linux-aarch64 && \
    env C_INCLUDE_PATH=$SSL_aarch64_DIR/include make depend 2> /dev/null && \
    make CC=aarch64-linux-gnu-gcc -j$(nproc) && sudo make install_sw && cd ../ && rm -rf openssl-$SSL_VER

RUN curl -sSL https://www.openssl.org/source/openssl-$SSL_VER.tar.gz | tar xz && \
    cd openssl-$SSL_VER && \
    ./Configure no-zlib no-shared -fPIC --prefix=$SSL_MUSL_DIR --openssldir=$SSL_MUSL_DIR/openssl linux-x86_64 && \
    env C_INCLUDE_PATH=$SSL_MUSL_DIR/include make depend 2> /dev/null && \
    make CC=x86_64-linux-musl-gcc -j$(nproc) && sudo make install_sw && cd ../ && rm -rf openssl-$SSL_VER

RUN curl -sSL https://www.openssl.org/source/openssl-$SSL_VER.tar.gz | tar xz && \
    cd openssl-$SSL_VER && \
    ./Configure no-zlib no-shared -fPIC --prefix=$SSL_aarch64_MUSL_DIR --openssldir=$SSL_aarch64_MUSL_DIR/openssl linux-aarch64 && \
    env C_INCLUDE_PATH=$SSL_aarch64_MUSL_DIR/include make depend 2> /dev/null && \
    make CC=aarch64-linux-musl-gcc -j$(nproc) && sudo make install_sw && cd ../ && rm -rf openssl-$SSL_VER

RUN curl -sSL https://www.openssl.org/source/openssl-$SSL_VER.tar.gz | tar xz && \
    cd openssl-$SSL_VER && \
    ./Configure no-zlib no-shared -fPIC --prefix=$SSL_ARMHF_DIR --openssldir=$SSL_ARMHF_DIR/openssl linux-generic32 && \
    env C_INCLUDE_PATH=$SSL_ARMHF_DIR/include make depend 2> /dev/null && \
    make CC=arm-linux-gnueabihf-gcc -j$(nproc) && sudo make install_sw && cd ../ && rm -rf openssl-$SSL_VER

# https://github.com/openssl/openssl/issues/16551 -latomic for armv7l
RUN curl -sSL https://www.openssl.org/source/openssl-$SSL_VER.tar.gz | tar xz && \
    cd openssl-$SSL_VER && \
    ./Configure no-zlib no-shared -fPIC --prefix=$SSL_ARMHF_MUSL_DIR --openssldir=$SSL_ARMHF_MUSL_DIR/openssl linux-generic32 && \
    env C_INCLUDE_PATH=$SSL_ARMHF_MUSL_DIR/include make depend 2> /dev/null && \
    make CC=armv7l-linux-musleabihf-gcc CFLAGS=-latomic -j$(nproc) && sudo make install_sw && cd ../ && rm -rf openssl-$SSL_VER

## Install nodejs, follow lts path
#ARG KEYRING=/usr/share/keyrings/nodesource.gpg
#ARG VERSION=node_18.x
#ARG DISTRO=sid
#RUN sudo apt update && \
#    sudo apt install -y --no-install-recommends gpg && \
#    sudo curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null && \
#    echo 'Package: *\nPin: origin deb.nodesource.com\nPin-Priority: 1001' | sudo tee /etc/apt/preferences.d/nodejs && \
#    echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
#    sudo apt update && \
#    sudo apt install -y --no-install-recommends nodejs && \
#    sudo apt clean && \
#    sudo rm -rf /var/lib/apt/lists/* && \
#    sudo npm --cache /dev/shm install -g npm && \
#    sudo npm --cache /dev/shm install -g yarn && \
#    sudo npm --cache /dev/shm install -g pnpm && \
#    sudo rm -rf $HOME/.config && rm -rf $HOME/.npm

CMD ["bash"]
