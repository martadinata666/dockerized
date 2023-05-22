#syntax=docker/dockerfile:1.4
FROM 192.168.0.2:5050/dedyms/reactive-resume:dev as builder
USER $CONTAINERUSER
RUN git clone --depth=1 -b develop https://github.com/martadinata666/Reactive-Resume.git $HOME/reactive-resume
WORKDIR $HOME/reactive-resume
RUN pnpm -d install

FROM 192.168.0.2:5050/dedyms/node:lts
RUN apt update && \
    apt install -y --no-install-recommends libvips42 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/reactive-resume $HOME/reactive-resume
WORKDIR $HOME/reactive-resume
USER $CONTAINERUSER
EXPOSE 9000
CMD ["pnpm","run","start"]
