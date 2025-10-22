if [[ -f /workspaces/web/profile ]]; then . /workspaces/web/profile; fi

# Git aliases
alias gcb="git checkout -b"
alias gpu="git push -u origin \$(git rev-parse --abbrev-ref HEAD)"
alias gps-sre-tune="git push -f origin \$(git rev-parse --abbrev-ref HEAD):staging-sre-tune"

# Codespaces-specific aliases and setup
if [[ "$CODESPACES" == "true" ]]; then
    alias dotfiles="cd /workspaces/.codespaces/.persistedshare/dotfiles"

    # Add GitHub to known_hosts to avoid interactive prompt
    if [ ! -f "$HOME/.ssh/known_hosts" ] || ! grep -q "github.com" "$HOME/.ssh/known_hosts"; then
        mkdir -p "$HOME/.ssh"
        ssh-keyscan github.com 2>/dev/null | sudo tee -a "$HOME/.ssh/known_hosts" >/dev/null
    fi

    # Clone agents-mem if not already cloned (SSH is available in shell sessions)
    if [ ! -d "$HOME/.agents-mem/.git" ]; then
        (git clone git@github.com:nadzinski/agents-mem.git ~/.agents-mem &>/dev/null &)
    fi
fi

alias run-mypy="dc run --workdir /web --rm --no-deps web mypy --show-error-codes src/aplaceforrover"

alias runblack="git status -s | grep -e ' M ' -e '?? ' | cut -c4- | xargs black --config ./pyproject.toml"
alias runisort="git status -s | grep -e ' M ' -e '?? ' | cut -c4- | xargs isort --settings ./pyproject.toml"

# export PRE_COMMIT_ENABLED=true
#
#
#

function install_roverform {
    mkdir -p $HOME/.aws/cli
    mkdir -p $HOME/.local/bin
    image="${ROVERFORM_IMAGE_REPO:-ghcr.io/roverdotcom/roverform}:${ROVERFORM_IMAGE_TAG:-latest}"
    docker pull $image
    container=$(docker create $image)
    docker cp $container:/roverform/bin/roverform $HOME/.local/bin/roverform
    ln -nfs ./roverform ~/.local/bin/rf
    docker rm -f $container
}
