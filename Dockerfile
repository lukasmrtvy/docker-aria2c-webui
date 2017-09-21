FROM alpine:latest

ENV RPC_TOKEN test

ENV ARIA2_VERSION 1.32.0

ENV UID 1000
ENV USER htpc
ENV GROUP htpc

ENV VARIABLES "--enable-rpc=true --rpc-secret=test"

RUN addgroup -S ${GROUP} && adduser -D -S -u ${UID} ${USER} ${GROUP} && \
    apk add --no-cache --virtual .build-deps curl git make g++ && \
    apk add --no-cache gnutls-dev expat-dev sqlite-dev c-ares-dev && \
    mkdir -p /tmp/aria2 && curl -sL https://github.com/aria2/aria2/releases/download/release-${ARIA2_VERSION}/aria2-${ARIA2_VERSION}.tar.gz | tar xz -C /tmp/aria2 --strip-components=1 && \
    cd /tmp/aria2 && ./configure && make -j $(getconf _NPROCESSORS_ONLN) && make install && \
    apk del .build-deps && rm -rf /tmp/*

RUN apk add --no-cache darkhttpd git && \
    git clone https://github.com/ziahamza/webui-aria2 /opt/aria2-webui

EXPOSE 6800
EXPOSE 80

#ENTRYPOINT aria2c
#CMD ${VARIABLES}

USER ${USER}

VOLUME /opt/downloads

LABEL name=aria2
LABEL version=${ARIA2_VERSION}
LABEL url=https://api.github.com/repos/aria2/aria2/releases/latest
LABEL url2=https://api.github.com/repos/ziahamza/webui-aria2/commits/master

CMD darkhttpd /opt/aria2-webui --port 80 --daemon && aria2c --enable-rpc=true --rpc-secret=${RPC_TOKEN} --rpc-listen-all=true -d /opt/downloads
