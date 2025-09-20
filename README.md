# 🐧 Invisible Notepad - Linux Teleprompter

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

## Installation

### Prerequisites

Make sure you have Node.js installed:

```bash
# Ubuntu/Debian
sudo apt install nodejs npm

# Fedora
sudo dnf install nodejs npm

# Arch
sudo pacman -S nodejs npm
```

**Recommended (for better functionality):**

```bash
sudo apt install xdotool
```

### Install and Run

1. **Clone the repository and enter the directory:**

```bash
git clone https://github.com/jamacio/invisible-notepad.git
cd invisible-notepad
```

2. **Run the setup script:**

```bash
./start
```

**Important:** Make sure you're inside the `invisible-notepad` directory before running `./start`

The script will:

- Install npm dependencies
- Create a desktop menu entry
- Launch the application immediately

### Alternative ways to run

```bash
# Using the start script
./start

# Direct with npm
npm start

# Using launcher script
./iniciar-linux.sh

# From applications menu
# Search for "Invisible Notepad" in your app launcher
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

```bash
# Remove application directory
rm -rf ~/invisible-notepad

# Remove desktop entry
rm -f ~/.local/share/applications/invisible-notepad.desktop

# Remove auto-saved data (optional)
rm -rf ~/.config/invisible-notepad/
```

## Troubleshooting

### "No such file or directory" when running ./start

Make sure you're in the correct directory:

```bash
cd invisible-notepad  # Enter the project directory first
./start               # Then run the script
```

### Dependencies not found

If you get Node.js or npm errors, install them first:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nodejs npm

# Then try again
./start
```

## License

MIT License

---

**Made for Linux presenters who want to excel!** 🚀
