
FROM alpine:latest

RUN     apk update && \
        apk --no-cache upgrade && \
        apk add --no-cache aria2 darkhttpd supervisor && \
        mkdir -p /root/aria2 && \
        mkdir /root/aria2/download && \
        touch /root/aria2/aria2.session

RUN     apk add --no-cache --virtual build-dependencies git && \
        git clone https://github.com/ziahamza/webui-aria2 /root/aria2-webui && \
        apk del build-dependencies

ADD aria2.conf /root/aria2/

VOLUME /root/aria2/
VOLUME /root/aria2-webui/

EXPOSE 6800
EXPOSE 80

COPY  supervisord.conf /tmp/supervisord.conf

CMD /usr/bin/supervisord -c /tmp/supervisord.conf
