#!/bin/bash
# Raspberry Pi 5 SmartHome Kurulum Betiği

echo "=========================================="
echo "SmartHome Kurulumu - Raspberry Pi 5"
echo "=========================================="

# Sistem güncellemeleri
echo "[1/5] Sistem güncellemeleri yapılıyor..."
sudo apt-get update
sudo apt-get upgrade -y

# Python bağımlılıkları
echo "[2/5] Python bağımlılıkları yükleniyor..."
sudo apt-get install -y python3-pip python3-rpi.gpio python3-requests

# PyYAML yükle
echo "[3/5] Python paketleri yükleniyor..."
pip3 install RPi.GPIO requests pyyaml

# Node.js yükle (API sunucusu için)
echo "[4/5] Node.js yükleniyor..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# API sunucusu paketleri yükle
echo "[5/5] API sunucusu paketleri yükleniyor..."
cd backend
npm install

echo "=========================================="
echo "Kurulum tamamlandı!"
echo "=========================================="
echo ""
echo "Başlatmak için:"
echo "  API Sunucusu: cd backend && npm start"
echo "  GPIO Controller: sudo python3 raspberry_pi/smarthome_controller.py"
