// Mock cihaz veritabanı
const devices = [
  {
    id: '1',
    name: 'Salon Işığı',
    type: 'light',
    location: 'Salon',
    status: true,
    value: 85,
    unit: '%',
    pin: 17,
    lastUpdated: new Date(),
  },
  {
    id: '2',
    name: 'Yatak Odası Işığı',
    type: 'light',
    location: 'Yatak Odası',
    status: false,
    pin: 27,
    lastUpdated: new Date(),
  },
  {
    id: '3',
    name: 'Klima',
    type: 'temperature',
    location: 'Salon',
    status: true,
    value: 22,
    unit: '°C',
    pin: 22,
    lastUpdated: new Date(),
  },
  {
    id: '4',
    name: 'Ön Kapı',
    type: 'door',
    location: 'Giriş',
    status: false,
    pin: 23,
    lastUpdated: new Date(),
  },
  {
    id: '5',
    name: 'Hareket Sensörü',
    type: 'motion',
    location: 'Koridor',
    status: true,
    pin: 24,
    lastUpdated: new Date(),
  },
];

module.exports = devices;
