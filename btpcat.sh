#!/usr/bin/env bash
#!/bin/bash

# =====================================================
# Written by  PardesiCat <contact@pardesicat.xyz>
# =====================================================

cat <<'EOF'

               ____               _           _     ____      _   
              |  _ \ __ _ _ __ __| | ___  ___(_)   / ___|__ _| |_ 
              | |_) / _` | '__/ _` |/ _ \/ __| |  | |   / _` | __|
              |  __/ (_| | | | (_| |  __/\__ \ |  | |__| (_| | |_ 
              |_|   \__,_|_|  \__,_|\___||___/_|___\____\__,_|\__|
                                              |_____|             


 Website :                                             https://pardesicat.xyz

EOF

sleep 5


set -u

BLUETOOTH_DIR="/var/lib/bluetooth"
WIREPLUMBER_DIR="$HOME/.config/pulse"

echo "======================================"
echo " Bluetooth Reset Script"
echo "======================================"

# 1. Stop Bluetooth
echo "[1/5] Stopping Bluetooth service..."
sudo systemctl stop bluetooth

# 2. Verify Bluetooth is stopped
echo "[2/5] Checking Bluetooth service status..."

if systemctl is-active --quiet bluetooth; then
    echo "ERROR: Bluetooth service is still running!"
    echo "Aborting. Bluetooth data will NOT be deleted."
    exit 1
fi

echo "OK: Bluetooth service is stopped."

# 3. Remove Bluetooth state
echo "[3/5] Removing Bluetooth data..."

if [ -d "$BLUETOOTH_DIR" ]; then
    sudo rm -rf "$BLUETOOTH_DIR"
    echo "OK: $BLUETOOTH_DIR removed."
else
    echo "INFO: $BLUETOOTH_DIR does not exist."
fi

# 4. Start Bluetooth again
echo "[4/5] Starting Bluetooth service..."
sudo systemctl restart bluetooth

# Verify Bluetooth started
if systemctl is-active --quiet bluetooth; then
    echo "OK: Bluetooth service is running."
else
    echo "WARNING: Bluetooth service failed to start!"
    exit 1
fi

# 5. Remove Bluetooth state
echo "[3/5] Removing audio data..."

if [ -d "$WIREPLUMBER_DIR" ]; then
    sudo rm -rf "$WIREPLUMBER_DIR"
    echo "OK: $WIREPLUMBER_DIR removed."
else
    echo "INFO: $WIREPLUMBER_DIR does not exist."
fi

# 6. Restart WirePlumber
echo "[5/5] Restarting WirePlumber..."
systemctl --user restart wireplumber

echo
echo "======================================"
echo " Bluetooth reset completed successfully"
echo "======================================"

sleep 5
