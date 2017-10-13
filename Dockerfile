FROM alpine:latest

ENV ARIA2WEBUI_VERSION 1.0

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

RUN addgroup -S ${GROUP} -g ${GID} && adduser -D -S -u ${UID} ${USER} ${GROUP}  && \
    apk add --no-cache darkhttpd git && \
    git clone https://github.com/ziahamza/webui-aria2 /opt/aria2-webui && \
    apk del git

EXPOSE 8080

USER ${USER}

VOLUME /opt/aria2-webui

LABEL version=${ARIA2WEBUI_VERSION}
LABEL url=https://api.github.com/repos/ziahamza/webui-aria2/commits/master

CMD darkhttpd /opt/aria2-webui --port 8080 
