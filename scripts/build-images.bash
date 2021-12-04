#!/bin/bash

for d in misc/dockerfiles/*; do
  docker build -f "$d/Dockerfile" -t "$(basename "$d")" .
done

touch "$PWD"/public/images/icon.{svg,png}

docker run \
  -i \
  --rm \
  --mount "type=bind,src=$PWD/misc/icon.svg,dst=/icon.svg" \
  --mount "type=bind,src=$PWD/public/images/icon.svg,dst=/icon.min.svg" \
  svgo icon.svg -o icon.min.svg

docker run \
  -i \
  --rm \
  --mount "type=bind,src=$PWD/public/images/icon.svg,dst=/icon.svg" \
  --mount "type=bind,src=$PWD/public/images/icon.png,dst=/icon.png" \
  resvg icon.svg icon.png

docker run \
  -i \
  --rm \
  --mount "type=bind,src=$PWD/public/images/icon.png,dst=/icon.png" \
  oxipng -o 3 -i 1 --strip safe icon.png
