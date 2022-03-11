FROM 192.168.0.2:5050/dedyms/debian:latest AS base
ARG TARGETPLATFORM
ARG RELEASE
ENV DEBIAN_FRONTEND=noninteractive
# hadolint ignore=DL3008
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        wget \
        tzdata \
        openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean

ARG DOCKER_MACHINE_VERSION=0.16.2
#ARG DUMB_INIT_VERSION=1.2.2
ARG GIT_LFS_VERSION=2.13.3
#COPY gitlab-runner_*.deb checksums-* install-deps install-gitlab-runner /tmp/
#RUN curl -o /usr/local/bin/gitlab-runner -L https://gitlab.com/gitlab-org/gitlab-runner/-/releases/${RELEASE}/downloads/binaries/gitlab-runner-linux-${TARGETARCH} && chmod +x /usr/local/bin/gitlab-runner
COPY checksums-* install-deps /tmp/
RUN /tmp/install-deps "${TARGETPLATFORM}" "${DOCKER_MACHINE_VERSION}" "${DUMB_INIT_VERSION}" "${GIT_LFS_VERSION}" && rm -rf /tmp/

FROM 192.168.0.2:5050/dedyms/debian:latest AS fetcher
ARG RELEASE
ARG TARGETARCH
#RUN curl -o /usr/local/bin/gitlab-runner -L https://gitlab.com/gitlab-org/gitlab-runner/-/releases/${RELEASE}/downloads/binaries/gitlab-runner-linux-${TARGETARCH} && chmod +x /usr/local/bin/gitlab-runner
RUN curl -o /usr/local/bin/gitlab-runner -L https://gitlab-runner-downloads.s3.amazonaws.com/${RELEASE}/binaries/gitlab-runner-linux-${TARGETARCH} && chmod +x /usr/local/bin/gitlab-runner


FROM 192.168.0.2:5050/dedyms/debian:latest
COPY --from=base / /
COPY --from=fetcher /usr/local/bin/gitlab-runner /usr/local/bin/gitlab-runner
COPY entrypoint /
STOPSIGNAL SIGQUIT
VOLUME ["/etc/gitlab-runner", "/home/debian"]
ENTRYPOINT ["tini","-g", "--", "/entrypoint"]
CMD ["run", "--user=debian", "--working-directory=/home/debian"]
