FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends binfmt-support qemu-user-static && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*
USER root
ENTRYPOINT ["sh", "-c", "update-binfmts --enable && dpkg-reconfigure qemu-user-static"]
