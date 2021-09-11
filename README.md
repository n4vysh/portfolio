# portfolio

## Requirements

* asdf
* pre-commit
* docker
* Chromium for lighthouse

```bash
awk '{print $1}' .tool-versions |
  grep -v 'just' |
  xargs -I {} asdf plugin add {}
asdf plugin add just https://github.com/heliumbrain/asdf-just
asdf install
just init
```

## Usage

```bash
just
```
