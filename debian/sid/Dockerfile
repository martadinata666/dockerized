FROM debian:sid-20230522-slim
ARG USER=debian
ARG UID=1000
ARG GID=1000
ARG SUDOERS="$USER       ALL=(ALL) NOPASSWD:ALL"
ENV CONTAINERUSER=$USER \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Jakarta \
    HOME=/home/$USER
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
    groupadd --gid $GID $USER && \
    useradd --system --create-home --shell /usr/sbin/nologin --uid $UID --gid $GID $USER && \
    gpasswd -a $USER sudo && \
    mkdir -p $HOME/.local/bin && \
    mkdir -p $HOME/.local/lib && \
    chown -R $CONTAINERUSER:$CONTAINERUSER $HOME

ENV PATH="/home/$CONTAINERUSER/.local/bin:/home/$CONTAINERUSER/.local/lib:/home/$CONTAINERUSER/.local/lib:$PATH"
WORKDIR $HOME
USER $CONTAINERUSER
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/bin/bash"]

# With password
# useradd -u 1000 -U -d /home/$USER -s /bin/bash -p $(echo $USER | openssl passwd -1 -stdin) $USER -m -d /home/$USER && \
# locales   sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
#    locale-gen && \