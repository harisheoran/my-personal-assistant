#!/usr/bin/env bash
set -e

APP_NAME="my-personal-assistant"
APP_DIR="$HOME/$APP_NAME"

# Clone the repo if not already there
if [ ! -d "$APP_DIR" ]; then
    git clone https://github.com/harisheoran/$APP_NAME.git "$APP_DIR"
fi

cd "$APP_DIR"

# Create a Python virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

# Install required system dependencies (only Arch Linux & macOS)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo pacman -S --needed --noconfirm sox mpg123 libnotify
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install sox mpg123 || true
fi

# Set up autostart based on OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Setting up systemd service for $APP_NAME..."
    mkdir -p ~/.config/systemd/user
    cat > ~/.config/systemd/user/$APP_NAME.service <<EOF
[Unit]
Description=My Personal Assistant

[Service]
ExecStart=$APP_DIR/venv/bin/python $APP_DIR/main.py
Restart=always
WorkingDirectory=$APP_DIR

[Install]
WantedBy=default.target
EOF

    systemctl --user enable --now $APP_NAME.service
    echo "$APP_NAME installed and running as a systemd service."

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Setting up LaunchAgent for $APP_NAME..."
    mkdir -p ~/Library/LaunchAgents
    cat > ~/Library/LaunchAgents/com.$APP_NAME.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.$APP_NAME</string>
  <key>ProgramArguments</key>
  <array>
    <string>$APP_DIR/venv/bin/python</string>
    <string>$APP_DIR/main.py</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>WorkingDirectory</key><string>$APP_DIR</string>
</dict>
</plist>
EOF

    launchctl load ~/Library/LaunchAgents/com.$APP_NAME.plist
    echo "$APP_NAME installed and running as a LaunchAgent."
fi

echo "Installation complete. $APP_NAME will now run at startup."
