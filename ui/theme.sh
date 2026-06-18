#!/bin/bash

set -e

######################################################################################
# UI — Enigma theme installer
######################################################################################

fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  # shellcheck source=lib/lib.sh
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_BASE_URL/$GITHUB_SOURCE"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

PANEL_PATH="${PANEL_PATH:-/var/www/pterodactyl}"

main() {
  welcome "panel"

  if [[ ! -d "${PANEL_PATH}" ]] || [[ ! -f "${PANEL_PATH}/artisan" ]]; then
    error "Pterodactyl panel not found at ${PANEL_PATH}."
    error "Install the panel first (menu option 0), then run theme installation."
    exit 1
  fi

  print_brake 62
  output "Enigma theme installer"
  output "Panel path: ${PANEL_PATH}"
  output "Theme URL: ${THEME_DL_URL}"
  output "Node.js: ${THEME_NODE_MAJOR}.x"
  output ""
  output "Steps:"
  output "  1. Install Node.js + Yarn"
  output "  2. yarn && yarn build:production"
  output "  3. Download and extract THEME.zip"
  output "  4. Fix permissions"
  output "  5. yarn build:production (final)"
  print_brake 62

  echo -e -n "* Proceed with theme installation? (y/N): "
  read -r CONFIRM
  if [[ "$CONFIRM" =~ [Yy] ]]; then
    run_installer "theme"
  else
    error "Theme installation aborted."
    exit 1
  fi
}

goodbye() {
  print_brake 62
  output "Theme installation finished."
  output "Open your panel in the browser and verify the new theme."
  print_brake 62
}

main
goodbye
