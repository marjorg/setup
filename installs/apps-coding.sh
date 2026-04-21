#!/bin/bash

YAY_PACKAGES+=(
  visual-studio-code-bin
  sublime-text-4
  tableplus
  postman-bin
  hoppscotch-bin
  redisinsight-bin
)

PACMAN_PACKAGES+=(
  zed
  intellij-idea-community-edition
)

if ! $WORK; then
  YAY_PACKAGES+=(
    rider
  )
fi

VSCODE_EXTENSIONS+=(
  enkia.tokyo-night
  golang.go
  mhutchie.git-graph
  bradlc.vscode-tailwindcss
  oderwat.indent-rainbow
  aaron-bond.better-comments
  usernamehw.errorlens
  ms-python.python
  sumneko.lua
  biomejs.biome
  mechatroner.rainbow-csv
  vstirbu.vscode-mermaid-preview
)

if ! $WORK; then
  VSCODE_EXTENSIONS+=(
    ms-dotnettools.csdevkit
    visualstudiotoolsforunity.vstuc
  )
fi
