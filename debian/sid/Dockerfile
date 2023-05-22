FROM debian:sid-slim
ARG USER=debian
ARG UID=1000
ARG GID=1000
ENV CONTAINERUSER=$USER
ARG SUDOERS="$USER       ALL=(ALL) NOPASSWD:ALL"
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta
ENV HOME=/home/$CONTAINERUSER
COPY sudo_lecture.txt /etc/sudo_lecture.txt
RUN apt update && \
    apt install -y --no-install-recommends eatmydata sudo ca-certificates tzdata curl tini ncdu nano && \
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