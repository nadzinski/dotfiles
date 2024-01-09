# Git aliases
alias gcb="git checkout -b"
alias gpu="git push -u origin \$(git rev-parse --abbrev-ref HEAD)"
alias gps-sre-tune="git push -f origin \$(git rev-parse --abbrev-ref HEAD):staging-sre-tune"

export PRE_COMMIT_ENABLED=true
