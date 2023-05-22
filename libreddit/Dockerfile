
FROM 192.168.0.2:5050/dedyms/libreddit:dev-rust AS tukang
ARG RELEASE
RUN git clone --depth=1 -b $RELEASE https://github.com/spikecodes/libreddit.git /libreddit
#RUN git clone --depth=1 https://github.com/spikecodes/libreddit.git /libreddit
WORKDIR /libreddit
RUN cargo build --release
FROM 192.168.0.2:5050/dedyms/debian:latest
ARG RELEASE
ENV LIBREDDIT_VERSION=$RELEASE
ENV LIBREDDIT_DEFAULT_THEME=dark
ENV LIBREDDIT_DEFAULT_FRONT_PAGE=popular
ENV LIBREDDIT_DEFAULT_LAYOUT=card
ENV LIBREDDIT_DEFAULT_WIDE=off
ENV LIBREDDIT_DEFAULT_COMMENT_SORT=new
ENV LIBREDDIT_DEFAULT_POST_SORT=new
ENV LIBREDDIT_DEFAULT_SHOW_NSFW=on
ENV LIBREDDIT_DEFAULT_USE_HLS=on
ENV LIBREDDIT_DEFAULT_HIDE_HLS_NOTIFICATION=off
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER /libreddit/target/release/libreddit $HOME/.local/bin/libreddit
EXPOSE 8080
USER $CONTAINERUSER
#HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider --q http://localhost:8080/settings || exit 1
#HEALTHCHECK CMD curl --fail http://localhost:8080/ || exit 1
CMD ["libreddit"]