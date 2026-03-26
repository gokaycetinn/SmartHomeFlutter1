# SmartHome - Hızlı Başlangıç

## ⚡ 5 Dakika İçinde Başla

### 1. Backend'i Kurulum Yap

```bash
cd backend
npm install
npm start
```

Tarayıcıda açabilir: `http://localhost:3000/health`

### 2. Flutter Uygulamasını Çalıştır

```bash
cd smart_home
flutter pub get
flutter run
```

### 3. Cihazları Kontrol Et

Uygulamada:
- 🏠 **Anasayfa**: Cihazları göster ve kontrol et
- 📊 **İstatistikler**: Cihaz durumu analizi
- ⚙️ **Ayarlar**: API sunucusu konfigürasyonu

---

## 🔗 API Test Etkile

### cURL ile test et

```bash
# Tüm cihazları getir
curl http://localhost:3000/api/devices

# Salon Işığını aç
curl -X POST http://localhost:3000/api/devices/1/toggle \
  -H "Content-Type: application/json" \
  -d '{"status": true}'

# Işık yoğunluğunu %75'e ayarla
curl -X POST http://localhost:3000/api/devices/1/value \
  -H "Content-Type: application/json" \
  -d '{"value": 75}'
```

---

## 📱 Mobil Uygulamada

### Anasayfa Kullanımı

1. **Cihaz Kartı**: 
   - Tıkla → Aç/Kapat
   - Kaydır → Işık yoğunluğu ayarla
   - Uzun basıl → Detayları görüntüle

2. **Üst Bartaki Butonlar**:
   - 🔄 Yenile → Cihazları güncelle
   - ⚙️ Ayarlar → Yapılandırma

3. **Alt Menü**:
   - 🏠 Anasayfa
   - 📊 İstatistikler
   - ⚙️ Ayarlar

---

## 🛠️ Raspberry Pi Kurulumu

```bash
ssh pi@192.168.1.100

# Gerekli paketleri yükle
sudo apt-get update
sudo apt-get install -y python3-rpi.gpio python3-requests nodejs npm

# Projeyi klonla
git clone <repo> smarthome
cd smarthome

# Backend kurulumu
cd backend
npm install

# API'yi başlat
npm start
```

**Başka bir terminal'de:**

```bash
# GPIO Kontrolörü başlat
sudo python3 raspberry_pi/smarthome_controller.py
```

---

## 🔧 API Sunucusu Yapılandırması

`backend/.env` dosyasını düzenle:

```env
PORT=3000
NODE_ENV=development
RASPBERRY_PI_HOST=192.168.1.100
RASPBERRY_PI_USER=pi
RASPBERRY_PI_PASSWORD=raspberry
```

---

## 🐛 Yaygın Sorunlar

### 1. "API bağlantı hatası"
```bash
# API'nin çalışıp çalışmadığını kontrol et
curl http://localhost:3000/health
```

### 2. "Flutter emulator bağlanamıyor"
- `smart_home/lib/services/device_service.dart` açık
- `baseUrl` = `'http://10.0.2.2:3000/api'` (Android emulator)
- `baseUrl` = `'http://localhost:3000/api'` (iOS simulator)

### 3. "GPIO Permission Denied"
```bash
sudo usermod -aG gpio pi
```

---

## 📚 Daha Fazla Bilgi

- [Kurulum Kılavuzu](INSTALLATION_GUIDE.md)
- [Dizin Yapısı](DIRECTORY_STRUCTURE.md)
- [API Doksimanı](README.md)

---

## 🎯 Sonraki Adımlar

- [ ] Cihaz PIN'lerini konfigüre et
- [ ] API IP'sini Raspberry Pi'deki IP'e değiştir
- [ ] GPIO kontrolörünü test et
- [ ] Flutter uygulamasını build et
- [ ] Production'a deploy et

---

**Sürüm**: 1.0.0 | **Lisans**: MIT
