#!/bin/bash

docker build -f misc/dockerfiles/svgo/Dockerfile -t svgo .
touch "$PWD"/public/images/icon.svg
docker run \
  -i \
  --rm \
  --mount "type=bind,src=$PWD/misc/icon.svg,dst=/icon.svg" \
  --mount "type=bind,src=$PWD/public/images/icon.svg,dst=/icon.min.svg" \
  svgo icon.svg -o icon.min.svg

docker build -f misc/dockerfiles/resvg/Dockerfile -t resvg .
touch "$PWD"/public/images/icon.png
docker run \
  -i \
  --rm \
  --mount "type=bind,src=$PWD/public/images/icon.svg,dst=/icon.svg" \
  --mount "type=bind,src=$PWD/public/images/icon.png,dst=/icon.png" \
  resvg icon.svg icon.png

docker build -f misc/dockerfiles/oxipng/Dockerfile -t oxipng .
touch "$PWD"/public/images/icon.png
docker run \
  -i \
  --rm \
  --mount "type=bind,src=$PWD/public/images/icon.png,dst=/icon.png" \
  oxipng -o 3 -i 1 --strip safe icon.png
