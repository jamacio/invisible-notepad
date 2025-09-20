const { ipcRenderer } = require('electron');

class InvisibleNotepad {
    constructor() {
        this.currentFile = null;
        this.isModified = false;
        this.isInvisible = false;

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                this.init();
            });
        } else {
            this.init();
        }
    }

    init() {
        this.initializeElements();
        this.setupEventListeners();
        this.setupIPC();
        this.loadAutoSave();
    }

    initializeElements() {
        this.editor = document.getElementById('editor');
        this.fileStatus = document.getElementById('file-status');
        this.modifiedIndicator = document.getElementById('modified-indicator');
        this.transparencyStatus = document.getElementById('transparency-status');
        this.contextMenu = document.getElementById('context-menu');
        this.invisibleBtn = document.getElementById('invisible-btn');
        this.minimizeBtn = document.getElementById('minimize-btn');
        this.closeBtn = document.getElementById('close-btn');
    }

    setupEventListeners() {
        if (this.editor) {
            this.editor.addEventListener('input', () => {
                this.setModified(true);
                this.autoSave();
            });

            this.editor.addEventListener('keydown', (e) => {
                this.handleKeyboard(e);
            });

            this.editor.addEventListener('contextmenu', (e) => {
                e.preventDefault();
                this.showContextMenu(e.clientX, e.clientY);
            });

            this.editor.addEventListener('mousedown', (e) => {
                e.stopPropagation();
            });
        }

        document.addEventListener('click', () => {
            this.hideContextMenu();
        });

        if (this.invisibleBtn) {
            this.invisibleBtn.addEventListener('click', (e) => {
                this.toggleInvisible();
                e.stopPropagation();
            });
        }

        if (this.minimizeBtn) {
            this.minimizeBtn.addEventListener('click', (e) => {
                ipcRenderer.send('minimize-window');
                e.stopPropagation();
            });
        }

        if (this.closeBtn) {
            this.closeBtn.addEventListener('click', (e) => {
                this.handleClose();
                e.stopPropagation();
            });
        }

        document.querySelectorAll('.context-item').forEach(item => {
            item.addEventListener('click', (e) => {
                this.handleContextAction(e.target.dataset.action);
            });
        });
    }

    setupIPC() {
        ipcRenderer.on('menu-new-file', () => {
            this.newFile();
        });

        ipcRenderer.on('menu-open-file', (event, { content, filePath }) => {
            this.openFile(content, filePath);
        });

        ipcRenderer.on('menu-save-file', () => {
            this.saveFile();
        });

        ipcRenderer.on('menu-save-as-file', () => {
            this.saveAsFile();
        });

        ipcRenderer.on('invisible-mode-changed', (event, isInvisible) => {
            this.isInvisible = isInvisible;
            this.updateInvisibleUI();
        });
    }

    handleKeyboard(e) {
        if (e.ctrlKey || e.metaKey) {
            switch (e.key) {
                case 's':
                    e.preventDefault();
                    if (e.shiftKey) {
                        this.saveAsFile();
                    } else {
                        this.saveFile();
                    }
                    break;
                case 'o':
                    e.preventDefault();
                    break;
                case 'n':
                    e.preventDefault();
                    this.newFile();
                    break;
                case 'i':
                    e.preventDefault();
                    this.toggleInvisible();
                    break;
            }
        }
    }

    newFile() {
        if (this.isModified) {
            if (!confirm('Unsaved changes. Continue?')) {
                return;
            }
        }

        this.editor.value = '';
        this.currentFile = null;
        this.setModified(false);
        this.updateFileStatus('New document');
    }

    async openFile(content, filePath) {
        this.editor.value = content;
        this.currentFile = filePath;
        this.setModified(false);
        this.updateFileStatus(filePath);
        this.editor.focus();
    }

    async saveFile() {
        const content = this.editor.value;
        const result = await ipcRenderer.invoke('save-file', {
            content,
            filePath: this.currentFile
        });

        if (result.success) {
            this.currentFile = result.filePath;
            this.setModified(false);
            this.updateFileStatus(result.filePath);
            this.showNotification('File saved successfully!');
        } else {
            this.showNotification('Error saving file: ' + (result.error || 'Operation cancelled'), 'error');
        }
    }

    async saveAsFile() {
        const content = this.editor.value;
        const result = await ipcRenderer.invoke('save-file', {
            content,
            filePath: null
        });

        if (result.success) {
            this.currentFile = result.filePath;
            this.setModified(false);
            this.updateFileStatus(result.filePath);
            this.showNotification('File saved successfully!');
        } else {
            this.showNotification('Error saving file: ' + (result.error || 'Operation cancelled'), 'error');
        }
    }

    toggleInvisible() {
        ipcRenderer.send('toggle-invisible');
    }

    updateInvisibleUI() {
        if (this.isInvisible) {
            document.body.classList.add('invisible-mode');
            document.body.classList.add('transparent-mode');

            if (this.transparencyStatus) {
                this.transparencyStatus.textContent = 'Teleprompter Active';
            }

            if (this.invisibleBtn) {
                this.invisibleBtn.style.background = 'rgba(60, 60, 60, 0.7)';
                this.invisibleBtn.title = 'Disable Teleprompter (Ctrl+I)';
            }

            document.body.style.filter = 'contrast(1.1) brightness(0.9)';
            document.body.style.background = 'rgba(20, 20, 20, 0.9)';

            if (this.editor) {
                this.editor.style.textShadow = '0 1px 3px rgba(0, 0, 0, 0.8)';
                this.editor.style.fontWeight = '500';
                this.editor.style.background = 'rgba(25, 25, 25, 0.8)';
                this.editor.style.color = 'rgba(220, 220, 220, 0.95)';
            }

            this.showNotification('Teleprompter mode active', 'info');

        } else {
            document.body.classList.remove('invisible-mode');
            document.body.classList.remove('transparent-mode');

            if (this.transparencyStatus) {
                this.transparencyStatus.textContent = 'Normal';
            }

            if (this.invisibleBtn) {
                this.invisibleBtn.style.background = '';
                this.invisibleBtn.title = 'Enable Teleprompter (Ctrl+I)';
            }

            document.body.style.filter = '';
            document.body.style.background = '';

            if (this.editor) {
                this.editor.style.textShadow = '0 1px 2px rgba(0, 0, 0, 0.3)';
                this.editor.style.fontWeight = '';
                this.editor.style.background = '';
                this.editor.style.color = '';
            }

            this.showNotification('Normal mode', 'info');
        }
    }

    setModified(modified) {
        this.isModified = modified;
        if (this.modifiedIndicator) {
            if (modified) {
                this.modifiedIndicator.classList.remove('hidden');
            } else {
                this.modifiedIndicator.classList.add('hidden');
            }
        }
    }

    updateFileStatus(status) {
        if (this.fileStatus) {
            this.fileStatus.textContent = status;
        }
    }

    showContextMenu(x, y) {
        if (this.contextMenu) {
            this.contextMenu.style.left = `${x}px`;
            this.contextMenu.style.top = `${y}px`;
            this.contextMenu.classList.remove('hidden');
        }
    }

    hideContextMenu() {
        if (this.contextMenu) {
            this.contextMenu.classList.add('hidden');
        }
    }

    handleContextAction(action) {
        switch (action) {
            case 'cut':
                document.execCommand('cut');
                break;
            case 'copy':
                document.execCommand('copy');
                break;
            case 'paste':
                document.execCommand('paste');
                break;
            case 'selectall':
                if (this.editor) {
                    this.editor.select();
                }
                break;
            case 'invisible':
                this.toggleInvisible();
                break;
        }
        this.hideContextMenu();
    }

    handleClose() {
        if (this.isModified) {
            if (!confirm('Unsaved changes. Close anyway?')) {
                return;
            }
        }
        ipcRenderer.send('close-window');
    }

    autoSave() {
        clearTimeout(this.autoSaveTimeout);
        this.autoSaveTimeout = setTimeout(() => {
            if (this.editor) {
                localStorage.setItem('invisible-notepad-autosave', this.editor.value);
            }
        }, 1000);
    }

    loadAutoSave() {
        const autoSaved = localStorage.getItem('invisible-notepad-autosave');
        if (autoSaved && autoSaved.trim() && this.editor) {
            if (confirm('Auto-saved draft found. Load it?')) {
                this.editor.value = autoSaved;
                this.setModified(true);
            }
        }
    }

    showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;

        let backgroundColor;
        switch (type) {
            case 'info':
                backgroundColor = 'rgba(52, 73, 94, 0.9)';
                break;
            case 'error':
                backgroundColor = 'rgba(231, 76, 60, 0.9)';
                break;
            default:
                backgroundColor = 'rgba(39, 174, 96, 0.9)';
        }

        notification.style.cssText = `
position: fixed;
top: 50px;
right: 15px;
background: ${backgroundColor};
color: white;
padding: 8px 15px;
border-radius: 6px;
z-index: 3000;
font-size: 12px;
font-weight: 500;
backdrop-filter: blur(10px);
box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
animation: slideIn 0.2s ease-out;
min-width: 60px;
text-align: center;
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.2s ease-in';
            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 200);
        }, 1500);
    }
}

const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
transform: translateX(100%);
opacity: 0;
        }
        to {
transform: translateX(0);
opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
transform: translateX(0);
opacity: 1;
        }
        to {
transform: translateX(100%);
opacity: 0;
        }
    }
`;
document.head.appendChild(style);

new InvisibleNotepad();