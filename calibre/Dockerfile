FROM alpine:3
#ADD

#ADD 
RUN apk add --no-cache tar curl xz
RUN curl -L https://download.calibre-ebook.com/7.1.0/calibre-7.1.0-x86_64.txz -o calibre-tarball.txz
RUN mkdir -p /opt/calibre && \
    tar -xvf calibre-tarball.txz -C /opt/calibre
#    /opt/calibre/calibre_postinstall && \
#    rm calibre-tarball.txz
