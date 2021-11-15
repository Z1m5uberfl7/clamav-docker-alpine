FROM alpine:3.14
LABEL maintainer "https://github.com/j1mprime"

RUN apk add --no-cache bash clamav clamav-daemon clamav-libunrar

# initial database initialization at build time
COPY ./main.cvd  /var/lib/clamav/main.cvd

COPY conf /etc/clamav
COPY bootstrap.sh /
COPY check.sh /

RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav && \
    chown -R clamav:clamav bootstrap.sh check.sh /etc/clamav /etc/clamav/clamd.conf /etc/clamav/freshclam.conf && \
    chmod u+x bootstrap.sh check.sh

EXPOSE 3310

USER clamav

CMD ["/bootstrap.sh"]
