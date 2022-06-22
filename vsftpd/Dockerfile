
FROM 192.168.0.2:5050/dedyms/debian:latest
ENV LISTEN_PORT=21
ENV PASV_ADDRESS=127.0.0.1
ENV PASV_MIN_PORT=50000
ENV PASV_MAX_PORT=51000
COPY entrypoint.sh /entrypoint.sh
RUN apt update && apt install -y --no-install-recommends vsftpd && apt clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/run/vsftpd/empty && touch /var/log/vsftpd.log
COPY vsftpd.conf /etc/vsftpd.conf
ENTRYPOINT ["/entrypoint.sh"]
