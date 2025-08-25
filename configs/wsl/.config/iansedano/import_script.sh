import_script() {
  local script_path="$1"

  if [ -z "$script_path" ]; then
    printf "Error: import_script requires a path argument.\n" >&2
    return 1
  fi

  local resolved_path
  if command -v realpath &>/dev/null; then
    resolved_path=$(realpath "$script_path")
  elif command -v readlink &>/dev/null && [ "$(uname)" == "Linux" ]; then
    resolved_path=$(readlink -f "$script_path")
  else
    resolved_path="$script_path"
  fi

  if [ ! -f "$resolved_path" ]; then
    printf "Warning: '%s' (resolved from '%s') not found or is not a regular file. Skipping import.\n" "$resolved_path" "$script_path" >&2
    return 1
  fi

  if [ ! -s "$resolved_path" ]; then
    printf "Warning: '%s' is an empty file. Skipping import.\n" "$resolved_path" >&2
    return 1
  fi

  # All checks passed, source the script
  source "$resolved_path"
  printf "Info: Successfully imported '%s'.\n" "$script_path"
  return 0
}
