# portfolio

## Requirements

- asdf
- docker

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
