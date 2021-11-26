registry := "ghcr.io"
user := "n4vysh"
name := "portfolio"
version := "0.1.1"
image := registry + "/" + user + "/" + name + ":" + version

set dotenv-load := false

dev: download
    aleph dev

build: download build-aleph build-pack

init:
    ./scripts/init.bash

install *packages: init
    trex install {{ packages }}

download: init
    denon download

check *target: init
    pre-commit run -av {{ target }}

build-aleph:
    aleph build

build-pack:
    pack build {{ image }} --builder paketobuildpacks/builder:base

start: build
    docker run --rm --env-file .env -dp 8080:8080 --name {{ name }} {{ image }}

logs:
    docker logs -f {{ name }}

stop:
    docker stop {{ name }}

login:
    docker login -u {{ user }} {{ registry }}

publish: login
    docker push {{ image }}

update: update-asdf update-pre-commit

update-asdf:
    ./scripts/update-packages.bash

update-pre-commit:
    pre-commit autoupdate

screenshot: start
    denon screenshot
    just stop
