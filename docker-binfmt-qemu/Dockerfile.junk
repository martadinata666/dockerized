FROM 192.168.0.2:5050/dedyms/debian:dev as builder
ARG QEMU_VERSION=8.0.0
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends ninja-build pkg-config libglib2.0-dev flex bison
RUN wget http://192.168.0.2:25000/qemu/qemu-${QEMU_VERSION}.tar.xz
#RUN wget https://download.qemu.org/qemu-$QEMU_VERSION.tar.xz && \
# aarch64-linux-user aarch64_be-linux-user arm-linux-user armeb-linux-user x86_64-linux-user
RUN tar xJf qemu-$QEMU_VERSION.tar.xz && \
    cd qemu-$QEMU_VERSION && \
    ./configure --prefix=/opt/qemu-user-static --static --disable-system --enable-linux-user --target-list=aarch64-linux-user,aarch64_be-linux-user,arm-linux-user,armeb-linux-user,x86_64-linux-user && \
    make -j$(nproc) && \
    sudo make install
WORKDIR /opt/qemu-user-static/bin
COPY embed.sh embed.sh
#RUN bash -c "for i in *; do cp $i $i-static; done"
USER root
RUN ./embed.sh && rm ./embed.sh-static
RUN ls -alR /opt/qemu-user-static
#ENTRYPOINT ["sh", "-c", "update-binfmts --enable && dpkg-reconfigure qemu-user-static"]

FROM 192.168.0.2:5050/dedyms/debian:latest
USER root
ENV PATH="/opt/qemu-user-static:/opt/qemu-user-static/bin:$PATH"
RUN apt update && \
    apt install -y binfmt-support && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /opt/qemu-user-static /opt/qemu-user-static
ENTRYPOINT ["bash", "-c", "update-binfmts --enable"]
