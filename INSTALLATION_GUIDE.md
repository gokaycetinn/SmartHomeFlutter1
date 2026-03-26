# SmartHome Uygulaması - Kapsamlı Kurulum ve Kullanım Kılavuzu

## 📋 İçindekiler

1. [Sistem Gereksinimleri](#sistem-gereksinimleri)
2. [Kurulum Adımları](#kurulum-adımları)
3. [Yapı Açıklaması](#yapı-açıklaması)
4. [API Endpoints](#api-endpoints)
5. [Raspberry Pi Kurulumu](#raspberry-pi-kurulumu)
6. [Sorun Giderme](#sorun-giderme)

---

## 🖥️ Sistem Gereksinimleri

### Geliştirme Bilgisayarı (Windows/Mac/Linux)
- **Node.js**: v20.0.0 veya üzeri
- **Flutter SDK**: 3.0.0 veya üzeri
- **Python**: 3.9+ (isteğe bağlı)
- **Git**: v2.30.0 veya üzeri
- **RAM**: Minimum 8GB
- **Disk**: Minimum 5GB boş alan

### Raspberry Pi 5
- **OS**: Raspberry Pi OS (Bookworm) 64-bit
- **RAM**: Minimum 4GB (8GB önerilir)
- **Storage**: 64GB MicroSD kart (UHS-II)
- **Power**: USB-C 27W
- **Network**: Ethernet veya WiFi 6

---

## 🚀 Kurulum Adımları

### 1. Proje Dosyaları Hazırlama

```bash
# Windows
install.bat

# Linux/Mac
bash install_rpi.sh
```

### 2. Node.js Bağımlılıkları

```bash
cd backend
npm install
```

### 3. Flutter Bağımlılıkları

```bash
cd smart_home
flutter pub get
```

---

## 📂 Yapı Açıklaması

### Flutter Uygulaması (`smart_home/`)

```
smart_home/
├── lib/
│   ├── main.dart                    # Uygulama giriş noktası
│   ├── models/
│   │   └── device.dart              # Device veri modeli
│   ├── services/
│   │   └── device_service.dart      # API iletişim servisi
│   ├── screens/
│   │   ├── home_screen.dart         # Ana dashboard
│   │   ├── settings_screen.dart     # Ayarlar
│   │   ├── statistics_screen.dart   # İstatistikler
│   │   └── device_detail_screen.dart# Cihaz detayları
│   └── widgets/
│       ├── device_card.dart         # Cihaz kartı
│       └── device_grid.dart         # Cihaz ızgarası
├── pubspec.yaml                     # Bağımlılıklar
└── android/                         # Android ayarları
```

#### Ana Bileşenler

**DeviceService** - API Haberleşmesi
```dart
- fetchDevices()        // Cihazları yükle
- toggleDevice()        // Aç/Kapat
- updateDeviceValue()   // Değer güncelle
- createDevice()        // Yeni cihaz
- deleteDevice()        // Cihaz sil
```

**Device Model**
```dart
- id: String            // Cihaz ID
- name: String          // Adı
- type: String          // Tip (light, temp, etc.)
- location: String      // Konum
- status: bool          // Durum
- value: double?        // Değer
- unit: String?         // Birim
```

### Backend API (`backend/`)

```
backend/
├── server.js            # Express sunucusu
├── routes/
│   └── devices.js       # Device endpoints
├── config/
│   └── devices.js       # Mock veritabanı
├── package.json         # Node.js bağımlılıkları
└── .env                 # Yapılandırma
```

#### API Endpoints

| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | `/api/devices` | Tüm cihazları getir |
| GET | `/api/devices/:id` | Belirli cihazı getir |
| POST | `/api/devices` | Yeni cihaz ekle |
| POST | `/api/devices/:id/toggle` | Durumu değiştir |
| POST | `/api/devices/:id/value` | Değer güncelle |
| DELETE | `/api/devices/:id` | Cihazı sil |
| GET | `/health` | Sistem durumu |
| GET | `/api/status` | API durumu |

### Raspberry Pi Controller

```
raspberry_pi/
└── smarthome_controller.py  # GPIO kontrolörü
```

#### GPIO Pin Tanımlamaları

| Device ID | Adı | GPIO Pin | Tür | Amaç |
|-----------|-----|----------|-----|------|
| 1 | Salon Işığı | 17 | Output | LED |
| 2 | Yatak Odası | 27 | Output | LED |
| 3 | Klima | 22 | PWM | Hız/Sıcaklık |
| 4 | Ön Kapı | 23 | Relay | Kilit |
| 5 | Hareket Sensörü | 24 | Input | Motion |

---

## 🌐 API Endpoints

### Cihaz Listesi

```bash
curl http://localhost:3000/api/devices
```

**Cevap:**
```json
[
  {
    "id": "1",
    "name": "Salon Işığı",
    "type": "light",
    "location": "Salon",
    "status": true,
    "value": 85,
    "unit": "%",
    "lastUpdated": "2024-03-26T23:30:00.000Z"
  }
]
```

### Cihaz Durumu Değiştir

```bash
curl -X POST http://localhost:3000/api/devices/1/toggle \
  -H "Content-Type: application/json" \
  -d '{"status": true}'
```

### Cihaz Değeri Güncelle

```bash
curl -X POST http://localhost:3000/api/devices/1/value \
  -H "Content-Type: application/json" \
  -d '{"value": 75}'
```

---

## 🛠️ Raspberry Pi Kurulumu

### 1. SSH Bağlantısı

```bash
ssh pi@192.168.1.100
```

### 2. Sistem Güncellemeleri

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 3. Gerekli Paketleri Yükle

```bash
# Python ve GPIO
sudo apt-get install -y python3-pip python3-rpi.gpio python3-requests

# Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Gerekli Python paketleri
pip3 install RPi.GPIO requests pyyaml
```

### 4. Projeyi Klonla

```bash
cd ~
git clone <repo-url> smarthome
cd smarthome
npm install --prefix backend
```

### 5. Başlat

```bash
# Terminal 1: API Sunucusu
cd backend
npm start

# Terminal 2: GPIO Kontrolörü
sudo python3 raspberry_pi/smarthome_controller.py
```

### 6. Otomatik Başlatma (Opsiyonel)

**systemd Servisi Oluştur:**

```bash
sudo nano /etc/systemd/system/smarthome.service
```

```ini
[Unit]
Description=SmartHome API
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/smarthome/backend
ExecStart=/usr/bin/npm start
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable smarthome
sudo systemctl start smarthome
```

---

## ▶️ Çalıştırma

### Geliştirme Ortamında

**Terminal 1 - Backend:**
```bash
cd backend
npm start
```

**Terminal 2 - Flutter:**
```bash
cd smart_home
flutter run
```

### Production Ortamında

**Raspberry Pi'de:**
```bash
# API
cd ~/smarthome/backend
npm start --production

# GPIO Controller
sudo python3 ~/smarthome/raspberry_pi/smarthome_controller.py
```

**Mobil Cihazda:**
```bash
cd smart_home
flutter build apk
```

---

## 🔌 Cihaz Kontrolü

### Açık/Kapat

```python
# Salon Işığını Aç
POST /api/devices/1/toggle
{ "status": true }

# Sonuç
{
  "id": "1",
  "name": "Salon Işığı",
  "status": true,
  "lastUpdated": "2024-03-26T23:35:00.000Z"
}
```

### Işık Yoğunluğu Ayarla

```python
# %50 Yoğunluğa ayarla
POST /api/devices/1/value
{ "value": 50 }
```

---

## 🐛 Sorun Giderme

### API Bağlantısı Hatası

**Problem:** "Bağlantı hatası"

**Çözüm:**
```bash
# API'nin çalışıp çalışmadığını kontrol et
curl http://192.168.1.100:3000/health

# Firewall kontrol et
sudo ufw allow 3000

# Logs kontrol et
pm2 logs
```

### GPIO Hatası (Raspberry Pi)

**Problem:** "Permission denied" GPIO işlemi

**Çözüm:**
```bash
# Kullanıcıyı gpio grubuna ekle
sudo usermod -aG gpio pi

# Terminal'den çıkıp tekrar gir
exit
ssh pi@192.168.1.100
```

### Flutter Bağlantı Problemi

**Problem:** Emulator/Device'ta API bağlanamıyor

**Çözüm:**
```dart
// lib/services/device_service.dart dosyasında

// Değiştir:
static const String baseUrl = 'http://192.168.1.100:3000/api';

// Eğer localhost'ta testiyorsan:
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

---

## 📊 İstatistikler

Uygulamada cihaz istatistiklerini görüntülemek için:

1. Ana ekranda "İstatistikler" sekmesine tıkla
2. Aktif/Pasif cihaz sayılarını göreceksin
3. Cihaz türlerinin dağılımını göreceksin
4. Her cihazın durumunu ayrı ayrı göreceksin

---

## 🔒 Güvenlik

### API Koruması

```javascript
// Gelecek sürümler için token doğrulaması:
app.use((req, res, next) => {
  const token = req.headers.authorization;
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  next();
});
```

### GPIO Erişimi

```bash
# Sadece pi kullanıcısı GPIO erişebilsin
sudo usermod -aG gpio pi
sudo chmod g+rw /dev/gpiomem
```

---

## 📞 Destek

Sorunlarla karşılaşırsan:

1. README.md dosyasını kontrol et
2. DIRECTORY_STRUCTURE.md yapıyı öğren
3. Logs dosyalarını kontrol et
4. GitHub Issues'e konu aç

---

## 📝 Versiyon Notları

**v1.0.0 (Mevcut)**
- ✅ Temel cihaz kontrolü
- ✅ REST API
- ✅ Flutter UI
- ✅ GPIO entegrasyonu
- ✅ İstatistikler

**v1.1.0 (Planlı)**
- 🔜 Bildirim sistemi
- 🔜 Zaman çizelgesi (Scheduling)
- 🔜 Otomasyon kuralları
- 🔜 WebSocket desteği
- 🔜 MQTT entegrasyonu

---

**Son Güncelleme**: 26 Mart 2024
**Sürüm**: 1.0.0
**Lisans**: MIT
