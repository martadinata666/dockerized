#syntax=docker/dockerfile:1.4
FROM debian:buster-slim
ARG USER=debian
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV DEBIAN_FRONTEND=noninteractive
ENV CONTAINERUSER=$USER
ENV TZ=Asia/Jakarta
ENV HOME=/home/$CONTAINERUSER
ENV PATH="/home/$CONTAINERUSER/.local/bin:/home/$CONTAINERUSER/.local/lib:/home/$CONTAINERUSER/.local/lib:$PATH"
COPY buster/sudo_lecture.txt /etc/sudo_lecture.txt
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends openssl sudo ca-certificates tzdata curl tini ncdu locales && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    echo "Defaults        lecture=always" >> /etc/sudoers && \
    echo "Defaults        lecture_file=/etc/sudo_lecture.txt" >> /etc/sudoers && \
    groupadd $USER && \
    groupadd -g 139 render && \
    useradd -u 1000 -g $USER -m -d /home/$USER -s /bin/bash -G video,render -p $(echo $USER | openssl passwd -1 -stdin) $USER && \
    adduser $USER sudo && \
    mkdir -p /home/$CONTAINERUSER/.local/bin && \
    mkdir -p /home/$CONTAINERUSER/.local/lib && \
    chown -R $CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/bin/bash"]
