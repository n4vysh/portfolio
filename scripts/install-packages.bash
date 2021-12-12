#!/bin/bash

awk '{print $1}' .tool-versions |
  grep -v 'just' |
  xargs -I {} asdf plugin add {}
asdf plugin add just https://github.com/heliumbrain/asdf-just
asdf plugin add kubeval https://github.com/stefansedich/asdf-kubeval
asdf install