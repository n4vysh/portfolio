registry := "ghcr.io"
user := "n4vysh"
project := "portfolio"
version := "0.1.0"
image := registry + "/" + user + "/" + project + ":" + version

dev: init download dev-aleph

build: init download build-aleph build-pack

init:
    ./scripts/init.bash

download:
    deno run \
        --allow-net \
        --allow-write \
        --import-map ./import_map.json \
        scripts/download.ts

dev-aleph:
    aleph dev

check:
    pre-commit run -av

build-aleph:
    aleph build

build-pack:
    pack build {{ image }} --builder paketobuildpacks/builder:base

start *opt:
    docker run {{ opt }} --rm -t -e HOST=localhost -e PORT=8080 -p 8080:8080 --name {{ project }} {{ image }}

start-background: (start "-d")

stop:
    docker stop {{ project }}

publish: login-docker push-docker

login-docker:
    docker login -u {{ user }} {{ registry }}

push-docker:
    docker push "{{ image }}"

update: update-asdf update-pre-commit

update-asdf:
    awk '{print $1}' .tool-versions | \
      xargs -t -I {} sh -c 'asdf install {} latest && asdf local {} latest'

update-pre-commit:
    pre-commit autoupdate

screenshot:
    just start-background
    deno run \
        -A \
        --unstable \
        --import-map ./import_map.json \
        scripts/screenshot.ts
    just stop
