
FROM opensuse/tumbleweed:latest
ARG USER=tumbleweed
ENV CONTAINERUSER=$USER
ENV HOME=/home/$CONTAINERUSER
ENV PATH="/home/$CONTAINERUSER/.local/bin:/home/$CONTAINERUSER/.local/lib/:$PATH"
ENV TZ=Asia/Jakarta
RUN zypper --non-interactive in sudo openssl timezone && \
    zypper clean -a && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "Defaults        lecture=always" >> /etc/sudoers && \
    echo "Defaults        lecture_file=/etc/sudo_lecture.txt" >> /etc/sudoers && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -u 1000 -U -d /home/suse -s /bin/bash -p suse suse -m -d /home/suse && \
    addgroup wheel && \
    adduser $USER wheel
WORKDIR $HOME
COPY sudo_lecture.txt /etc/sudo_lecture.txt
CMD ["/bin/bash"]
