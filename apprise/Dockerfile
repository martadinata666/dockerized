FROM 192.168.0.2:5050/dedyms/debian:dev AS tukang
# set environment variables
ARG APPRISE_RELEASE
ARG APPRISE_API_RELEASE
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
WORKDIR $HOME
RUN sudo apt-get update -qq && \
    sudo apt-get install -y --no-install-recommends libffi-dev libgnutls28-dev
USER $CONTAINERUSER
RUN git clone --depth=1 -b $APPRISE_API_RELEASE https://github.com/caronc/apprise-api.git apprise
RUN pip3 install --break-system-packages --user --no-cache-dir -r ./apprise/requirements.txt gunicorn && \
    pip3 install --break-system-packages --user apprise==$APPRISE_RELEASE
ADD https://raw.githubusercontent.com/STaRDoGG/apprise-nord-dark-theme/main/minified/highlight.min.css ./apprise/apprise_api/static/css/highlight.min.css
ADD https://raw.githubusercontent.com/STaRDoGG/apprise-nord-dark-theme/main/minified/materialize.min.css ./apprise/apprise_api/static/css/materialize.min.css

FROM 192.168.0.2:5050/dedyms/nginx:mainline
ARG APPRISE_RELEASE
ARG API_RELEASE
ENV APPRISE_RELEASE=$APPRISE_RELEASE
ENV APPRISE_API_RELEASE=$API_RELEASE
RUN sudo apt update && \
    sudo apt install -y --no-install-recommends python3-full libffi8 python3-setuptools supervisor && \
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/*
# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV APPRISE_CONFIG_DIR $HOME/apprise/config
ENV APPRISE_ATTACH_DIR $HOME/apprise/attach
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/.local/ $HOME/.local/
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/apprise/apprise_api $HOME/apprise/apprise_api
COPY --from=tukang --chown=$CONTAINERUSER:$CONTAINERUSER $HOME/apprise/apprise_api/static /var/www/html/s/
COPY --chown=$CONTAINERUSER:$CONTAINERUSER gunicorn.conf.py $HOME/apprise/apprise_api/gunicorn.conf.py
COPY --chown=$CONTAINERUSER:$CONTAINERUSER supervisor /supervisor
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8000
USER $CONTAINERUSER
RUN mkdir $HOME/apprise/config $HOME/apprise/attach
WORKDIR $HOME/apprise/apprise_api
VOLUME $HOME/apprise/config
VOLUME $HOME/apprise/attach
CMD ["supervisord","-c","/supervisor/supervisord.conf"]

