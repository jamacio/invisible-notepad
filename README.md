# 🐧 Invisible Notepad - Linux Teleprompter

A teleprompter app designed for screen sharing that stays visible to you but invisible to your audience on Linux.

## What it does

Read your notes during video conferences without others seeing them. When teleprompter mode is activated, your notes appear at **40% opacity** to you but remain **completely invisible** to viewers during screen sharing due to advanced capture protection.

## Features

- 📺 **Teleprompter Mode**: Invisible during screen capture on Teams, Meet, Discord, Zoom
- � **Fixed Transparency**: Automatically sets to 40% opacity when active
- 🐧 **Linux Native**: Optimized for X11 environments
- ⌨️ **Simple Shortcuts**: Ctrl+I to toggle teleprompter mode
- 💾 **Auto-Save**: Notes saved automatically
- 🛡️ **X11 Protection**: Uses native properties for capture bypass
- 🎯 **Content Protection**: Electron-level screen capture blocking

## Installation & Update Script

To install or update Invisible Notepad, you should run the install script. To do that, you may either download and run the script manually, or use the following cURL or Wget command:

```bash
curl -o- https://raw.githubusercontent.com/jamacio/invisible-notepad/main/install.sh | bash
```

```bash
wget -qO- https://raw.githubusercontent.com/jamacio/invisible-notepad/main/install.sh | bash
```

### Manual Install

```bash
# Dependencies
sudo apt install nodejs npm xdotool

# Clone and install
git clone https://github.com/jamacio/invisible-notepad.git
cd invisible-notepad
npm install
npm start
```

### Quick Install (Local)

```bash
chmod +x install.sh
./install.sh
```

## Usage

1. **Write your notes** in the editor
2. **Start video conference** (Teams, Meet, etc.)
3. **Press Ctrl+I** to activate teleprompter mode
   - App automatically becomes 40% transparent to you
   - Completely invisible to screen capture
4. **Share screen** - your notes won't appear to others
5. **Read freely** - you see them at fixed transparency, others see nothing!

## Controls

| Action       | Button | Shortcut     |
| ------------ | ------ | ------------ |
| Teleprompter | 📺     | `Ctrl+I`     |
| Minimize     | ➖     | -            |
| Close        | ✖️     | `Ctrl+Q`     |
| Hide/Show    | -      | `Ctrl+Alt+H` |

## How it works

- **Content Protection**: `setContentProtection(true)` blocks screen capture at Electron level
- **Fixed Transparency**: Window opacity automatically set to 40% during teleprompter mode (visible to you, invisible to capture)
- **X11 Properties**: `_NET_WM_BYPASS_COMPOSITOR` for capture bypass
- **Window State**: `_NET_WM_STATE` optimized to avoid detection by screen sharing software
- **Enhanced Contrast**: Text styling optimized for readability at reduced opacity

## Requirements

- Linux with X11
- Node.js
- xdotool (`sudo apt install xdotool`)

## Build

```bash
npm run build  # Generates AppImage
```

## Uninstall

### Automatic uninstall:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

### Manual uninstall:

```bash
# Remove application directory
rm -rf ~/invisible-notepad

# Remove desktop entry (if installed)
rm -f ~/.local/share/applications/invisible-notepad.desktop

# Remove auto-saved data
rm -f ~/.config/invisible-notepad/*
```

## License

MIT License

---

**Made for Linux presenters who want to excel!** 🚀
