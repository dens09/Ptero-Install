#!/bin/bash

set -e

######################################################################################
# Standalone Enigma theme installer for Pterodactyl Panel
# Usage: bash <(curl -s https://raw.githubusercontent.com/dens09/Ptero-Install/main/install-theme.sh)
######################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

export GITHUB_BASE_URL="${GITHUB_BASE_URL:-https://raw.githubusercontent.com/dens09/Ptero-Install}"
export GITHUB_SOURCE="${GITHUB_SOURCE:-main}"
export PANEL_PATH="${PANEL_PATH:-/var/www/pterodactyl}"
export THEME_DL_URL="${THEME_DL_URL:-https://github.com/dens09/Ptero-Install/releases/download/enigma/THEME.zip}"
export THEME_NODE_MAJOR="${THEME_NODE_MAJOR:-16}"

[ -f "$SCRIPT_DIR/custom-config.sh" ] && source "$SCRIPT_DIR/custom-config.sh"
curl -fsSL -o /tmp/custom-config.sh "$GITHUB_BASE_URL/$GITHUB_SOURCE/custom-config.sh" 2>/dev/null \
  && source /tmp/custom-config.sh

LOG_PATH="/var/log/pterodactyl-installer-theme.log"

if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required."
  exit 1
fi

[ -f /tmp/lib.sh ] && rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_BASE_URL/$GITHUB_SOURCE/lib/lib.sh"
# shellcheck source=lib/lib.sh
source /tmp/lib.sh

echo -e "\n\n* theme-installer $(date) \n\n" >>"$LOG_PATH"
run_ui "theme" |& tee -a "$LOG_PATH"
rm -rf /tmp/lib.sh
