#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '(.cost.total_cost_usd | tonumber * 100 | round / 100 | tostring)' | awk '{printf "%.2f", $1}')

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" | 🌿 $BRANCH"
    fi
fi

# Show codespace name if in a codespace (strip random suffix)
# CODESPACE_INFO=""
# if [ -n "$CODESPACE_NAME" ]; then
#     # Remove the random suffix (everything after the last hyphen followed by alphanumeric chars)
#     CODESPACE_DISPLAY=$(echo "$CODESPACE_NAME" | sed 's/-[a-z0-9]*$//')
#     CODESPACE_INFO=" | 🚀 $CODESPACE_DISPLAY"
# fi
CODESPACE_INFO=""

# Show warning if exceeding 200k tokens
TOKEN_WARNING=""
EXCEEDS_200K=$(echo "$input" | jq -r '.exceeds_200k_tokens')
if [ "$EXCEEDS_200K" = "true" ]; then
    TOKEN_WARNING=" | ⚠️ >200k"
fi

# Only show emoji prefix in non-VS Code terminals
EMOJI_PREFIX=""
if [ "$TERM_PROGRAM" != "vscode" ]; then
    # EMOJI_PREFIX="🕵🏻‍♀️👩🏻‍💻 "
    EMOJI_PREFIX="👩🏻‍💻 "
fi

echo "${EMOJI_PREFIX}${TOKEN_WARNING}[🤖 $MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}$GIT_BRANCH$CODESPACE_INFO | 💸 \$$COST"
