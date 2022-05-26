FROM 192.168.0.2:5050/dedyms/phantomjs:src as builder
WORKDIR /phantomjs
RUN python ./build.py --confirm --release --silent --jobs 10
#RUN ldd bin/phantomjs
#RUN python test/run-tests.py --verbose
RUN bin/phantomjs --version

FROM martadinata666/debian:latest
COPY --from=builder /phantomjs/bin/phantomjs /usr/local/bin/phantomjs
