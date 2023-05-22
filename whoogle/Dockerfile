FROM 192.168.0.2:5050/dedyms/debian:dev AS tukang
ARG RELEASE
ARG PIP_BREAK_SYSTEM_PACKAGES=1
RUN sudo apt update && sudo apt install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    libxml2-dev \
    libxslt-dev \
    libgnutls28-dev \
    libffi-dev
RUN git clone --depth=1 -b $RELEASE https://github.com/benbusby/whoogle-search.git $HOME/whoogle
WORKDIR $HOME/whoogle
RUN pip3 install --user --no-warn-script-location --no-cache-dir -r requirements.txt && \
    mkdir $HOME/whoogle/config && \
    chown $CONTAINERUSER:$CONTAINERUSER $HOME/whoogle/config

FROM 192.168.0.2:5050/dedyms/debian:latest
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends libcurl4 curl python3-minimal python3-setuptools && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*
ARG RELEASE
ARG username=''
ARG password=''
ARG whoogle_port=5000
ARG proxyuser=''
ARG proxypass=''
ARG proxytype=''
ARG proxyloc=''
ARG whoogle_dotenv=''
ARG use_https=''
ARG whoogle_port=5000
ARG twitter_alt='nitter.net'
ARG youtube_alt='invidious.snopyta.org'
ARG instagram_alt='bibliogram.art/u'
ARG reddit_alt='libredd.it'
ARG translate_alt='lingva.ml'


ENV RELEASE=$RELEASE \
    EXPOSE_PORT=$whoogle_port \
    WHOOGLE_ALT_TL=$translate_alt \
    WHOOGLE_CONFIG_DISABLE=true \
    WHOOGLE_CONFIG_THEME=dark \
    WHOOGLE_USER=$username \
    WHOOGLE_PASS=$password \
    WHOOGLE_PROXY_USER=$proxyuser \
    WHOOGLE_PROXY_PASS=$proxypass \
    WHOOGLE_PROXY_TYPE=$proxytype \
    WHOOGLE_PROXY_LOC=$proxylo \
    WHOOGLE_DOTENV=$whoogle_dotenv \
    HTTPS_ONLY=$use_https \
    EXPOSE_PORT=$whoogle_port \
    WHOOGLE_ALT_TW=$twitter_alt \
    WHOOGLE_ALT_YT=$youtube_alt \
    WHOOGLE_ALT_IG=$instagram_alt \
    WHOOGLE_ALT_RD=$reddit_alt \
    WHOOGLE_ALT_TL=$translate_alt

COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/.local $HOME/.local
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/whoogle $HOME/whoogle
ENV CONFIG_VOLUME=$HOME/whoogle/config
VOLUME $HOME/whoogle/config

EXPOSE $EXPOSE_PORT
HEALTHCHECK  --interval=30s --timeout=5s \
  CMD curl -f http://localhost:${EXPOSE_PORT}/healthz || exit 1
WORKDIR $HOME/whoogle
USER $CONTAINERUSER
CMD python3 -um app --host "${ADDRESS:-0.0.0.0}" --port "${PORT:-"${EXPOSE_PORT:-5000}"}"
