#FROM buildpack-deps:xenial as builder
FROM 192.168.0.2:5050/dedyms/debian:bullseye
ARG RELEASE=2.1.1
RUN sudo apt update && \ 
    sudo apt install -y build-essential ruby gperf flex bison git python3 python-is-python3
RUN git clone --depth=1 -b $RELEASE https://github.com/ariya/phantomjs.git phantomjs
WORKDIR $HOME/phantomjs
RUN git submodule init && \
    git submodule update

#FROM 192.168.0.2:5050/dedyms/phantomjs:src as builder
#WORKDIR /phantomjs
RUN python ./build.py --confirm --release --silent --jobs 10
#RUN ldd bin/phantomjs
#RUN python test/run-tests.py --verbose
RUN bin/phantomjs --version

FROM martadinata666/debian:latest
COPY --from=builder /phantomjs/bin/phantomjs /usr/local/bin/phantomjs
