FROM 192.168.0.2:5050/dedyms/debian:dev AS tukang
ARG RELEASE
RUN apt update && apt install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    libxml2-dev \
    libxslt-dev \
    libssl-dev \
    libffi-dev
USER $CONTAINERUSER
RUN git clone --depth=1 -b $RELEASE https://github.com/benbusby/whoogle-search.git $HOME/whoogle
WORKDIR $HOME/whoogle
RUN pip3 install --user --no-warn-script-location --no-cache-dir -r requirements.txt

FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && apt install -y --no-install-recommends libcurl4 curl python3-minimal python3-setuptools
ARG RELEASE
ENV RELEASE=$RELEASE
ARG username=''
ENV WHOOGLE_USER=$username
ARG password=''
ENV WHOOGLE_PASS=$password

ARG proxyuser=''
ENV WHOOGLE_PROXY_USER=$proxyuser
ARG proxypass=''
ENV WHOOGLE_PROXY_PASS=$proxypass
ARG proxytype=''
ENV WHOOGLE_PROXY_TYPE=$proxytype
ARG proxyloc=''
ENV WHOOGLE_PROXY_LOC=$proxyloc

ARG whoogle_dotenv=''
ENV WHOOGLE_DOTENV=$whoogle_dotenv

ARG use_https=''
ENV HTTPS_ONLY=$use_https

ARG whoogle_port=5000
ENV EXPOSE_PORT=$whoogle_port

ARG twitter_alt='nitter.net'
ENV WHOOGLE_ALT_TW=$twitter_alt
ARG youtube_alt='invidious.snopyta.org'
ENV WHOOGLE_ALT_YT=$youtube_alt
ARG instagram_alt='bibliogram.art/u'
ENV WHOOGLE_ALT_IG=$instagram_alt
ARG reddit_alt='libredd.it'
ENV WHOOGLE_ALT_RD=$reddit_alt
ARG translate_alt='lingva.ml'
ENV WHOOGLE_ALT_TL=$translate_alt

WHOOGLE_CONFIG_DISABLE=true
WHOOGLE_CONFIG_THEME=dark

COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/.local $HOME/.local
COPY --chown=$CONTAINERUSER:$CONTAINERUSER --from=tukang $HOME/whoogle/app $HOME/whoogle/app
ENV CONFIG_VOLUME=$HOME/whoogle/config
VOLUME $HOME/whoogle/config

EXPOSE $EXPOSE_PORT
HEALTHCHECK  --interval=30s --timeout=5s \
  CMD curl -f http://localhost:${EXPOSE_PORT}/healthz || exit 1
WORKDIR $HOME/whoogle
CMD python3 -um app --host "${ADDRESS:-0.0.0.0}" --port "${PORT:-"${EXPOSE_PORT:-5000}"}"