# Install neovim. We must do this manually as the latest version of the package registry is outdated.
curl -fsLSO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
chmod 755 nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
mv squashfs-root $HOME/.nvim
rm nvim-linux-x86_64.appimage
mkdir -p $HOME/.local/bin
ln -sf "$HOME/.nvim/usr/bin/nvim" "$HOME/.local/bin"

sudo apt update && sudo apt install silversearcher-ag

# Switch dotfiles repo to SSH to avoid HTTPS token permission issues
cd /workspaces/.codespaces/.persistedshare/dotfiles
git remote set-url origin git@github.com:nadzinski/dotfiles.git

cd /workspaces/*/
if [ -f ".mcp-sample.json" ]; then
    cp .mcp-sample.json .mcp.json
fi
#
# function write_aws_saml_credentials {
#     if [[ ! -z "${ROVER_AWS_SAML_HELPER_CREDENTIALS:-}" ]]; then
#         mkdir -p $HOME/.aws
#         echo $ROVER_AWS_SAML_HELPER_CREDENTIALS | base64 -d > $HOME/.aws/credentials
#     fi
# }
# # Write credentials on load if possible
# write_aws_saml_credentials
