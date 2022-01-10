set dotenv-load := false

dev:
    just frontend/dev

build:
    just frontend/build

# Check codes with hooks
check *target:
    pre-commit run -av {{ target }}

# Update package and hook versions
update: update-package-versions update-hooks

# Update package versions
update-package-versions:
    ./scripts/update-packages.bash

# Update hook versions
update-hooks:
    pre-commit autoupdate

# List available commands
list:
    ./scripts/list.bash

deploy:
    just infra/deploy

destroy:
    just infra/destroy

fmt: fmt-yaml fmt-toml

fmt-yaml *target:
    prettier --parser yaml --write --list-different {{ target }}

fmt-toml *target:
    taplo format {{ target }}

lint: lint-toml lint-commit lint-md

lint-toml *target:
    taplo lint {{ target }}

lint-commit *target:
    commitlint --edit {{ target }}

lint-md *target:
    markdown-link-check --config .markdown-link-check.json {{ target }}
