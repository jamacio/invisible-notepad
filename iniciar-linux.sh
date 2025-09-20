#!/bin/bash

# Get the directory where this script is located and change to it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🐧 Invisible Notepad - Linux Teleprompter"
echo "📁 Running from: $SCRIPT_DIR"
echo ""
echo "Checking Node.js..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not installed!"
    echo ""
    echo "Install Node.js with:"
    echo "Ubuntu/Debian: sudo apt install nodejs npm"
    echo "Fedora: sudo dnf install nodejs nodejs-npm"
    echo "Arch: sudo pacman -S nodejs npm"
    echo ""
    exit 1
fi

echo "✅ Node.js found!"
node --version

echo ""
echo "Checking Linux dependencies..."

if ! command -v xdotool &> /dev/null; then
    echo "⚠️  xdotool not found (recommended):"
    echo "Ubuntu/Debian: sudo apt install xdotool"
    echo "Fedora: sudo dnf install xdotool"
    echo "Arch: sudo pacman -S xdotool"
else
    echo "✅ xdotool found!"
fi

echo ""
echo "Checking project dependencies..."
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Error installing dependencies!"
        exit 1
    fi
else
    echo "✅ Dependencies already installed!"
fi

echo ""
echo "🚀 Starting Linux Teleprompter..."
echo ""
echo "📺 HOW TO USE AS TELEPROMPTER:"
echo "  1. Type your notes in the editor"
echo "  2. Start your video conference (Teams, Meet, Zoom, etc.)"
echo "  3. Share your screen"
echo "  4. Press Ctrl+I to activate teleprompter mode"
echo "  5. Your notes stay visible to you, invisible to others!"
echo ""
echo "⌨️  SHORTCUTS:"
echo "  Ctrl+I = Teleprompter ON/OFF"
echo "  Ctrl+Alt+H = Hide/show window"
echo ""

npm start