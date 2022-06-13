FROM lldap:dev as builder
RUN apt update && apt install -y --no-install-recommends git
RUN git clone --depth=1 https://github.com/nitnelave/lldap.git /lldap-src
WORKDIR /lldap-src
RUN cargo build --release -p lldap -p migration-tool && \
    app/build.sh
RUN mkdir -p /lldap/app
RUN cp docker-entrypoint.sh /docker-entrypoint.sh && \
    cp lldap_config.docker_template.toml /lldap/ && \
    cp target/release/lldap /lldap/ && \
    cp target/release/migration-tool /lldap/ && \
    cp -R app/index.html \
          app/pkg \
          app/static \
          /lldap/app/
RUN ls -al /lldap && \
    ls -al /lldap/app
RUN apt update && apt install -y --no-install-recommends wget
WORKDIR /lldap
RUN set -x \
    && for file in $(cat /lldap/app/static/libraries.txt); do wget -P app/static "$file"; done \
    && for file in $(cat /lldap/app/static/fonts/fonts.txt); do wget -P app/static/fonts "$file"; done \
    && chmod a+r -R .

FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --from=builder --chown=$CONTAINERUSER:$CONTAINERUSER /lldap /app
COPY --from=builder --chown=$CONTAINERUSER:$CONTAINERUSER /docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /app
USER $CONTAINERUSER
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["run", "--config-file", "/data/lldap_config.toml"]
