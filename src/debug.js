console.log('Debug script loaded');

setTimeout(() => {
    const elements = {
        'Editor': document.getElementById('editor'),
        'Teleprompter Button': document.getElementById('invisible-btn'),
        'Minimize Button': document.getElementById('minimize-btn'),
        'Close Button': document.getElementById('close-btn'),
        'Transparency Status': document.getElementById('transparency-status')
    };

    Object.entries(elements).forEach(([name, element]) => {
        if (element) {
            console.log(`✓ ${name}: OK`);
        } else {
            console.log(`✗ ${name}: NOT FOUND`);
        }
    });
}, 1000);

setTimeout(() => {
    const buttons = ['invisible-btn', 'minimize-btn', 'close-btn'];

    buttons.forEach(id => {
        const btn = document.getElementById(id);
        if (btn) {
            btn.addEventListener('click', () => {
                console.log(`Button ${id} clicked`);
            });
        }
    });
}, 1500);

document.addEventListener('keydown', (e) => {
    if (e.ctrlKey || e.metaKey) {
        switch (e.key) {
            case 'i':
                console.log('Ctrl+I detected (Teleprompter)');
                break;
            case 's':
                console.log('Ctrl+S detected (Save)');
                break;
        }
    }
});

console.log('Debug script ready. Press F12 to view console.');