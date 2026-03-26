#!/bin/bash
# SmartHome Başlama Betiği

echo "=========================================="
echo "SmartHome Sistemi Başlatılıyor..."
echo "=========================================="

# API sunucusunu başlat
echo "[1/2] API sunucusu başlatılıyor (Port 3000)..."
cd backend
npm start &
API_PID=$!

# GPIO kontrolörü başlat
echo "[2/2] GPIO kontrolörü başlatılıyor..."
sudo python3 raspberry_pi/smarthome_controller.py &
GPIO_PID=$!

echo "=========================================="
echo "SmartHome Sistemi Çalışıyor!"
echo "API PID: $API_PID"
echo "GPIO PID: $GPIO_PID"
echo "=========================================="

# Her iki prosesi takip et
wait $API_PID $GPIO_PID
