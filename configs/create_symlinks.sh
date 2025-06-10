#!/bin/bash

# This will then create symlinks in your home directory to the files in the
# desktop directory.
#
# It will symlink the `.dotfile` files to the `HOME` directory, and the
# `.config` sub-directories.
#
# You can run the script with the `--dry-run` flag to see what it will do
# without actually doing it.
#
# Example:
#   ./create_symlinks.sh /path/to/source-config --dry-run

ACTUAL_CONFIG_DIR="$HOME/.config"

SOURCE_DIR="$1"
if [ -z "$SOURCE_DIR" ]; then
  echo "No source directory specified, exiting."
  exit 1
elif [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory $SOURCE_DIR does not exist or is not a directory, exiting."
  exit 1
fi
SOURCE_DIR=$(realpath "$SOURCE_DIR")

DRY_RUN=false
if [ "$2" == "--dry-run" ]; then
  DRY_RUN=true
  echo "Running in dry run mode. No changes will be made."
fi

if [ ! -d "$ACTUAL_CONFIG_DIR" ]; then
  echo "$ACTUAL_CONFIG_DIR does not exist, creating it."
  [ "$DRY_RUN" = false ] && mkdir -p "$ACTUAL_CONFIG_DIR"
fi

SOURCE_CONFIG_DIR="$SOURCE_DIR/.config"
SOURCE_DOTFILES_DIR="$SOURCE_DIR/HOME"
current_date=$(date +"%Y%m%d")

function make_backup() {
  local target=$1
  local backup_path="$target-backup-$current_date"
  local counter=1
  while [ -d "$backup_path" ] || [ -f "$backup_path" ]; do
    echo "Backup path $backup_path already exists. Trying another path."
    backup_path="backup_path-$counter"
    counter=$((counter + 1))
  done

  echo "Moving $(basename "$target") to $(basename "$backup_path")"
  [ "$DRY_RUN" = false ] && mv "$target" "$backup_path"
}

printf "\nCreating symbolic links for .config subdirectories\n\n"

for source_config_subdir in "$SOURCE_CONFIG_DIR"/*; do
  if [ -d "$source_config_subdir" ]; then
    dirname=$(basename "$source_config_subdir")
    target_path="$ACTUAL_CONFIG_DIR/$dirname"

    if [ -d "$target_path" ] && [ ! -L "$target_path" ]; then
      echo "$target_path already exists and isn't a symbolic link, attempting to make backup."
      make_backup "$target_path"
    fi

    should_create_link=false

    if [ -L "$target_path" ] && [ "$(readlink -f "$target_path")" != "$source_config_subdir" ]; then
      echo "$(basename "$target_path") is link but points to wrong location. Deleting."
      [ "$DRY_RUN" = false ] && rm -rf "$target_path"
      should_create_link=true
    elif [ ! -L "$target_path" ]; then
      echo "$(basename "$target_path") does not exist."
      should_create_link=true
    elif [ "$(readlink -f "$target_path")" = "$source_config_subdir" ]; then
      echo "$(basename "$target_path") is already correct symbolic link - Skipping."
    fi

    if [ "$should_create_link" = true ]; then
      echo "Creating symbolic link for $dirname"
      [ "$DRY_RUN" = false ] && ln -sfn "$source_config_subdir" "$target_path"
    fi
  fi
done

printf "\nCreating symbolic links for HOME dotfiles\n\n"

for source_dotfile in "$SOURCE_DOTFILES_DIR"/*.dotfile; do

  if [ -f "$source_dotfile" ]; then
    home_dotfile=".$(basename "$source_dotfile" .dotfile)"
    home_dotfile_path="$HOME/$home_dotfile"

    if [ -f "$home_dotfile_path" ] && [ ! -L "$home_dotfile_path" ]; then
      echo "$home_dotfile already exists and isn't a symbolic link, attempting to make backup."
      make_backup "$home_dotfile_path"
    fi

    if [ -L "$home_dotfile_path" ] && [ "$(readlink -f "$home_dotfile_path")" != "$source_dotfile" ]; then
      echo "$home_dotfile is a symbolic link but points to wrong location. Deleting."
      [ "$DRY_RUN" = false ] && rm "$home_dotfile_path"
      echo "Creating symbolic link for $home_dotfile"
      [ "$DRY_RUN" = false ] && ln -sfn "$source_dotfile" "$home_dotfile_path"
    elif [ ! -e "$home_dotfile_path" ]; then
      echo "Creating symbolic link for $home_dotfile"
      [ "$DRY_RUN" = false ] && ln -sfn "$source_dotfile" "$home_dotfile_path"
    else
      echo "$home_dotfile is already correct symbolic link - Skipping."
    fi
  fi
done
