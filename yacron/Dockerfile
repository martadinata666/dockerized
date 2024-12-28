FROM martadinata666/yacron:ci as ci

FROM debian:stable-slim
COPY --from=ci /usr/local/bin/yacron /usr/local/bin/yacron