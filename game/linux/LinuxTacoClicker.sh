#!/bin/sh
printf '\033c\033]0;%s\a' Taco Clicker
base_path="$(dirname "$(realpath "$0")")"
"$base_path/LinuxTacoClicker.x86_64" "$@"
