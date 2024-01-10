if [[ -f /workspaces/web/profile ]]; then . /workspaces/web/profile; fi

# Git aliases
alias gcb="git checkout -b"
alias gpu="git push -u origin \$(git rev-parse --abbrev-ref HEAD)"
alias gps-sre-tune="git push -f origin \$(git rev-parse --abbrev-ref HEAD):staging-sre-tune"

alias run-mypy="dc run --workdir /web --rm --no-deps web mypy --show-error-codes src/aplaceforrover"

# export PRE_COMMIT_ENABLED=true
