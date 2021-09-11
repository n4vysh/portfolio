registry := "ghcr.io"
user := "n4vysh"
project := "portfolio"
version := "0.1.0"
image := registry + "/" + user + "/" + project + ":" + version

dev:
    aleph dev

build: download build-aleph build-pack

build-aleph:
    aleph build

build-pack:
    pack build {{image}} --builder paketobuildpacks/builder:base

init:
    asdf exec direnv allow
    deno run -A https://deno.land/x/aleph/install.ts
    pre-commit install --install-hooks
    yarn install

download:
    deno run \
        --allow-net \
        --allow-write \
        --import-map ./import_map.json \
        scripts/download.ts

fmt:
    fd '\.ts(|x)$' -t f | xargs -t deno fmt

lint:
    fd '\.ts(|x)$' -t f | xargs -t deno lint

test:
    yarn test

start:
    docker run --rm -t -e HOST=localhost -e PORT=8080 -p 8080:8080 {{image}}

login:
    docker login -u {{user}} {{registry}}

pull:
    docker pull "{{image}}"

push:
    docker push "{{image}}"
