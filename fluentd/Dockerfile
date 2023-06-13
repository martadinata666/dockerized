FROM fluent/fluentd:edge

USER root

# install dependencies
RUN apk add --no-cache build-base geoip-dev libmaxminddb-dev && \
    gem install fluent-plugin-elasticsearch --no-document && \
    gem install fluent-plugin-opensearch --no-document && \
    gem install fluent-plugin-beats --no-document && \
    gem install fluent-plugin-docker --no-document && \
    apk del build-base geoip-dev libmaxminddb-dev

USER fluent
