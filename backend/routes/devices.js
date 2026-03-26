const express = require('express');
const router = express.Router();
const devices = require('../config/devices');

// Tüm cihazları getir
router.get('/devices', (req, res) => {
  res.json(devices);
});

// Belirli bir cihazı getir
router.get('/devices/:id', (req, res) => {
  const device = devices.find(d => d.id === req.params.id);
  if (device) {
    res.json(device);
  } else {
    res.status(404).json({ error: 'Cihaz bulunamadı' });
  }
});

// Cihazı aç/kapat
router.post('/devices/:id/toggle', (req, res) => {
  const device = devices.find(d => d.id === req.params.id);
  if (device) {
    const { status } = req.body;
    device.status = status !== undefined ? status : !device.status;
    device.lastUpdated = new Date();
    
    // Raspberry Pi GPIO komutunu çalıştır
    if (device.pin) {
      executeGPIOCommand(device.pin, device.status);
    }
    
    res.json(device);
  } else {
    res.status(404).json({ error: 'Cihaz bulunamadı' });
  }
});

// Cihazın değerini güncelle (ısı, ışık yoğunluğu vb.)
router.post('/devices/:id/value', (req, res) => {
  const device = devices.find(d => d.id === req.params.id);
  if (device) {
    const { value } = req.body;
    device.value = value;
    device.lastUpdated = new Date();
    
    // Raspberry Pi PWM komutunu çalıştır
    if (device.pin) {
      executePWMCommand(device.pin, value);
    }
    
    res.json(device);
  } else {
    res.status(404).json({ error: 'Cihaz bulunamadı' });
  }
});

// Yeni cihaz ekle
router.post('/devices', (req, res) => {
  const { name, type, location, pin } = req.body;
  
  const newDevice = {
    id: (devices.length + 1).toString(),
    name,
    type,
    location,
    pin,
    status: false,
    value: null,
    unit: type === 'light' ? '%' : type === 'temperature' ? '°C' : null,
    lastUpdated: new Date(),
  };
  
  devices.push(newDevice);
  res.status(201).json(newDevice);
});

// Cihazı sil
router.delete('/devices/:id', (req, res) => {
  const index = devices.findIndex(d => d.id === req.params.id);
  if (index > -1) {
    const removed = devices.splice(index, 1);
    res.json({ message: 'Cihaz silindi', device: removed[0] });
  } else {
    res.status(404).json({ error: 'Cihaz bulunamadı' });
  }
});

// Raspberry Pi GPIO komutları
function executeGPIOCommand(pin, state) {
  console.log(`GPIO ${pin} komutu: ${state ? 'AÇIK' : 'KAPALI'}`);
  
  // Gerçek Raspberry Pi'de gpio komutları çalıştırılır:
  // const { exec } = require('child_process');
  // const cmd = `gpio mode ${pin} out && gpio write ${pin} ${state ? '1' : '0'}`;
  // exec(cmd, (error, stdout, stderr) => {
  //   if (error) console.error(`GPIO Hata: ${error.message}`);
  // });
}

function executePWMCommand(pin, value) {
  console.log(`GPIO ${pin} PWM değeri: ${value}`);
  
  // Gerçek Raspberry Pi'de PWM komutları çalıştırılır:
  // const { exec } = require('child_process');
  // const dutyCycle = Math.round((value / 100) * 1023);
  // const cmd = `gpio mode ${pin} pwm && gpio pwm ${pin} ${dutyCycle}`;
  // exec(cmd, (error, stdout, stderr) => {
  //   if (error) console.error(`PWM Hata: ${error.message}`);
  // });
}

module.exports = router;
