#FROM 192.168.0.2:5050/dedyms/docker-with-buildx:latest
FROM 192.168.0.2:5050/dedyms/docker-static:latest
ENV SLEEP_TIME='5m'
ENV FILTER_SERVICES=''
ENV TZ='US/Eastern'
ENV VERBOSE='true'
COPY shepherd /usr/local/bin/shepherd
ENTRYPOINT ["/usr/local/bin/shepherd"]
