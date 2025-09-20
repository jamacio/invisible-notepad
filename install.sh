#!/bin/bash

echo "🐧 Invisible Notepad Installer - Debian/Ubuntu Linux"
echo "=================================================="

if ! command -v apt &> /dev/null; then
    echo "❌ This installer is for Debian/Ubuntu (.deb) distributions only"
    echo "   Use manual installation for other distributions"
    exit 1
fi

echo "✅ Debian/Ubuntu system detected"

install_dependencies() {
    echo "📦 Installing system dependencies..."
    
    echo "🔄 Updating repositories..."
    sudo apt update
    
    if ! command -v node &> /dev/null; then
        echo "🔧 Installing Node.js LTS..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    if ! command -v xdotool &> /dev/null; then
        echo "🔧 Installing xdotool..."
        sudo apt install -y xdotool
    fi
    
    echo "🔧 Installing optional dependencies..."
    sudo apt install -y x11-utils wmctrl
}

echo "🔍 Checking dependencies..."

need_install=false
if ! command -v node &> /dev/null; then
    echo "⚠️  Node.js not found"
    need_install=true
fi

if ! command -v xdotool &> /dev/null; then
    echo "⚠️  xdotool not found"
    need_install=true
fi

if [ "$need_install" = true ]; then
    echo ""
    read -p "🤔 Install dependencies automatically? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[YySs]$ ]]; then
        install_dependencies
    else
        echo "❌ Installation cancelled. Install dependencies manually:"
        echo "   sudo apt update"
        echo "   sudo apt install nodejs npm xdotool x11-utils wmctrl"
        exit 1
    fi
fi

echo ""
echo "✅ Node.js: $(node --version)"
echo "✅ NPM: $(npm --version)"
echo "✅ xdotool: $(xdotool --version 2>/dev/null | head -1 || echo 'installed')"

echo ""
echo "📦 Installing project dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Error installing project dependencies."
    exit 1
fi

echo "✅ Project dependencies installed!"

echo ""
echo "🖥️  Creating desktop menu entry..."
DESKTOP_FILE="$HOME/.local/share/applications/invisible-notepad.desktop"
mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Invisible Notepad
Comment=Teleprompter for presentations - invisible during screen sharing
Exec=bash $(pwd)/iniciar-linux.sh
Icon=utilities-text-editor
Terminal=false
Categories=Office;Utility;TextEditor;
Keywords=teleprompter;notes;presentation;invisible;screen-sharing;
StartupNotify=true
StartupWMClass=invisible-notepad
EOF

chmod +x "$DESKTOP_FILE"
echo "✅ Desktop entry created at: $DESKTOP_FILE"

echo ""
echo "🏗️  Building executable (.AppImage)..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 INSTALLATION COMPLETED SUCCESSFULLY!"
    echo "=================================================="
    echo ""
    echo "📱 APPLICATION BUILT:"
    if [ -d "dist" ]; then
        echo "   Location: $(pwd)/dist/"
        ls -la dist/*.AppImage 2>/dev/null || echo "   AppImage in: dist/"
    fi
    echo ""
    echo "🎯 DESKTOP MENU:"
    echo "   Find 'Invisible Notepad' in your applications menu"
    echo "   Or search for 'teleprompter' in launcher"
    echo ""
    echo "🚀 WAYS TO RUN:"
    echo "   1. Menu:          Click on app icon in menu"
    echo "   2. NPM:           npm start"
    echo "   3. Script:        bash iniciar-linux.sh"
    echo "   4. AppImage:      ./dist/Invisible-Notepad-*.AppImage"
    echo ""
    echo "⌨️  MAIN SHORTCUTS:"
    echo "   Ctrl+I = Activate teleprompter mode"
    echo "   Ctrl+Alt+H = Hide/show window"
    echo ""
    echo "📋 HOW TO USE AS TELEPROMPTER:"
    echo "   1. Type your notes"
    echo "   2. Start video conference (Teams, Meet, etc.)"
    echo "   3. Press Ctrl+I to activate invisible mode"
    echo "   4. Share screen - you see it, others don't!"
    echo ""
    echo "📚 Read README.md for more information"
    echo ""
else
    echo "⚠️  AppImage build failed, but application is functional:"
    echo ""
    echo "🎯 DESKTOP MENU:"
    echo "   Find 'Invisible Notepad' in your applications menu"
    echo ""
    echo "🚀 RUN WITH:"
    echo "   1. Menu:          Click on app icon in menu"
    echo "   2. NPM:           npm start"
    echo "   3. Script:        bash iniciar-linux.sh"
    echo ""
fi

echo "🐧 Ready! Invisible teleprompter installed on your Linux!"