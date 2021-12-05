# syntax=docker/dockerfile:1
FROM node:17.2.0-alpine3.12 AS builder

RUN yarn add svgo@2.8.0

FROM scratch

COPY --from=builder . /

ENTRYPOINT ["node_modules/.bin/svgo"]
