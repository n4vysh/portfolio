# syntax=docker/dockerfile:1
FROM busybox:1.34.1 AS builder

ENV OXIPNG_URL=https://github.com/shssoichiro/oxipng/releases/download/v5.0.1/oxipng-5.0.1-x86_64-unknown-linux-musl.tar.gz

RUN wget -O - $OXIPNG_URL | \
  tar zxvf - --strip-components 1 oxipng-5.0.1-x86_64-unknown-linux-musl/oxipng

FROM scratch
COPY --from=builder oxipng /bin/oxipng
ENTRYPOINT ["/bin/oxipng"]
