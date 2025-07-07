#!/bin/bash

post_install() {
  if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
  fi
}
