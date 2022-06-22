
FROM 192.168.0.2:5050/dedyms/debian:dev AS tukang
# set environment variables
ARG APPRISE_RELEASE
ARG APPRISE_API_RELEASE
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV APPRISE_CONFIG_DIR /config
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
WORKDIR $HOME
RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends libffi-dev libssl-dev
USER $CONTAINERUSER
RUN git clone --depth=1 -b $APPRISE_API_RELEASE https://github.com/caronc/apprise-api.git apprise
RUN pip3 install --user --no-cache-dir -r ./apprise/requirements.txt gunicorn && pip3 install --user apprise==$APPRISE_RELEASE


FROM 192.168.0.2:5050/dedyms/nginx:mainline
ARG APPRISE_RELEASE
ARG API_RELEASE
ENV APPRISE_RELEASE=$APPRISE_RELEASE
ENV APPRISE_API_RELEASE=$API_RELEASE
USER root
RUN apt update && apt install -y --no-install-recommends \
    python3-minimal libffi7 libssl1.1 python3-setuptools supervisor && \
    apt clean && \
    rm -rf /var/lib/apt/*
# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV APPRISE_CONFIG_DIR $HOME/apprise/config
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/ $HOME/.local/
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/apprise/apprise_api $HOME/apprise/apprise_api
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/apprise/apprise_api/static /var/www/html/s/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER gunicorn.conf.py $HOME/apprise/apprise_api/gunicorn.conf.py
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor $HOME/supervisor
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8000
USER $CONTAINERUSER
WORKDIR $HOME/apprise/apprise_api
VOLUME $HOME/apprise/config
CMD ["supervisord","-c","/home/debian/supervisor/supervisord.conf"]
#CMD ["gunicorn", "-c", "./gunicorn.conf.py", "--worker-tmp-dir", "/dev/shm", "core.wsgi"]

