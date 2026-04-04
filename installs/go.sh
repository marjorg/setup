#!/bin/bash

MISE_PACKAGES+=(
  go@latest
)

PACMAN_PACKAGES+=(
  golangci-lint
)

YAY_PACKAGES+=(
  gomplate-bin # Used for config files generation
)

GO_PACKAGES=(
  golang.org/x/tools/gopls@latest
  github.com/go-delve/delve/cmd/dlv@latest
  github.com/nametake/golangci-lint-langserver@latest
  github.com/air-verse/air@latest
  github.com/sqlc-dev/sqlc/cmd/sqlc@latest
  github.com/pressly/goose/v3/cmd/goose@latest
  golang.org/x/tools/cmd/stringer@latest
)

# golangci-lint run

# .air.toml
# [build]
# cmd = "go build -o ./tmp/main ."
# bin = "./tmp/main"
# include_ext = ["go", "tpl", "tmpl", "html"]
