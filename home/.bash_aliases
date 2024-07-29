if [[ -f /workspaces/web/profile ]]; then . /workspaces/web/profile; fi

# Git aliases
alias gcb="git checkout -b"
alias gpu="git push -u origin \$(git rev-parse --abbrev-ref HEAD)"
alias gps-sre-tune="git push -f origin \$(git rev-parse --abbrev-ref HEAD):staging-sre-tune"

alias run-mypy="dc run --workdir /web --rm --no-deps web mypy --show-error-codes src/aplaceforrover"

alias runblack="git status -s | grep -e ' M ' -e '?? ' | cut -c4- | xargs black --config ./pyproject.toml"
alias runisort="git status -s | grep -e ' M ' -e '?? ' | cut -c4- | xargs isort --settings ./pyproject.toml"

# export PRE_COMMIT_ENABLED=true
