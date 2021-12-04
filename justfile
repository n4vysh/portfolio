registry := "ghcr.io"
user := "n4vysh"
name := "portfolio"
repo := user + "/" + name
image := registry + "/" + repo

set dotenv-load := false

# Start the web server in `development`
dev: init
    aleph dev

# Build a static site and container image
build: init build-images build-static-site build-container-image

# Grants direnv and install all the dependencies
init:
    ./scripts/init.bash

# Install frontend packages
install *packages: init
    trex install {{ packages }}

# Run frontend scripts
run *script:
    denon {{ script }}

# Check codes with hooks
check *target: init
    pre-commit run -av {{ target }}

# Build images
build-images:
    ./scripts/build-images.bash

# Build a static site
build-static-site:
    aleph build

# Build container image
build-container-image:
    skaffold build

# Login container registry
login:
    docker login -u {{ user }} {{ registry }}

# Update package and hook versions
update: update-package-versions update-hooks

# Update package versions
update-package-versions:
    ./scripts/update-packages.bash

# Update hook versions
update-hooks:
    pre-commit autoupdate

# Take a screenshot
take:
    just run screenshot

# Start the web server in container
dev-container: _create-cluster && _delete-cluster
    skaffold dev

_create-cluster: build && _deploy
    kind create cluster
    kind load --name {{ name }} docker-image {{ image }}

_deploy:
    helmfile repos
    helmfile apply
    helmfile test
    kubens {{ name }}

_delete-cluster:
    kind delete cluster --name {{ name }}
