FROM alpine:latest

RUN apk add --no-cache tor

COPY torrc /etc/tor/torrc

ENTRYPOINT ["/usr/bin/tor", "-f", "/etc/tor/torrc"]
