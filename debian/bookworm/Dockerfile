FROM debian:12.4
ENV CONTAINERUSER=docker \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Jakarta \
    HOME=/home/docker \
    PATH="/home/docker/.local/bin:/home/docker/.local/lib:$PATH"

ARG UID=1000
ARG GID=1000
ARG SUDOERS="$CONTAINERUSER       ALL=(ALL) NOPASSWD:ALL"

COPY sudo_lecture.txt /etc/sudo_lecture.txt
RUN apt update && \
    apt install -y --no-install-recommends eatmydata sudo ca-certificates tzdata curl tini ncdu nano htop locales && \
    ln -s /usr/bin/eatmydata /usr/local/bin/apt && \
    ln -s /usr/bin/eatmydata /usr/local/bin/apt-get && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    echo "Defaults        lecture=always" >> /etc/sudoers && \
    echo "Defaults        lecture_file=/etc/sudo_lecture.txt" >> /etc/sudoers && \
    echo $SUDOERS >> /etc/sudoers && \  
    groupadd --gid $GID $CONTAINERUSER && \
    useradd --system --create-home --shell /usr/sbin/nologin --uid $UID --gid $GID $CONTAINERUSER && \
    gpasswd -a $CONTAINERUSER sudo && \
    mkdir -p $HOME/.local/bin && \
    mkdir -p $HOME/.local/lib && \
    chown -R $CONTAINERUSER:$CONTAINERUSER $HOME

WORKDIR $HOME
USER $CONTAINERUSER
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/bin/bash"]

# With password
# useradd -u 1000 -U -d /home/$CONTAINERUSER -s /bin/bash -p $(echo $CONTAINERUSER | openssl passwd -1 -stdin) $CONTAINERUSER -m -d /home/$CONTAINERUSER && \
# locales   sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
#    locale-gen && \