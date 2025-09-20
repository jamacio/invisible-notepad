#!/bin/bash

echo "🐧 Invisible Notepad Installer - Debian/Ubuntu Linux"
echo "=================================================="

if ! command -v apt &> /dev/null; then
    echo "❌ This installer is for Debian/Ubuntu (.deb) distributions only"
    echo "   Use manual installation for other distributions"
    exit 1
fi

echo "✅ Debian/Ubuntu system detected"

# Detect if script is being run from curl | bash (remote install)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOTE_INSTALL=false

if [[ ! -f "$SCRIPT_DIR/package.json" ]]; then
    REMOTE_INSTALL=true
    echo "🌐 Remote installation detected - downloading project..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        echo "🔧 Installing git..."
        sudo apt update
        sudo apt install -y git
    fi
    
    # Create installation directory
    INSTALL_DIR="$HOME/invisible-notepad"
    
    if [ -d "$INSTALL_DIR" ]; then
        echo "📁 Found existing installation at $INSTALL_DIR"
        read -p "🤔 Remove existing installation and reinstall? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[YySs]$ ]]; then
            rm -rf "$INSTALL_DIR"
        else
            echo "❌ Installation cancelled."
            exit 1
        fi
    fi
    
    echo "📥 Cloning repository..."
    git clone https://github.com/jamacio/invisible-notepad.git "$INSTALL_DIR"
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to clone repository"
        exit 1
    fi
    
    # Change to the cloned directory
    SCRIPT_DIR="$INSTALL_DIR"
    cd "$SCRIPT_DIR"
    echo "✅ Project downloaded to: $INSTALL_DIR"
else
    echo "📁 Local installation detected"
fi

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
    # Check if running via pipe (curl | bash) or interactive terminal
    if [ -t 0 ]; then
        # Interactive mode
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
    else
        # Non-interactive mode (curl | bash)
        echo "🔄 Running in non-interactive mode, installing dependencies automatically..."
        install_dependencies
    fi
fi

echo ""
echo "✅ Node.js: $(node --version)"
echo "✅ NPM: $(npm --version)"
echo "✅ xdotool: $(xdotool --version 2>/dev/null | head -1 || echo 'installed')"

echo ""
echo "📦 Installing project dependencies..."
# Ensure we're in the correct directory
cd "$SCRIPT_DIR"
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

# Use the actual installation directory for the Exec path
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Invisible Notepad
Comment=Teleprompter for presentations - invisible during screen sharing
Exec=bash $SCRIPT_DIR/iniciar-linux.sh
Icon=utilities-text-editor
Terminal=false
Categories=Office;Utility;TextEditor;
Keywords=teleprompter;notes;presentation;invisible;screen-sharing;
StartupNotify=true
StartupWMClass=invisible-notepad
EOF

chmod +x "$DESKTOP_FILE"
echo "✅ Desktop entry created at: $DESKTOP_FILE"
echo "   Pointing to: $SCRIPT_DIR/iniciar-linux.sh"

echo ""
echo "🏗️  Building executable (.AppImage)..."
# Ensure we're in the correct directory
cd "$SCRIPT_DIR"
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 INSTALLATION COMPLETED SUCCESSFULLY!"
    echo "=================================================="
    echo ""
    if [ "$REMOTE_INSTALL" = true ]; then
        echo "� PROJECT INSTALLED TO:"
        echo "   Location: $SCRIPT_DIR"
        echo ""
    fi
    echo "�📱 APPLICATION BUILT:"
    if [ -d "$SCRIPT_DIR/dist" ]; then
        echo "   Location: $SCRIPT_DIR/dist/"
        ls -la "$SCRIPT_DIR/dist"/*.AppImage 2>/dev/null || echo "   AppImage in: dist/"
    fi
    echo ""
    echo "🎯 DESKTOP MENU:"
    echo "   Find 'Invisible Notepad' in your applications menu"
    echo "   Or search for 'teleprompter' in launcher"
    echo ""
    echo "🚀 WAYS TO RUN:"
    echo "   1. Menu:          Click on app icon in menu"
    if [ "$REMOTE_INSTALL" = true ]; then
        echo "   2. NPM:           cd $SCRIPT_DIR && npm start"
        echo "   3. Script:        cd $SCRIPT_DIR && bash iniciar-linux.sh"
        echo "   4. AppImage:      $SCRIPT_DIR/dist/Invisible-Notepad-*.AppImage"
    else
        echo "   2. NPM:           npm start"
        echo "   3. Script:        bash iniciar-linux.sh"
        echo "   4. AppImage:      ./dist/Invisible-Notepad-*.AppImage"
    fi
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
    if [ "$REMOTE_INSTALL" = true ]; then
        echo "📁 PROJECT INSTALLED TO:"
        echo "   Location: $SCRIPT_DIR"
        echo ""
    fi
    echo "🎯 DESKTOP MENU:"
    echo "   Find 'Invisible Notepad' in your applications menu"
    echo ""
    echo "🚀 RUN WITH:"
    echo "   1. Menu:          Click on app icon in menu"
    if [ "$REMOTE_INSTALL" = true ]; then
        echo "   2. NPM:           cd $SCRIPT_DIR && npm start"
        echo "   3. Script:        cd $SCRIPT_DIR && bash iniciar-linux.sh"
    else
        echo "   2. NPM:           npm start"
        echo "   3. Script:        bash iniciar-linux.sh"
    fi
    echo ""
fi

echo "🐧 Ready! Invisible teleprompter installed on your Linux!"