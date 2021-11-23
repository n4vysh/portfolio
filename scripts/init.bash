#!/bin/bash

if type asdf >/dev/null 2>&1 &&
  asdf which direnv >/dev/null 2>&1 &&
  asdf exec direnv status |
  grep 'Found RC allowed false' >/dev/null; then
  asdf exec direnv allow
fi

if ! type aleph >/dev/null 2>&1; then
  deno run -A https://deno.land/x/aleph/install.ts
fi

if [[ ! -d ~/.cache/deno/deno_puppeteer/chromium/ ]]; then
  PUPPETEER_PRODUCT=chrome deno run -A --unstable https://deno.land/x/puppeteer@9.0.2/install.ts
fi
if [[ ! -d ~/.cache/deno/deno_puppeteer/firefox/ ]]; then
  PUPPETEER_PRODUCT=firefox deno run -A --unstable https://deno.land/x/puppeteer@9.0.2/install.ts
fi

if type pre-commit >/dev/null 2>&1; then
  if ! grep '# File generated by pre-commit: https://pre-commit.com' .git/hooks/pre-commit >/dev/null; then
    pre-commit install --install-hooks
  fi

  if ! grep '# File generated by pre-commit: https://pre-commit.com' .git/hooks/commit-msg >/dev/null; then
    pre-commit install --hook-type commit-msg
  fi
fi