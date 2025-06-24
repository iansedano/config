#!/bin/bash

SCRIPT_PATH=$(realpath "$0")

if [ "$EUID" -ne 0 ]; then
  echo "Switching to root..."
  sudo "$SCRIPT_PATH" "$@" # Re-run the script with sudo and pass all arguments
  exit $?                  # Exit with the status code from the sudo command
fi

echo "Running as root..."

VENDOR_ID="0bda"
PRODUCT_ID="b812"

usb_modeswitch -R -v $VENDOR_ID -p $PRODUCT_ID
