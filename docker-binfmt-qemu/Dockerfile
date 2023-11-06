FROM debian:bookworm-slim
RUN apt update && \
    apt install -y --no-install-recommends binfmt-support qemu-user-static && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["bash", "-c", "update-binfmts --enable && dpkg-reconfigure qemu-user-static"]
