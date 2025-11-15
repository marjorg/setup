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

post_install() {
  go install golang.org/x/tools/gopls@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install github.com/nametake/golangci-lint-langserver@latest
  go install github.com/air-verse/air@latest
  go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
  go install github.com/pressly/goose/v3/cmd/goose@latest
  go install golang.org/x/tools/cmd/stringer@latest
}

# golangci-lint run

# .air.toml
# [build]
# cmd = "go build -o ./tmp/main ."
# bin = "./tmp/main"
# include_ext = ["go", "tpl", "tmpl", "html"]
