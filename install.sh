#!/bin/bash

SOURCE_SUBDIR="home"
TARGET_DIR="$HOME"

# Get the absolute path to the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Define the absolute path to the source directory
SOURCE_DIR="$SCRIPT_DIR/$SOURCE_SUBDIR"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory '$SOURCE_DIR' not found."
  exit 1
fi

echo "Starting dotfile symlinking process..."
echo "Source directory: $SOURCE_DIR"
echo "Target directory: $TARGET_DIR"
echo "---"

# Change to the source directory to easily find files relative to it
cd "$SOURCE_DIR" || exit 1

# Find all files (not directories) within the source directory
# -print0 and read -d are used to handle filenames with spaces or special characters
find . -type f -print0 | while IFS= read -r -d $'\0' file; do
  # Remove the leading './' from the found file path
  relative_file="${file#./}"

  # Construct the absolute path to the original file
  source_path="$SOURCE_DIR/$relative_file"

  # Construct the target path in the home directory
  target_path="$TARGET_DIR/$relative_file"

  # Get the directory part of the target path
  target_file_dir=$(dirname "$target_path")

  # Check if the target location already exists (as a file or symlink)
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    # Check if it's already a symlink pointing to the correct source
    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
      echo "Skipping: Link already exists and is correct: '$target_path' -> '$source_path'"
    else
      echo "Warning: Target already exists (and is not the correct link): '$target_path'. Skipping."
    fi
    continue # Skip to the next file
  fi

  # Create the target directory structure if it doesn't exist
  echo "Creating directory (if needed): '$target_file_dir'"
  mkdir -p "$target_file_dir"
  if [ $? -ne 0 ]; then
      echo "Error: Failed to create directory '$target_file_dir'. Skipping file '$relative_file'."
      continue
  fi

  # Create the symbolic link
  echo "Linking: '$target_path' -> '$source_path'"
  ln -s "$source_path" "$target_path"
  if [ $? -ne 0 ]; then
      echo "Error: Failed to create symlink for '$relative_file'."
  fi

  echo "---"
done

# Change back to the original directory (optional, but good practice)
cd "$SCRIPT_DIR"

echo "Dotfile symlinking process complete."

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-key-bindings --no-completion --no-update-rc

./scripts/vim_plugins.sh

if [ -n "${CODESPACE_NAME}" ]; then
    ./scripts/codespaces.sh
fi
