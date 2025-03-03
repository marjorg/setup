#!/bin/bash

VAULT_ID="$1"

op item get "$VAULT_ID" --fields password --reveal
