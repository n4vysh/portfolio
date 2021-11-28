registry := "ghcr.io"
user := "n4vysh"
name := "portfolio"
version := "0.1.1"
image := registry + "/" + user + "/" + name + ":" + version

set dotenv-load := false

# Start the web server in `development`
dev: init
    aleph dev

# Build a static site and container image
build: init build-static-site build-container-image

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

# Build a static site
build-static-site:
    aleph build

# Build container image
build-container-image:
    pack build {{ image }} --builder paketobuildpacks/builder:base

# Start container
start: build
    docker run --rm --env-file .env -dp 8080:8080 --name {{ name }} {{ image }}

# Fetch the logs of container
logs:
    docker logs -f {{ name }}

# Stop container
stop:
    docker stop {{ name }}

# Login container registry
login:
    docker login -u {{ user }} {{ registry }}

# Push container image to registry
publish: login
    docker push {{ image }}

# Update package and hook versions
update: update-package-versions update-hooks

# Update package versions
update-package-versions:
    ./scripts/update-packages.bash

# Update hook versions
update-hooks:
    pre-commit autoupdate

# Take a screenshot
screenshot: start
    just run screenshot
    just stop
