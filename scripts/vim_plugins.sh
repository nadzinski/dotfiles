git config --global core.editor vim

mkdir -p ~/.vim/

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

mkdir -p ~/.vim/colors

curl -LSso ~/.vim/colors/badwolf.vim https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim

# Function to clone vim plugin if it doesn't exist
clone_vim_plugin() {
  # Get the last argument (the URL)
  local url="${@: -1}"
  local plugin_name=$(basename "$url" .git)

  if [ ! -d ~/.vim/bundle/"$plugin_name" ]; then
    echo "Cloning vim plugin: $plugin_name..."
    git -C ~/.vim/bundle clone "$@"
  else
    echo "Skipping: vim plugin $plugin_name already exists"
  fi
}

clone_vim_plugin https://tpope.io/vim/fugitive.git
clone_vim_plugin https://tpope.io/vim/commentary.git
clone_vim_plugin --depth=1 https://github.com/vim-syntastic/syntastic.git
clone_vim_plugin https://github.com/junegunn/fzf.vim
clone_vim_plugin https://github.com/ojroques/vim-oscyank.git
# clone_vim_plugin https://github.com/fisadev/vim-isort.git
clone_vim_plugin https://github.com/leafgarland/typescript-vim.git
