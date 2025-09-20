const { app, BrowserWindow, Menu, dialog, ipcMain, globalShortcut } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow;
let isInvisibleMode = false;

app.commandLine.appendSwitch('disable-features', 'MediaRouter,ScreenCaptureKit');
app.commandLine.appendSwitch('disable-background-timer-throttling');
app.commandLine.appendSwitch('disable-renderer-backgrounding');
app.commandLine.appendSwitch('disable-backgrounding-occluded-windows');
app.commandLine.appendSwitch('enable-transparent-visuals');
app.commandLine.appendSwitch('disable-gpu-sandbox');

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 800,
        height: 600,
        minWidth: 300,
        minHeight: 200,
        transparent: true,
        frame: false,
        alwaysOnTop: true,
        skipTaskbar: false,
        resizable: true,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
            webSecurity: false,
            backgroundThrottling: false,
            experimentalFeatures: true
        },
        titleBarStyle: 'hidden',
        thickFrame: false,
        vibrancy: 'ultra-dark',
        visualEffectState: 'active'
    });

    mainWindow.loadFile('src/index.html');
    mainWindow.setVisibleOnAllWorkspaces(true, { visibleOnFullScreen: true });
    createMenu();
    registerGlobalShortcuts();
    setupIPC();

    if (process.argv.includes('--dev')) {
        mainWindow.webContents.openDevTools();
    }
}

function createMenu() {
    const template = [
        {
            label: 'File',
            submenu: [
                {
                    label: 'New',
                    accelerator: 'CmdOrCtrl+N',
                    click: () => {
                        mainWindow.webContents.send('menu-new-file');
                    }
                },
                {
                    label: 'Open',
                    accelerator: 'CmdOrCtrl+O',
                    click: async () => {
                        const result = await dialog.showOpenDialog(mainWindow, {
                            properties: ['openFile'],
                            filters: [
                                { name: 'Text Files', extensions: ['txt', 'md', 'js', 'json', 'html', 'css'] },
                                { name: 'All Files', extensions: ['*'] }
                            ]
                        });

                        if (!result.canceled && result.filePaths.length > 0) {
                            const filePath = result.filePaths[0];
                            const content = fs.readFileSync(filePath, 'utf8');
                            mainWindow.webContents.send('menu-open-file', { content, filePath });
                        }
                    }
                },
                {
                    label: 'Save',
                    accelerator: 'CmdOrCtrl+S',
                    click: () => {
                        mainWindow.webContents.send('menu-save-file');
                    }
                },
                {
                    label: 'Save As',
                    accelerator: 'CmdOrCtrl+Shift+S',
                    click: () => {
                        mainWindow.webContents.send('menu-save-as-file');
                    }
                },
                { type: 'separator' },
                {
                    label: 'Exit',
                    accelerator: 'CmdOrCtrl+Q',
                    click: () => {
                        app.quit();
                    }
                }
            ]
        },
        {
            label: 'Edit',
            submenu: [
                { role: 'undo', label: 'Undo' },
                { role: 'redo', label: 'Redo' },
                { type: 'separator' },
                { role: 'cut', label: 'Cut' },
                { role: 'copy', label: 'Copy' },
                { role: 'paste', label: 'Paste' },
                { role: 'selectall', label: 'Select All' }
            ]
        },
        {
            label: 'View',
            submenu: [
                {
                    label: 'Teleprompter Mode',
                    accelerator: 'CmdOrCtrl+I',
                    click: () => {
                        toggleInvisibleMode();
                    }
                },
                { type: 'separator' },
                { role: 'reload', label: 'Reload' },
                { role: 'toggledevtools', label: 'Developer Tools' }
            ]
        }
    ];

    const menu = Menu.buildFromTemplate(template);
    Menu.setApplicationMenu(menu);
}

function registerGlobalShortcuts() {
    globalShortcut.register('CommandOrControl+Alt+I', () => {
        toggleInvisibleMode();
    });

    globalShortcut.register('CommandOrControl+Alt+H', () => {
        if (mainWindow.isVisible()) {
            mainWindow.hide();
        } else {
            mainWindow.show();
        }
    });
}

function setupIPC() {
    ipcMain.handle('save-file', async (event, { content, filePath }) => {
        try {
            if (filePath) {
                fs.writeFileSync(filePath, content, 'utf8');
                return { success: true, filePath };
            } else {
                const result = await dialog.showSaveDialog(mainWindow, {
                    filters: [
                        { name: 'Text Files', extensions: ['txt'] },
                        { name: 'All Files', extensions: ['*'] }
                    ]
                });

                if (!result.canceled) {
                    fs.writeFileSync(result.filePath, content, 'utf8');
                    return { success: true, filePath: result.filePath };
                }
            }
            return { success: false };
        } catch (error) {
            return { success: false, error: error.message };
        }
    });

    ipcMain.on('toggle-invisible', () => {
        toggleInvisibleMode();
    });

    ipcMain.on('minimize-window', () => {
        mainWindow.minimize();
    });

    ipcMain.on('close-window', () => {
        mainWindow.close();
    });
}

function toggleInvisibleMode() {
    isInvisibleMode = !isInvisibleMode;
    console.log(`Teleprompter mode: ${isInvisibleMode ? 'ON' : 'OFF'}`);

    if (isInvisibleMode) {
        mainWindow.setContentProtection(true);
        mainWindow.setOpacity(0.4);
        mainWindow.webContents.send('invisible-mode-changed', true);

        if (process.platform === 'linux') {
            try {
                const { exec } = require('child_process');
                exec(`xprop -id $(xdotool search --name "Invisible Notepad") _NET_WM_BYPASS_COMPOSITOR 1`, (error) => {
                    if (!error) console.log('X11 properties configured');
                });
                exec(`xprop -id $(xdotool search --name "Invisible Notepad") _NET_WM_STATE _NET_WM_STATE_SKIP_PAGER,_NET_WM_STATE_SKIP_TASKBAR`, (error) => {
                    if (!error) console.log('Window state optimized');
                });
            } catch (error) {
                console.log('Using fallback method');
            }
        }

    } else {
        mainWindow.setContentProtection(false);
        mainWindow.setOpacity(1.0);
        mainWindow.webContents.send('invisible-mode-changed', false);
    }
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
    globalShortcut.unregisterAll();
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
        createWindow();
    }
});

app.on('will-quit', () => {
    globalShortcut.unregisterAll();
});