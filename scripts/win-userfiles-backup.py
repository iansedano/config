"""
Backup the Windows user directory to dropbox

Files at root level of user dir are ignored
"""

from pathlib import Path
import shutil
from datetime import datetime

POSSIBLE_DROPBOX_LOCATIONS = ["C:/Dropbox", "D:/Dropbox"]
USER_DIR = Path("C:/Users/ianse")


EXCLUDE = list(
    map(
        lambda p: USER_DIR / Path(p),
        [
            "scoop/apps",
            "scoop/cache",
            "scoop/buckets",
            "scoop/shims",
            "scoop/persist/vscode",
            "scoop/persist/googlechrome",
            "scoop/persist/manictime",
            # "scoop/persist/idea",
            "scoop/persist/mysql",
            "scoop/persist/nvm",
            "scoop/persist/vlc",
            "scoop/persist/maven",
            "scoop/persist/gradle",
            "scoop/persist/7zip",
            "scoop/persist/bulk-crap-uninstaller",
            "scoop/persist/everything",  # empty
            "scoop/persist/ffmpeg",
            "scoop/persist/filezilla",
            "scoop/persist/paint.net",
            "scoop/persist/idea/profile/system/index",
            "scoop/persist/sublime-text/Data/Cache",
            "Downloads",
            "AppData/Local",
            "AppData/LocalLow",
            "AppData/Roaming/Signal",
            "AppData/Roaming/Zoom",
            "AppData/Roaming/TimeBolt",
            "AppData/Roaming/DropboxElectron",
            "AppData/Roaming/Python",
            "AppData/Roaming/Microsoft",
            "AppData/Roaming/Dropbox",
            "AppData/Roaming/Tracker Software",
            "AppData/Roaming/NuGet",
            "AppData/Roaming/JetBrains",
            "AppData/Roaming/Adobe",
            "AppData/Roaming/NVIDIA",
            "AppData/Roaming/sourcery",
            ".pyenv",
            "OneDrive",
            ".jdks",
            ".jabba",
            ".ipython",
            ".ssh",
            ".m2",
            "Links",
            "Searches",
            ".mume",
            "Videos",
            "Favorites",
            "Music",
            "Contacts",
            "3D Objects",
            "Saved Games",
            ".local/share/manictime",
            ".config/scoop",
            ".android",
            "Application Data",
            "Cookies",
            "Documents",
            "Local Settings",
            "My Documents",
            "NetHood",
            "PrintHood",
            "Recent",
            "SendTo",
            "Templates",
            "Start Menu",
        ],
    )
)

# EXLUDE_PATTERNS = ["cache", "__pycache__"]


for loc in POSSIBLE_DROPBOX_LOCATIONS:
    dropbox_location = Path(loc)
    if dropbox_location.exists():
        break

if not dropbox_location.exists():
    raise SystemExit("No dropbox location detected")

BACKUP_FOLDER = dropbox_location / Path(
    f"backups/{USER_DIR.stem + datetime.now().strftime(r'%Y%m%d')}"
)
BACKUP_FOLDER.mkdir()


def get_all_items(
    root: Path,
    include_files=True,
    include_dirs=True,
    include_files_at_root=True,
    exclude=EXCLUDE,
):
    for item in root.iterdir():
        if item in exclude:
            continue
        if item.is_dir():
            if include_dirs:
                yield item
            yield from get_all_items(
                item,
                include_files=include_files,
                include_dirs=include_dirs,
                include_files_at_root=include_files,
            )
        elif include_files and include_files_at_root:
            yield item


# from pprint import pp as print
shutil.rmtree(BACKUP_FOLDER)

for file in get_all_items(USER_DIR, include_dirs=False, include_files_at_root=True):
    files_not_found = []
    permission_error = []
    print("/".join(file.parts[3:]))
    try:
        new_path = BACKUP_FOLDER / file.relative_to(USER_DIR)
        new_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(file, BACKUP_FOLDER / file.relative_to(USER_DIR))
    except FileNotFoundError:
        print("file not found")
        files_not_found.append(file)
    except PermissionError:
        print("permission error")
        permission_error.append(file)

print(f"{files_not_found = }")
print(f"{permission_error = }")
