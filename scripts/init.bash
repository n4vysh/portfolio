#!/bin/bash

if type asdf >/dev/null 2>&1 &&
  asdf which direnv >/dev/null 2>&1 &&
  asdf exec direnv status |
  grep 'Found RC allowed false' >/dev/null; then
  asdf exec direnv allow
fi

if ! type denon >/dev/null 2>&1; then
  deno install -qAf --unstable https://deno.land/x/denon@2.4.10/denon.ts
fi

if ! type trex >/dev/null 2>&1; then
  # trex is not support xdg directory
  # https://github.com/crewdevio/Trex/blob/v1.10.0/utils/storage.ts#L40
  # https://github.com/denoland/deno/issues/1241
  [[ ! -d ~/.deno ]] && mkdir ~/.deno
  deno install \
    -A \
    --unstable \
    --import-map=https://deno.land/x/trex@v1.10.0/import_map.json \
    -n trex \
    --no-check \
    https://deno.land/x/trex@v1.10.0/cli.ts
fi

if ! type aleph >/dev/null 2>&1; then
  denon install:aleph
fi

if [[ ! -d ~/.cache/deno/deno_puppeteer/chromium/ ]]; then
  denon install:puppeteer
fi

if type pre-commit >/dev/null 2>&1; then
  if ! grep '# File generated by pre-commit: https://pre-commit.com' .git/hooks/pre-commit >/dev/null; then
    pre-commit install --install-hooks
  fi

  if ! grep '# File generated by pre-commit: https://pre-commit.com' .git/hooks/commit-msg >/dev/null; then
    pre-commit install --hook-type commit-msg
  fi
fi
