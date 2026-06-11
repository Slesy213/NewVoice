const express = require('express');
const { exec } = require('child_process');
const fs = require('fs');
const app = express();
const port = 3000;

let verified = false;
let expectedPin = "12345678"; // Dinamik olarak panelden alınacak

app.get('/verify', (req, res) => {
    const pin = req.query.pin;
    if (pin === expectedPin) {
        verified = true;
        res.json({ success: true });
    } else {
        res.json({ success: false });
    }
});

app.get('/startScan', (req, res) => {
    if (!verified) return res.send("Yetkisiz");
    res.send("Tarama basladi...");
    
    // Gerçek tarama komutları
    exec('tasklist', (err, stdout) => {
        const cheats = ['cheatengine', 'nexor', 'fivemhook', 'injector', 'redengine'];
        let found = [];
        cheats.forEach(cheat => {
            if (stdout.toLowerCase().includes(cheat)) found.push(cheat);
        });
        
        // Panel'e webhook ile gönder
        const webhookURL = "https://discord.com/api/webhooks/SAKLANACAK/WEBHOOK_ID";
        const message = found.length ? `HILE TESPITI: ${found.join(',')}` : "TEMIZ sistem";
        fetch(webhookURL, { method: 'POST', body: JSON.stringify({ content: message }), headers: {'Content-Type':'application/json'} });
        
        // Local dosyaya log
        fs.appendFileSync('scan_log.txt', `${new Date()} - ${message}\n`);
    });
});

app.listen(port, () => console.log(`Payload server ${port} portunda`));
