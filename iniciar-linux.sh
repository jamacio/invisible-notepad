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

# Cria um arquivo de log temporário
LOG_FILE="/tmp/invisible-notepad.log"

echo "✅ Starting app in background..."
echo "📋 Log file: $LOG_FILE"

# Inicia o aplicativo em background usando nohup
# Redireciona saídas para o arquivo de log
nohup npm start > "$LOG_FILE" 2>&1 &

# Obtém o PID do processo
APP_PID=$!

echo "📝 App started with PID: $APP_PID"
echo ""

# Aguarda um momento para o app inicializar
sleep 3

# Verifica se o processo ainda está rodando
if ps -p "$APP_PID" > /dev/null 2>&1; then
    echo "✅ App is running successfully!"
    echo "🔐 Terminal will close automatically..."
    echo ""
    echo "To stop the app later, run:"
    echo "pkill -f 'npm start'"
    sleep 2
    
    # Força o fechamento do terminal atual
    if [ -n "$DISPLAY" ]; then
        # Se estivermos em uma sessão gráfica, tenta fechar a janela do terminal
        if command -v xdotool &> /dev/null; then
            TERMINAL_PID=$(xdotool getwindowfocus getwindowpid)
            kill "$TERMINAL_PID" 2>/dev/null || exit 0
        else
            # Alternativa: sair do script fazendo com que o terminal se feche
            exit 0
        fi
    else
        # Em terminal não gráfico, simplesmente sai
        exit 0
    fi
else
    echo "❌ App failed to start. Check the log file:"
    echo "cat $LOG_FILE"
    exit 1
fi