import os
import shutil
import sys
from datetime import datetime
from pathlib import Path


def make_backup(target_path: Path, current_date: str, dry_run: bool):
    """
    Creates a dated backup of the target file or directory.
    If a backup with the same name exists, it appends a counter.
    """
    if not target_path.exists():
        print(f"  Warning: Cannot backup '{target_path.name}' as it does not exist.")
        return

    backup_base_name = f"{target_path.name}-backup-{current_date}"
    backup_path = target_path.parent / backup_base_name
    counter = 1

    while backup_path.exists():
        print(
            f"  Backup path '{backup_path.name}' already exists. Trying another path."
        )
        backup_path = target_path.parent / f"{backup_base_name}-{counter}"
        counter += 1

    print(f"  Moving '{target_path.name}' to '{backup_path.name}'")
    if not dry_run:
        try:
            shutil.move(str(target_path), str(backup_path))
        except OSError as e:
            print(f"  Error backing up '{target_path}': {e}", file=sys.stderr)


def create_symlink(source: Path, target: Path, dry_run: bool, is_directory: bool):
    """
    Creates a symbolic link from source to target. Handles existing links and non-existent targets.
    """
    # Ensure the parent directory of the target exists
    if not target.parent.exists():
        print(f"  Parent directory '{target.parent}' does not exist, creating it.")
        if not dry_run:
            try:
                target.parent.mkdir(parents=True, exist_ok=True)
            except OSError as e:
                print(
                    f"  Error creating parent directory '{target.parent}': {e}",
                    file=sys.stderr,
                )
                return False

    should_create_link = False

    if target.is_symlink():
        # Check if the existing symlink points to the correct location
        try:
            resolved_link = (
                target.resolve()
            )  # This also handles broken symlinks by raising FileNotFoundError
        except FileNotFoundError:
            # Broken symlink
            print(f"  '{target.name}' is a broken symbolic link. Deleting.")
            if not dry_run:
                try:
                    target.unlink()
                except OSError as e:
                    print(
                        f"  Error deleting broken symlink '{target}': {e}",
                        file=sys.stderr,
                    )
                    return False
            should_create_link = True
        else:
            if resolved_link != source.resolve():
                print(
                    f"  '{target.name}' is a symbolic link but points to wrong location. Deleting."
                )
                if not dry_run:
                    try:
                        target.unlink()
                    except OSError as e:
                        print(
                            f"  Error deleting incorrect symlink '{target}': {e}",
                            file=sys.stderr,
                        )
                        return False
                should_create_link = True
            else:
                print(f"  '{target.name}' is already correct symbolic link - Skipping.")
                return True  # Link is already correct
    elif target.exists():
        # Target exists but is not a symlink, so back it up
        print(
            f"  '{target.name}' already exists and isn't a symbolic link, attempting to make backup."
        )
        make_backup(target, datetime.now().strftime("%Y%m%d"), dry_run)
        should_create_link = True
    else:
        # Target does not exist, so we should create the link
        print(f"  '{target.name}' does not exist.")
        should_create_link = True

    if should_create_link:
        print(f"  Creating symbolic link for '{target.name}' (source: '{source}')")
        if not dry_run:
            try:
                # On Windows, target_is_directory=True is crucial for directory symlinks.
                # For files, it defaults to False which is correct.
                # It's safer to always explicitly pass it.
                target.symlink_to(source, target_is_directory=is_directory)
                print(f"  Successfully created symlink: {target} -> {source}")
            except PermissionError:
                print(
                    f"  Permission denied: Could not create symbolic link '{target}' to '{source}'.",
                    file=sys.stderr,
                )
                print(
                    "  On Windows, you may need to run this script as administrator or enable 'Developer Mode'.",
                    file=sys.stderr,
                )
                return False
            except OSError as e:
                print(
                    f"  Error creating symbolic link '{target}' to '{source}': {e}",
                    file=sys.stderr,
                )
                return False
        return True
    return False


def link_configs(source_config_dir: Path, actual_config_dir: Path, dry_run: bool):
    """
    Links subdirectories from source_config_dir to actual_config_dir.
    """
    print("\nCreating symbolic links for .config subdirectories\n")

    if not source_config_dir.is_dir():
        print(
            f"Source config directory '{source_config_dir}' does not exist or is not a directory. Skipping.",
            file=sys.stderr,
        )
        return

    # Ensure the actual config directory exists
    if not actual_config_dir.exists():
        print(f"'{actual_config_dir}' does not exist, creating it.")
        if not dry_run:
            try:
                actual_config_dir.mkdir(parents=True, exist_ok=True)
            except OSError as e:
                print(f"Error creating '{actual_config_dir}': {e}", file=sys.stderr)
                return

    for source_config_subdir in source_config_dir.iterdir():
        if source_config_subdir.is_dir():
            target_path = actual_config_dir / source_config_subdir.name
            create_symlink(
                source_config_subdir, target_path, dry_run, is_directory=True
            )


def link_dotfiles(source_dotfiles_dir: Path, home_dir: Path, dry_run: bool):
    """
    Links .dotfile files from source_dotfiles_dir to the home directory.
    """
    print("\nCreating symbolic links for HOME dotfiles\n")

    if not source_dotfiles_dir.is_dir():
        print(
            f"Source dotfiles directory '{source_dotfiles_dir}' does not exist or is not a directory. Skipping.",
            file=sys.stderr,
        )
        return

    for source_dotfile in source_dotfiles_dir.glob("*.dotfile"):
        if source_dotfile.is_file():
            # Convert 'somefile.dotfile' to '.somefile'
            home_dotfile_name = (
                f".{source_dotfile.stem}"  # .stem gets the name without suffix
            )
            home_dotfile_path = home_dir / home_dotfile_name
            create_symlink(
                source_dotfile, home_dotfile_path, dry_run, is_directory=False
            )


def main():
    """Main function to parse arguments and orchestrate symlink creation."""
    home_dir = Path.home()
    actual_config_dir = home_dir / ".config"

    if len(sys.argv) < 2:
        print(
            "Usage: python create_symlinks.py /path/to/source-config [--dry-run]",
            file=sys.stderr,
        )
        sys.exit(1)

    source_dir_arg = Path(sys.argv[1])

    if not source_dir_arg.exists():
        print(f"Source directory '{source_dir_arg}' does not exist.", file=sys.stderr)
        sys.exit(1)
    if not source_dir_arg.is_dir():
        print(f"Source '{source_dir_arg}' is not a directory.", file=sys.stderr)
        sys.exit(1)

    source_dir = source_dir_arg.resolve()  # Get the absolute, resolved path

    dry_run = False
    if len(sys.argv) > 2 and sys.argv[2] == "--dry-run":
        dry_run = True
        print("Running in dry run mode. No changes will be made.")
        print("-" * 50)  # Separator for dry run message

    source_config_dir = source_dir / ".config"
    source_dotfiles_dir = (
        source_dir / "HOME"
    )  # Assuming 'HOME' directory contains dotfiles

    link_configs(source_config_dir, actual_config_dir, dry_run)
    link_dotfiles(source_dotfiles_dir, home_dir, dry_run)

    if dry_run:
        print("\n" + "-" * 50)
        print("Dry run complete. No changes were made.")


if __name__ == "__main__":
    main()
