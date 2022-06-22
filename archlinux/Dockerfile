
FROM archlinux:latest
ENV CONTAINERUSER=arch
ENV HOME=/home/$CONTAINERUSER
RUN pacman -Syu --noconfirm openssh sudo nano tzdata && rm -rf /var/cache/pacman/pkg/* && rm -rf /var/lib/pacman/sync/*
RUN echo "Defaults        lecture=always" >> /etc/sudoers && \
    echo "Defaults        lecture_file=/etc/sudo_lecture.txt" >> /etc/sudoers && \
    echo "%wheel	ALL=(ALL) ALL" >> /etc/sudoers
COPY sudo_lecture.txt /etc/sudo_lecture.txt
RUN groupadd $CONTAINERUSER
RUN useradd -u 1000 -g $CONTAINERUSER -m -d /home/$CONTAINERUSER -s /bin/bash -p $(echo $CONTAINERUSER | openssl passwd -1 -stdin) $CONTAINERUSER
RUN gpasswd -a $CONTAINERUSER wheel
WORKDIR $HOME
