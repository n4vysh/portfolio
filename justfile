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
    pack build {{ image }} --builder paketobuildpacks/builder:base

init: init-direnv init-aleph init-pre-commit

init-direnv:
    asdf exec direnv allow

init-aleph:
    deno run -A https://deno.land/x/aleph/install.ts

init-pre-commit:
    pre-commit install --install-hooks

download:
    deno run \
        --allow-net \
        --allow-write \
        --import-map ./import_map.json \
        scripts/download.ts

check:
    pre-commit run -av

start:
    docker run --rm -t -e HOST=localhost -e PORT=8080 -p 8080:8080 {{ image }}

login:
    docker login -u {{ user }} {{ registry }}

pull:
    docker pull "{{ image }}"

push:
    docker push "{{ image }}"

update-asdf:
    awk '{print $1}' .tool-versions | \
      xargs -t -I {} sh -c 'asdf install {} latest && asdf local {} latest'
