#!/bin/bash

install() {
  curl -fsS https://dl.brave.com/install.sh | sh
  curl -fsSL https://bun.sh/install | bash
  curl -f https://zed.dev/install.sh | sh
}
