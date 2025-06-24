#!/usr/bin/python

"""
This script follows the Python convention of using the terms:

- Target: The file or directory that the symlink points to.
- Link: The symlink itself, which is a pointer to the target.
"""

import logging
import os
import sys
from datetime import datetime
from pathlib import Path

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
log = logging.getLogger(__name__)


def main():
    """Main function to parse arguments and orchestrate symlink creation."""
    if len(sys.argv) < 2:
        log.error(
            f"Usage: python {sys.argv[0]} /path/to/dotfiles-repository [--dry-run]",
        )
        raise SystemExit(1)

    try:
        target_dir = Path(sys.argv[1]).resolve(strict=True)
    except FileNotFoundError:
        log.error(f"Source directory '{sys.argv[1]}' does not exist.")
        raise SystemExit(1)

    if not target_dir.is_dir():
        log.error(f"Source '{target_dir}' is not a directory.")
        raise SystemExit(1)

    dry_run = "--dry-run" in sys.argv[2:]
    if dry_run:
        log.info("--- Running in dry run mode. No changes will be made. ---")

    target_config_dir = target_dir / ".config"
    target_home_dir = target_dir

    # Creates symbolic links for subdirectories in the .config directory
    create_subdirectory_links(target_config_dir, get_user_config_dir(), dry_run)
    # Creates symbolic links for files but not directories in the home directory
    create_file_links(target_home_dir, Path.home(), dry_run)

    if dry_run:
        log.info("\n--- Dry run complete. No changes were made. ---")


def create_subdirectory_links(
    target_config_dir: Path, home_config_dir: Path, dry_run: bool
):
    log.info(f"Creating symbolic links for {target_config_dir} subdirectories\n")

    if not target_config_dir.is_dir():
        log.error(
            f"Source config directory '{target_config_dir}' does not exist. Skipping."
        )
        return

    for target_dir in target_config_dir.iterdir():
        if target_dir.is_dir():
            link_path = home_config_dir / target_dir.name
            create_symlink(target_dir, link_path, dry_run)


def create_file_links(target_dir: Path, link_dir: Path, dry_run: bool):
    if not target_dir.is_dir():
        raise FileNotFoundError(f"Source directory '{target_dir}' does not exist.")

    for target_file in target_dir.iterdir():
        if not target_file.is_file():
            continue
        link_path = link_dir / target_file.name
        create_symlink(target_file, link_path, dry_run)


def create_symlink(target_path: Path, link_path: Path, dry_run: bool):
    """
    Creates a symbolic link from target_path to link_path.
    Handles existing files or links at the target location.
    """
    ensure_parent_directory_exists(link_path, dry_run)

    if link_path.exists() and not link_path.is_symlink():
        log.warning(f"'{link_path}' exists and is not a symlink. Backing it up.")
        current_date = datetime.now().strftime("%Y-%m-%d")
        make_backup(link_path, current_date, dry_run)

    if not can_create_symlink(target_path, link_path):
        return

    if link_path.is_symlink():
        log.info(f"Removing existing symlink at '{link_path}'")
        if not dry_run:
            link_path.unlink()

    log.info(f"Creating symbolic link: '{link_path}' -> '{target_path}'")

    if dry_run:
        log.info(f"[Dry run] Would create symlink: {link_path} -> {target_path}")
        return

    try:
        link_path.symlink_to(target_path, target_is_directory=target_path.is_dir())
        log.info(f"Successfully created symlink: {link_path} -> {target_path}")
    except PermissionError:
        log.error(
            f"Permission denied: Could not create symbolic link '{link_path}' to '{target_path}'.",
        )
        log.info(
            "  On Windows, you may need to run this script as administrator or enable 'Developer Mode'.",
        )
    except OSError as e:
        log.error(
            f"Error creating symbolic link '{link_path}' to '{target_path}': {e}",
        )


def get_user_config_dir() -> Path:
    home = Path.home()

    xdg_config_home = os.getenv("XDG_CONFIG_HOME")
    if xdg_config_home:
        return Path(xdg_config_home)

    return home / ".config"


def make_backup(path_to_backup: Path, current_date: str, dry_run: bool):
    """
    Creates a dated backup of the given file or directory.
    If a backup with the same name exists, it appends a counter.
    """
    if not path_to_backup.exists():
        log.error(f"Cannot backup '{path_to_backup.name}' as it does not exist.")
        return

    backup_base_name = f"{path_to_backup.name}-backup-{current_date}"
    backup_path = path_to_backup.parent / backup_base_name
    counter = 1

    while backup_path.exists():
        log.info(
            f"Backup path '{backup_path.name}' already exists. Trying another path."
        )
        backup_path = path_to_backup.parent / f"{backup_base_name}-{counter}"
        counter += 1

    log.info(f"Moving '{path_to_backup.name}' to '{backup_path.name}'")
    if dry_run:
        log.info(f"[Dry run] Would move: {path_to_backup} -> {backup_path}")
        return

    try:
        path_to_backup.rename(backup_path)
    except FileExistsError:
        log.error(
            f"Backup path '{backup_path.name}' already exists. Cannot create backup.",
        )


def ensure_parent_directory_exists(path_to_ensure: Path, dry_run: bool):
    """
    Ensures that the parent directory of the given target path exists.
    """
    if path_to_ensure.parent.exists():
        return

    log.info(f"Parent directory '{path_to_ensure.parent}' does not exist, creating it.")

    if not dry_run:
        path_to_ensure.parent.mkdir(parents=True, exist_ok=True)


def can_create_symlink(target_path: Path, link_path: Path) -> bool:
    """
    Determines if a symlink should be created based on the target and link paths.
    Returns True if a symlink should be created, False otherwise.
    """
    if not target_path.exists():
        log.error(
            f"Target '{target_path}' does not exist. Cannot create symlink.",
        )
        return False

    if not link_path.is_symlink():
        # If the link path exists and is not a symlink, it needs to be backed up.
        # This function assumes backup has already been handled.
        return True

    try:
        if link_path.resolve() == target_path.resolve():
            log.info(f"'{link_path.name}' is already a correct symlink.")
            return False

        log.info(f"'{link_path.name}' is a symlink but points to the wrong location.")
        return True
    except FileNotFoundError:
        log.info(f"'{link_path.name}' is a broken symlink.")
        return True


if __name__ == "__main__":
    main()
