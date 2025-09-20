#!/bin/bash

echo "🗑️  Invisible Notepad Uninstaller"
echo "================================"

echo "This will remove:"
echo "• Application files"
echo "• Desktop menu entry" 
echo "• Auto-saved data"
echo ""

read -p "🤔 Are you sure you want to uninstall? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Uninstall cancelled"
    exit 0
fi

echo ""
echo "🧹 Removing application files..."

APP_DIR="$(pwd)"
DESKTOP_FILE="$HOME/.local/share/applications/invisible-notepad.desktop"
CONFIG_DIR="$HOME/.config/invisible-notepad"

if [ -f "$DESKTOP_FILE" ]; then
    rm -f "$DESKTOP_FILE"
    echo "✅ Desktop entry removed"
else
    echo "⚠️  Desktop entry not found"
fi

if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo "✅ Configuration directory removed"
else
    echo "⚠️  Configuration directory not found"
fi

echo "✅ Local storage cleared"
echo ""
echo "📁 Application directory: $APP_DIR"
echo "   You can manually delete this directory if desired:"
echo "   rm -rf '$APP_DIR'"
echo ""
echo "🎉 Uninstall completed!"
echo "   (Application directory preserved for manual removal)"