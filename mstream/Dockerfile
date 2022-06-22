
FROM 192.168.0.2:5050/dedyms/node:lts-dev AS tukang
USER $CONTAINERUSER
ARG RELEASE
WORKDIR $HOME
RUN git clone --depth=1 -b $RELEASE https://github.com/IrosTheBeggar/mStream.git mstream && rm -rf /home/$CONTAINERUSER/mstream/.git /home/$CONTAINERUSER/mstream/docs
WORKDIR /home/$CONTAINERUSER/mstream
RUN pnpm config set store-dir .pnpm-store && \
    pnpm install --prod


FROM 192.168.0.2:5050/dedyms/node:lts
ARG RELEASE
ENV MSTREAM_RELEASE=$RELEASE
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /home/$CONTAINERUSER/mstream/ /home/$CONTAINERUSER/mstream/
WORKDIR /home/$CONTAINERUSER/mstream
USER $CONTAINERUSER
VOLUME /home/$CONTAINERUSER/mstream/save
VOLUME /home/$CONTAINERUSER/mstream/image-cache
CMD ["node", "cli-boot-wrapper.js", "-j", "save/conf/config.json"]
