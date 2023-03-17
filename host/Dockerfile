FROM rust:1.70.0-alpine3.18
MAINTAINER Charles Samborski <demurgos@demurgos.net>

RUN apk add --no-cache build-base curl docker

RUN mkdir -p /opt/sccache \
  && curl -L https://github.com/mozilla/sccache/releases/download/v0.5.3/sccache-v0.5.3-x86_64-unknown-linux-musl.tar.gz \
    | tar -xz --to-stdout "sccache-v0.5.3-x86_64-unknown-linux-musl/sccache" > /opt/sccache/sccache \
  && chmod +x /opt/sccache/sccache

ENV PATH=/opt/sccache:$PATH

RUN mkdir -p /opt/cross \
  && curl -L https://github.com/cross-rs/cross/releases/download/v0.2.5/cross-x86_64-unknown-linux-musl.tar.gz \
    | tar -xz --to-stdout "cross" > /opt/cross/cross \
  && chmod +x /opt/cross/cross

ENV PATH=/opt/cross:$PATH

CMD ["/bin/sh"]
