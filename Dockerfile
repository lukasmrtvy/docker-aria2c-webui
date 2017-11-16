FROM alpine:latest

ENV ARIA2WEBUI_VERSION 77636e25af04a965435519903ae09819ab727586

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

RUN addgroup -S ${GROUP} -g ${GID} && adduser -D -S -u ${UID} ${USER} ${GROUP}  && \
    apk add --no-cache darkhttpd tar curl && \
    mkdir -p /opt/aria2c-webui  && \
    curl -sSL https://github.com/ziahamza/webui-aria2/archive/${ARIA2WEBUI_VERSION}.tar.gz | tar xz -C /opt/aria2c-webui --strip-components=1 && \
    chown -R ${USER}:${GROUP} /opt/aria2c-webui  && \
    apk del tar curl

EXPOSE 8080

USER ${USER}

LABEL version=${ARIA2WEBUI_VERSION}
LABEL url=https://api.github.com/repos/ziahamza/webui-aria2/commits/master

CMD darkhttpd /opt/aria2c-webui --port 8080 
