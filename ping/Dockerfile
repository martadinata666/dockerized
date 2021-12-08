FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends iputils-ping && apt clean && rm -rf /var/lib/apt/lists/*
ENV URL=google.com
ENV OPTIONS="-4"
USER $CONTAINERUSER
RUN ["bash","-c","ping $OPTIONS $URL"]
