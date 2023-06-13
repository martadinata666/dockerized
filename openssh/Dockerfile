FROM 192.168.0.2:5050/dedyms/debian:dev as tukang
WORKDIR /openssh
ARG RELEASE
RUN git clone --depth=1 -b $RELEASE https://github.com/openssh/openssh-portable.git /openssh
#RUN git clone --depth=1 https://github.com/openssh/openssh-portable.git /openssh
RUN sudo apt update && \
    sudo apt install -y libpam-dev libssl-dev libedit-dev 
RUN autoreconf && \
    ./configure --with-pam --with-libedit && \
    make -j $(nproc) && \
    sudo make install

FROM 192.168.0.2:5050/dedyms/debian:latest
ENV SSHPORT=2222
ENV OPENSSH_VERSION=$RELEASE
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /usr/local $HOME/.local
COPY --chown=$CONTAINERUSER:$CONTAINERUSER sshd_config $HOME/sshd_config
USER $CONTAINERUSER
WORKDIR $HOME
RUN mkdir -p $HOME/.ssh && \
    ssh-keygen -t rsa -N '' -f $HOME/.ssh/id_rsa
VOLUME ["$HOME/.ssh"]
CMD ["bash", "-c", "$HOME/.local/sbin/sshd -f $HOME/sshd_config -D -e -p $SSHPORT"]
