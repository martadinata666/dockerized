FROM 192.168.0.2:6060/dedyms/debian:latest
#Do nothing test
#RUN sudo apt update && \
#    sudo apt install -y --no-install-recommends iputils-ping && \
#    sudo apt clean && \
#    sudo rm -rf /var/lib/apt/lists/*
ENV URL=www.google.com
ENV OPTIONS="-4"
USER $CONTAINERUSER
CMD ["bash","-c","ping $OPTIONS $URL"]
