# syntax=docker/dockerfile:1
FROM busybox:1.34.1 AS builder

ENV RESVG_URL=https://github.com/RazrFalcon/resvg/releases/download/v0.19.0/resvg-linux-x86_64.tar.gz

SHELL ["/bin/ash", "-o", "pipefail", "-c"]
RUN wget -q -O - $RESVG_URL | tar zxvf -

FROM gcr.io/distroless/cc-debian11:0a3c30a19ffb51f79c34955fdb9b77b8aa3b4309
COPY --from=builder resvg /bin/resvg
ENTRYPOINT ["/bin/resvg"]
