#!/bin/bash

for d in misc/dockerfiles/*; do
  docker build -q -f "$d/Dockerfile" -t "$(basename "$d")" .
done

touch "$PWD"/public/images/icon.{svg,png}

svgo() {
  docker run \
    -i \
    --rm \
    --mount "type=bind,src=$PWD/misc/icon.svg,dst=/misc/icon.svg" \
    --mount "type=bind,src=$PWD/public/images/icon.svg,dst=/public/images/icon.svg" \
    svgo "$@"
}

resvg() {
  docker run \
    -i \
    --rm \
    --mount "type=bind,src=$PWD/public/images/icon.svg,dst=/public/images/icon.svg" \
    --mount "type=bind,src=$PWD/public/images/icon.png,dst=/public/images/icon.png" \
    resvg "$@"
}

oxipng() {
  docker run \
    -i \
    --rm \
    --mount "type=bind,src=$PWD/public/images/icon.png,dst=/public/images/icon.png" \
    oxipng "$@"
}

svgo misc/icon.svg -o public/images/icon.svg
resvg public/images/icon.svg public/images/icon.png
oxipng -o 3 -i 1 --strip safe public/images/icon.png
