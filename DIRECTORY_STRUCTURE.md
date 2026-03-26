# SmartHome Dizin Yapısı ve Açıklamalar

## Flutter Uygulaması (`smart_home/`)

### Main Entry Point (`lib/main.dart`)
- MultiProvider ile state management
- Material Design 3 tema
- Light/Dark mode desteği

### Models (`lib/models/`)
- **device.dart** - Device veri modeli

### Services (`lib/services/`)
- **device_service.dart** - API haberleşmesi ve cihaz yönetimi
  - HTTP istekleri yönetir
  - State değişiklikleri publish eder
  - Mock data fallback sundar

### Screens (`lib/screens/`)
- **home_screen.dart** - Ana dashboard
  - Aktif/Pasif cihaz sayıcı
  - Cihaz grid gösterimi
  - Pull-to-refresh desteği

- **settings_screen.dart** - Ayarlar ekranı
  - Bildirim yönetimi
  - Tema seçimi
  - API sunucusu ayarları

### Widgets (`lib/widgets/`)
- **device_card.dart** - Cihaz kartı bileşeni
  - Durum göstergesi
  - Değer gösterimi
  - Gölge ve animasyonlar

- **device_grid.dart** - Cihaz grid layout
  - Responsive 2-sütun tasarım
  - Boş durum gösterimi

## Backend API (`backend/`)

### Server (`server.js`)
- Express sunucusu
- CORS ve middleware ayarları
- Error handling
- Health check endpoint

### Routes (`routes/devices.js`)
- GET /devices - Tüm cihazları getir
- POST /devices/:id/toggle - Durumu değiştir
- POST /devices/:id/value - Değer güncelle
- POST /devices - Yeni cihaz ekle
- DELETE /devices/:id - Cihazı sil

### Config (`config/devices.js`)
- Mock cihaz veritabanı
- PIN tanımlamaları
- Varsayılan durum değerleri

## Raspberry Pi Controller (`raspberry_pi/`)

### Python Script (`smarthome_controller.py`)
- GPIO pinleri ayarlar
- API ile senkronizasyon
- Cihaz kontrolü
  - Digital output (LED, Relay)
  - PWM (Işık yoğunluğu, Hız)
  - Sensor input (Motion, Temperature)

## Yapılandırma Dosyaları

### `.env` - Ortam Değişkenleri
```
PORT=3000
NODE_ENV=development
RASPBERRY_PI_HOST=192.168.1.100
```

### `pubspec.yaml` - Flutter Bağımlılıkları
- provider - State management
- http - HTTP requests
- cupertino_icons - iOS simgeleri
- intl - Uluslararasılaştırma

### `package.json` - Node.js Bağımlılıkları
- express - Web framework
- cors - CORS middleware
- body-parser - JSON parsing
- dotenv - Environment yönetimi

## Kurulum ve Çalıştırma

### 1. Raspberry Pi'de
```bash
bash install_rpi.sh
bash start.sh
```

### 2. Geliştirme Bilgisayarında
```bash
# Flutter uygulaması
cd smart_home
flutter pub get
flutter run

# API sunucusu (isteğe bağlı)
cd backend
npm install
npm start
```

## API Sunucusu IP Adresi
Flutter uygulamasında API sunucusunun IP'sini değiştirmek için:

`lib/services/device_service.dart` dosyasında:
```dart
static const String baseUrl = 'http://YOUR_PI_IP:3000/api';
```

## Cihaz Tipleri
- `light` - LED ışık (Digital)
- `temperature` - Klima (PWM)
- `door` - Kapı kilit (Relay)
- `motion` - Hareket sensörü (Input)
- `plug` - Akım prizi (Relay)
