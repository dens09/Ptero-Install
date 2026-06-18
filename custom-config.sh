#!/bin/bash
# =============================================================================
# dens09/Ptero-Install — кастомные сборки Panel и Wings
# https://github.com/dens09/Ptero-Install/releases
# =============================================================================

export GITHUB_BASE_URL="https://raw.githubusercontent.com/dens09/Ptero-Install"
export GITHUB_SOURCE="main"
export SCRIPT_RELEASE="1.11.11"

# Отдельные релизы: panel (тег 1.11.11) и wings (тег v1.11.11)
export PANEL_RELEASE_TAG="1.11.11"
export WINGS_RELEASE_TAG="v1.11.11"

export PANEL_DL_URL="https://github.com/dens09/Ptero-Install/releases/download/${PANEL_RELEASE_TAG}/panel.tar.gz"
export WINGS_DL_BASE_URL="https://github.com/dens09/Ptero-Install/releases/download/${WINGS_RELEASE_TAG}/wings_linux_"

export USE_CUSTOM_BUILDS=true

# Enigma theme (отдельная установка: bash install-theme.sh или пункт меню 3)
export PANEL_PATH="/var/www/pterodactyl"
export THEME_RELEASE_TAG="enigma"
export THEME_DL_URL="https://github.com/dens09/Ptero-Install/releases/download/${THEME_RELEASE_TAG}/THEME.zip"
export THEME_NODE_MAJOR="16"
