// Rexgun Scanner - Bilgisayar tarama payload
// Bu dosya Electron ile compile edilip .exe yapılacak

const { app, BrowserWindow, ipcMain } = require('electron');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

let mainWindow;
let pinCode = null;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 450,
        height: 350,
        webPreferences: { nodeIntegration: true, contextIsolation: false },
        resizable: false,
        title: "Rexgun Security Scanner"
    });
    
    mainWindow.loadURL(`data:text/html,
    <html>
    <head><style>body{background:#000;color:#0f0;font-family:monospace;text-align:center;padding:50px;}</style></head>
    <body>
    <h2 style="color:red;">REXGUN SCANNER</h2>
    <p>PIN kodunuzu girin:</p>
    <input type="text" id="pin" style="background:#222;color:#0f0;border:1px solid red;padding:10px;width:200px;">
    <button id="submit" style="background:red;color:white;padding:10px;margin:10px;">TARA</button>
    <div id="status"></div>
    <script>
        document.getElementById('submit').onclick = () => {
            const pin = document.getElementById('pin').value;
            fetch('http://localhost:3000/verify?pin=' + pin)
            .then(r => r.json())
            .then(data => {
                if(data.success) {
                    document.getElementById('status').innerHTML = '<span style="color:green;">PIN dogrulandi, taranıyor...</span>';
                    window.location.href = 'http://localhost:3000/startScan';
                } else {
                    document.getElementById('status').innerHTML = '<span style="color:red;">Hatali PIN!</span>';
                }
            });
        };
    </script>
    </body>
    </html>
    `);
}

app.whenReady().then(createWindow);
