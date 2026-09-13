#!/bin/bash
# Prints the using-agent-skills meta skill so a harness can add it to
# session context. Claude Code appends SessionStart stdout to context.
# OpenCode reads the same file via "instructions" in opencode.json.
cat "$(dirname "$(readlink -f "$0")")/../skills/using-agent-skills/SKILL.md"
