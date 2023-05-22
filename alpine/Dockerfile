
FROM alpine:edge
RUN echo http://mirror.math.princeton.edu/pub/alpinelinux/edge/testing/ >> /etc/apk/repositories && apk add --no-cache nano sudo libuser shadow ca-certificates 
ARG USER=alpine
ENV CONTAINERUSER=$USER
ENV HOME="/home/$USER"
ENV PATH="/home/$CONTAINERUSER/.local/bin:/home/$CONTAINERUSER/.local/lib/:$PATH"
RUN mkdir /etc/skel && \
    echo "Defaults        lecture=always" >> /etc/sudoers && \
    echo "Defaults        lecture_file=/etc/sudo_lecture.txt" >> /etc/sudoers && \ 
    echo "%wheel ALL=(ALL) ALL"  >> /etc/sudoers && \
    addgroup -g 1000 $USER  && \
    luseradd -u 1000 -g $USER -d /home/$USER -s /bin/sh -P $USER $USER && \
    adduser alpine wheel && \
    mkdir -p /home/$CONTAINERUSER/.local/bin && \
    mkdir -p /home/$CONTAINERUSER/.local/bin && \
    chown -R $CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER
WORKDIR $HOME
COPY sudo_lecture.txt /etc/sudo_lecture.txt
CMD ["/bin/sh"]
