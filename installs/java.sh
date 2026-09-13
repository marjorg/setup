#!/bin/bash

MISE_PACKAGES+=(
  java@25
  kotlin@latest
  gradle@latest
  maven@latest
)

# The Zed Kotlin extension downloads kotlin-lsp from JetBrains' RELEASES.md,
# which JetBrains keeps forgetting to update. The build is an EAP with a 40-day
# expiry, so when that file goes stale every machine gets "This build of
# intellij-server has expired". The AUR package tracks the fresh releases
# instead; Zed is pointed at it in home/.config/zed/settings.json.
# See https://github.com/Kotlin/kotlin-lsp/issues/271
YAY_PACKAGES+=(
  kotlin-lsp-bin
)
