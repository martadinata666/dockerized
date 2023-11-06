FROM 192.168.0.2:5050/dedyms/debian:dev as builder
# Get from http://www.squid-cache.org/Versions/v6/
RUN curl -L http://www.squid-cache.org/Versions/v6/squid-6.4.tar.gz -o squid.tar.gz
COPY squid.tar.gz squid.tar.gz
RUN tar -xzvf squid.tar.gz
COPY build.sh squid-6.4/build.sh
WORKDIR $HOME/squid-6.4
RUN bash ./build.sh

FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --from=builder --chown=docker /squid /squid
COPY entrypoint.sh /entrypoint.sh
COPY squid.conf /squid/etc/squid.conf
RUN sudo apt update && \
    sudo apt install -y libexpat1 && \
    sudo apt clean && \ 
    sudo rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["/squid/sbin/squid","--foreground","-d","6","-f","/data/squid.conf"]