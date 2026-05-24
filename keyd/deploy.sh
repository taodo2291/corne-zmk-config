#!/usr/bin/env bash
set -euo pipefail

# Require root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./deploy.sh)"
  exit 1
fi

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "Deploying keyd configuration..."

# 1. Clean up broken previous scripts/configs
rm -f /etc/keyd/laptop-urob.conf

# 2. Copy config
cp "$SCRIPT_DIR/laptop-urob.conf" /etc/keyd/default.conf

# 3. Copy runtime binds
mkdir -p /etc/keyd/runtime
cp "$SCRIPT_DIR/runtime/qwerty.bind" /etc/keyd/runtime/
cp "$SCRIPT_DIR/runtime/vietnamese.bind" /etc/keyd/runtime/

# 4. Install script
cp "$SCRIPT_DIR/keyd-layout-mode" /usr/local/bin/
chmod +x /usr/local/bin/keyd-layout-mode

# 5. Reload keyd
keyd reload

echo "Deployment complete."
