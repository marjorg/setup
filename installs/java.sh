#!/bin/bash

MISE_PACKAGES+=(
  java@24 # Kotlin doesn't support 25 for most recent (2.2 atm)
  kotlin@latest
)
