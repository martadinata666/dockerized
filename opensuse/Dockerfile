#syntax=docker/dockerfile:1.4
FROM opensuse/tumbleweed:latest
ARG USER=tumbleweed
ENV CONTAINERUSER=$USER
ENV HOME=/home/$CONTAINERUSER
ENV PATH="/home/$CONTAINERUSER/.local/bin:/home/$CONTAINERUSER/.local/lib/:$PATH"
ENV TZ=Asia/Jakarta
RUN zypper --non-interactive in sudo openssl timezone busybox-adduser && \
    zypper clean -a && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "Defaults        lecture=always" >> /etc/sudoers && \
    echo "Defaults        lecture_file=/etc/sudo_lecture.txt" >> /etc/sudoers && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    adduser -u 1000 -g $CONTAINERUSER -h /home/$CONTAINERUSER -s /bin/bash -D $USER && \
    addgroup wheel && \
    adduser $USER wheel
WORKDIR $HOME
COPY sudo_lecture.txt /etc/sudo_lecture.txt
CMD ["/bin/bash"]
