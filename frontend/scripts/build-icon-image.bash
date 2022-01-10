#!/bin/bash

svgo misc/icon.svg -o public/images/icon.svg
resvg public/images/icon.svg public/images/icon.png
oxipng -o 3 -i 1 --strip safe public/images/icon.png
