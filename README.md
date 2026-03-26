# SmartHome - Raspberry Pi 5 Entegreli Modern Akıllı Ev Uygulaması

## 📱 Proje Yapısı

```
SmartHome/
├── smart_home/              # Flutter Mobil Uygulaması
│   ├── lib/
│   │   ├── main.dart       # Ana uygulama
│   │   ├── models/         # Veri modelleri
│   │   ├── screens/        # UI ekranları
│   │   ├── services/       # API hizmetleri
│   │   └── widgets/        # Yeniden kullanılabilir bileşenler
│   └── pubspec.yaml        # Flutter bağımlılıkları
│
├── backend/                 # Express.js REST API
│   ├── server.js           # API sunucusu
│   ├── config/             # Konfigürasyon
│   ├── routes/             # API rotaları
│   └── package.json        # Node.js bağımlılıkları
│
├── raspberry_pi/           # Raspberry Pi 5 Kontrolü
│   └── smarthome_controller.py  # GPIO kontrolörü
│
├── install_rpi.sh          # Kurulum betiği
└── start.sh                # Başlama betiği
```

## 🚀 Başlangıç

### 1. Raspberry Pi Kurulumu

```bash
# SSH ile bağlan
ssh pi@192.168.1.100

# Kurulum betiğini indir ve çalıştır
bash install_rpi.sh
```

### 2. API Sunucusunu Başlat

```bash
cd backend
npm install
npm start
```

Sunucu `http://192.168.1.100:3000` adresinde çalışacak

### 3. GPIO Kontrolörünü Başlat

```bash
sudo python3 raspberry_pi/smarthome_controller.py
```

### 4. Flutter Uygulamasını Çalıştır

```bash
cd smart_home
flutter pub get
flutter run
```

## 📡 API Endpoints

### Cihazlar
- `GET /api/devices` - Tüm cihazları getir
- `GET /api/devices/:id` - Belirli cihazı getir
- `POST /api/devices/:id/toggle` - Cihazı aç/kapat
- `POST /api/devices/:id/value` - Cihaz değerini güncelle
- `POST /api/devices` - Yeni cihaz ekle
- `DELETE /api/devices/:id` - Cihazı sil

### Sistem
- `GET /health` - Sistem durumu
- `GET /api/status` - API durumu

## 🔌 GPIO Pin Tanımlamaları

| Cihaz ID | Adı | GPIO Pin | Tür | Fonksiyon |
|----------|-----|----------|-----|----------|
| 1 | Salon Işığı | 17 | Digital | Açık/Kapalı |
| 2 | Yatak Odası | 27 | Digital | Açık/Kapalı |
| 3 | Klima | 22 | PWM | 0-100% |
| 4 | Ön Kapı | 23 | Relay | Açık/Kapalı |
| 5 | Hareket Sensörü | 24 | Input | Okuma |

## 🎨 Mobil Uygulama Özelikleri

### Ana Ekran
- ✅ Cihaz kartları modern tasarımla
- ✅ Cihaz durumu göstergesi
- ✅ Gerçek zamanlı değer görüntüleme
- ✅ Hızlı erişim butonları

### Ayarlar Ekranı
- ✅ Bildirim yönetimi
- ✅ Görünüm tercihleri
- ✅ API sunucusu ayarları
- ✅ Bağlantı testi

### Özellikler
- 🌐 REST API entegrasyonu
- 📊 Cihaz istatistikleri
- 🔔 Bildirim sistemi
- 🌓 Koyu/Açık mod
- 📱 Responsive tasarım

## 🔧 Teknik Yığın

### Frontend
- Flutter 3.x
- Material Design 3
- Provider (State Management)
- HTTP (API İstemcisi)

### Backend
- Node.js 20+
- Express.js
- CORS middleware
- Body Parser

### Embedded
- Python 3
- RPi.GPIO
- Requests

## ⚙️ Sistem Gereksinimleri

### Yazılım
- Raspberry Pi OS (64-bit önerilir)
- Flutter SDK
- Node.js 20+
- Python 3.9+

### Donanım
- Raspberry Pi 5 (4GB minimum)
- MicroSD Kart (64GB önerilir)
- Power Supply (27W minimum)
- Ethernet veya WiFi

## 🔐 Güvenlik Notları

1. API sunucusunu firewall arkasında tutun
2. SSH anahtarı tabanlı kimlik doğrulama kullanın
3. API'ye token tabanlı yetkilendirme ekleyin
4. HTTPS kullanın (SSL/TLS)
5. Düzenli güncellemeleri yapın

## 📝 Lisans

MIT License

## 🤝 Katkıda Bulunma

Sorunları ve önerileri GitHub üzerinden bildirebilirsiniz.

## 📞 Destek

Teknik destek için:
- Email: support@smarthome.local
- Wiki: https://github.com/smarthome/wiki
