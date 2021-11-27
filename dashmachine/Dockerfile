FROM 192.168.0.2:5050/dedyms/debian:latest
RUN apt update && \
    apt install -y --no-install-recommends python3-pip git && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
ENV PRODUCTION=true
USER $CONTAINERUSER
RUN git clone --depth=1 https://github.com/rmountjoy92/DashMachine.git $HOME/dashmachine
WORKDIR $HOME/dashmachine
RUN pip3 install --user --no-cache-dir -r requirements.txt && \
    mkdir -p $HOME/dashmachine/dashmachine/user_data
EXPOSE 5000
VOLUME $HOME/dashmachine/dashmachine/user_data
CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "wsgi:app" ]