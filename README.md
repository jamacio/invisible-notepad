# 🐧 Inv## Features

- 📺 **Teleprompter Mode**: Invisible during screen capture on Teams, Meet, Discord, Zoom
- 🐧 **Linux Native**: Optimized for X11 environments
- ⌨️ **Simple Shortcuts**: Ctrl+I to toggle teleprompter mode
- 💾 **Auto-Save**: Notes saved automatically
- 🛡️ **X11 Protection**: Uses native properties for capture bypass
- 🎯 **Content Protection**: Electron-level screen capture blockingtepad - Linux Teleprompter

A teleprompter app designed for screen sharing that stays visible to you but invisible to your audience on Linux.

## What it does

Read your notes during video conferences without others seeing them. When teleprompter mode is activated, your notes remain **visible to you** but become **completely invisible** to viewers during screen sharing due to advanced capture protection.

## Features

- 📺 **Teleprompter Mode**: Invisible during screen capture on Teams, Meet, Discord, Zoom
- 🐧 **Linux Native**: Optimized for X11 environments
- ⌨️ **Simple Shortcuts**: Ctrl+I to toggle teleprompter mode
- 💾 **Auto-Save**: Notes saved automatically
- 🛡️ **X11 Protection**: Uses native properties for capture bypass
- 🎯 **Content Protection**: Electron-level screen capture blocking

## Installation & Update Script

To install or update Invisible Notepad, you can use the automated installer. The script will automatically install dependencies when run non-interactively:

### Automatic Installation (Recommended)

```bash
curl -o- https://raw.githubusercontent.com/jamacio/invisible-notepad/main/install.sh | bash
```

```bash
wget -qO- https://raw.githubusercontent.com/jamacio/invisible-notepad/main/install.sh | bash
```

**Note:** The script will automatically install dependencies (`nodejs`, `npm`, `xdotool`, `x11-utils`, `wmctrl`) when executed this way.

### Manual Install

If you prefer to install dependencies manually first:

```bash
# Install dependencies
sudo apt update
sudo apt install nodejs npm xdotool x11-utils wmctrl

# Clone and install
git clone https://github.com/jamacio/invisible-notepad.git
cd invisible-notepad
npm install
npm start
```

### Local Install (Interactive)

```bash
# Download and run interactively
wget https://raw.githubusercontent.com/jamacio/invisible-notepad/main/install.sh
chmod +x install.sh
./install.sh
```

## Usage

1. **Write your notes** in the editor
2. **Start video conference** (Teams, Meet, etc.)
3. **Press Ctrl+I** to activate teleprompter mode
   - App becomes invisible to screen capture
   - Remains visible to you
4. **Share screen** - your notes won't appear to others
5. **Read freely** - you see them, others see nothing!

## Controls

| Action       | Button | Shortcut     |
| ------------ | ------ | ------------ |
| Teleprompter | 📺     | `Ctrl+I`     |
| Minimize     | ➖     | -            |
| Close        | ✖️     | `Ctrl+Q`     |
| Hide/Show    | -      | `Ctrl+Alt+H` |

## How it works

- **Content Protection**: `setContentProtection(true)` blocks screen capture at Electron level
- **X11 Properties**: `_NET_WM_BYPASS_COMPOSITOR` for capture bypass
- **Window State**: `_NET_WM_STATE` optimized to avoid detection by screen sharing software
- **Capture Blocking**: Advanced techniques to remain invisible during screen recording

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
