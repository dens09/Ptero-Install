#!/bin/bash

set -e

######################################################################################
# Enigma theme installer for Pterodactyl Panel (dens09/Ptero-Install)
######################################################################################

fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  # shellcheck source=lib/lib.sh
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_BASE_URL/$GITHUB_SOURCE"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

# ------------------ Variables ----------------- #

PANEL_PATH="${PANEL_PATH:-/var/www/pterodactyl}"
THEME_DL_URL="${THEME_DL_URL:-https://github.com/dens09/Ptero-Install/releases/download/enigma/THEME.zip}"
THEME_NODE_MAJOR="${THEME_NODE_MAJOR:-16}"

# ------------------ Functions ----------------- #

panel_web_user() {
  case "$OS" in
  debian | ubuntu) echo "www-data" ;;
  rocky | almalinux) echo "nginx" ;;
  *) echo "www-data" ;;
  esac
}

install_node_and_yarn() {
  output "Installing Node.js ${THEME_NODE_MAJOR}.x and Yarn..."

  case "$OS" in
  ubuntu | debian)
    install_packages "curl ca-certificates gnupg"
    curl -fsSL "https://deb.nodesource.com/setup_${THEME_NODE_MAJOR}.x" | bash -
    install_packages "nodejs"
    ;;
  rocky | almalinux)
    install_packages "curl"
    curl -fsSL "https://rpm.nodesource.com/setup_${THEME_NODE_MAJOR}.x" | bash -
    install_packages "nodejs"
    ;;
  esac

  npm install -g yarn

  success "Node.js $(node -v) and Yarn $(yarn -v) installed!"
}

set_panel_permissions() {
  local user
  user="$(panel_web_user)"
  output "Setting ownership to ${user}..."
  chown -R "${user}:${user}" "${PANEL_PATH}"
  success "Permissions updated!"
}

build_panel_assets() {
  output "Building panel frontend assets (yarn build:production)..."
  cd "${PANEL_PATH}" || exit 1
  export NODE_OPTIONS="${NODE_OPTIONS:---max-old-space-size=4096}"
  yarn
  yarn build:production
  success "Panel assets built!"
}

download_and_apply_theme() {
  output "Downloading theme from ${THEME_DL_URL}..."

  local tmp
  tmp="$(mktemp /tmp/theme-XXXXXX.zip)"

  curl -fsSL -o "${tmp}" "${THEME_DL_URL}"

  install_packages "unzip"

  output "Extracting theme into ${PANEL_PATH}..."
  unzip -o "${tmp}" -d "${PANEL_PATH}"
  rm -f "${tmp}"

  success "Theme files extracted!"
}

perform_install() {
  if [[ ! -d "${PANEL_PATH}" ]] || [[ ! -f "${PANEL_PATH}/artisan" ]]; then
    error "Pterodactyl panel not found at ${PANEL_PATH}. Install the panel first."
    exit 1
  fi

  output "Installing Enigma theme for Pterodactyl Panel..."
  install_node_and_yarn
  build_panel_assets
  download_and_apply_theme
  set_panel_permissions
  build_panel_assets

  success "Enigma theme installation completed!"
  return 0
}

perform_install
