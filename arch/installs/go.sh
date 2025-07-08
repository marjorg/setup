#!/bin/bash

PACMAN_PACKAGES+=(
  go
)

post_install() {
  go install golang.org/x/tools/gopls@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  go install github.com/air-verse/air@latest
  go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
}

# golangci-lint run

# .air.toml
# [build]
# cmd = "go build -o ./tmp/main ."
# bin = "./tmp/main"
# include_ext = ["go", "tpl", "tmpl", "html"]
