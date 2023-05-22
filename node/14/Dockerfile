FROM 192.168.0.2:5050/dedyms/debian:latest
ARG KEYRING=/usr/share/keyrings/nodesource.gpg
ARG VERSION=node_14.x
ARG DISTRO=sid
RUN apt update && \
    apt install -y --no-install-recommends gpg && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee "$KEYRING" >/dev/null && \
    echo 'Package: *\nPin: origin deb.nodesource.com\nPin-Priority: 1001' | tee /etc/apt/preferences.d/nodejs && \
    echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt update && apt install -y --no-install-recommends nodejs && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g npm && \
    npm install -g yarn && \
    npm install -g pnpm && \
    ln -s /usr/bin/eatmydata /usr/local/bin/node && \
    rm -rf $HOME/.config
CMD ["bash"]
