FROM 192.168.0.2:5050/dedyms/debian:latest
ENV SSHPORT=2222
RUN apt update && apt install --no-install-recommends -y openssh-server && apt clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && echo "mkdir -p /var/run/sshd" >> /etc/rc.local
RUN /usr/bin/ssh-keygen -A
CMD ["bash", "-c", "/usr/sbin/sshd -D -e -p $SSHPORT"]
