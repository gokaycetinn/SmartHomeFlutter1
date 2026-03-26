require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const deviceRoutes = require('./routes/devices');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.use('/api', deviceRoutes);

// Health Check
app.get('/health', (req, res) => {
  res.json({ status: 'Server Running', timestamp: new Date() });
});

app.get('/api/status', (req, res) => {
  res.json({
    status: 'online',
    timestamp: new Date(),
    uptime: process.uptime(),
  });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Sunucu Hatası', message: err.message });
});

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ error: 'Sayfa bulunamadı' });
});

app.listen(PORT, () => {
  console.log(`SmartHome API ${PORT} portunda çalışıyor`);
});
