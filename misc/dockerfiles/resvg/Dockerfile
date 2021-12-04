# syntax=docker/dockerfile:1
FROM busybox:1.34.1 AS builder

ENV RESVG_URL=https://github.com/RazrFalcon/resvg/releases/download/v0.19.0/resvg-linux-x86_64.tar.gz

RUN wget -O - $RESVG_URL | tar zxvf -

FROM gcr.io/distroless/cc
COPY --from=builder resvg /bin/resvg
ENTRYPOINT ["/bin/resvg"]
