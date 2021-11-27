# portfolio

![screenshot](./screenshot.png)

This repository contains the source code of the website to show my technical
skillsets and expertise.

## Requirements

- [Gawk][gawk-link]
- [Grep][grep-link]
- [Findutils][findutils-link]
- [asdf][asdf-link]
- [Docker][docker-link]

## Development Setup

Preview and edit the website on local machine as follows:

1. [Clone this repository on local machine][gh-clone-link]
1. Go to the project root directory of this repository in terminal
1. Run [`./scripts/install-packages.bash`][script-link] to install packages via
   [asdf][asdf-link]
1. Run `just` to start the server of [Aleph.js][alephjs-link] in `development`
   mode
1. Open <http://localhost:8080/> in browser
1. After done with the preview, press Ctrl-C in terminal to stop the server.

While the preview is running, edit tsx and css files and will automatically
rebuild them.

## Test

Run `just check` to lint and format the source code with
[pre-commit][pre-commit-link].

## Containerize

1. Run `just build` to build docker image of [nginx][nginx-link] with
   [Cloud Native Buildpacks][cnb-link]
1. Run `just start` to start the server of [nginx][nginx-link] in `production`
   mode
1. Open <http://localhost:8080/> in browser
1. After done with the preview, press Ctrl-C in terminal to stop the server.
1. Run `just publish` to push docker image to
   [GitHub Container Registry][ghcr-link]

## Update

Run `just update` to update dependency packages and pre-commit hooks.

## List

Run `just --list` to list available commands in command runner.

## License

This repository is licensed under the MIT license. See the
[LICENSE.txt](./LICENSE.txt) file for details.

[gawk-link]: https://www.gnu.org/software/gawk/
[grep-link]: https://www.gnu.org/software/grep/
[findutils-link]: https://www.gnu.org/software/findutils/
[asdf-link]: https://asdf-vm.com/
[docker-link]: https://www.docker.com/
[gh-clone-link]: https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories
[script-link]: ./scripts/install-packages.bash
[alephjs-link]: https://alephjs.org/
[nginx-link]: https://nginx.org/en/
[pre-commit-link]: https://pre-commit.com/
[cnb-link]: https://buildpacks.io/
[ghcr-link]: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
