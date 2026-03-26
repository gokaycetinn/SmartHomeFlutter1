#!/usr/bin/env python3
"""
Raspberry Pi 5 SmartHome GPIO Controller
REST API ile haberleşen cihaz kontrolü
"""

import requests
import time
import json
from datetime import datetime
import RPi.GPIO as GPIO
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
import urllib.parse

# GPIO ayarları
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

# Cihaz PIN tanımlamaları
DEVICES_CONFIG = {
    '1': {'pin': 17, 'type': 'light'},      # Salon Işığı
    '2': {'pin': 27, 'type': 'light'},      # Yatak Odası Işığı
    '3': {'pin': 22, 'type': 'pwm'},        # Klima
    '4': {'pin': 23, 'type': 'relay'},      # Ön Kapı
    '5': {'pin': 24, 'type': 'sensor'},     # Hareket Sensörü
}

API_URL = 'http://192.168.1.100:3000/api'
UPDATE_INTERVAL = 5  # saniye

class SmartHomeController:
    def __init__(self):
        self.pwm_instances = {}
        self.device_states = {}
        self.setup_gpio()
        
    def setup_gpio(self):
        """GPIO pinlerini ayarla"""
        print("[GPIO] GPIO pinleri ayarlanıyor...")
        for device_id, config in DEVICES_CONFIG.items():
            pin = config['pin']
            device_type = config['type']
            
            if device_type in ['light', 'relay']:
                GPIO.setup(pin, GPIO.OUT)
                GPIO.output(pin, GPIO.LOW)
                print(f"[GPIO] Pin {pin} (Cihaz {device_id}) çıkış olarak ayarlandı")
            elif device_type == 'pwm':
                GPIO.setup(pin, GPIO.OUT)
                self.pwm_instances[device_id] = GPIO.PWM(pin, 1000)  # 1kHz
                self.pwm_instances[device_id].start(0)
                print(f"[GPIO] Pin {pin} (PWM - Cihaz {device_id}) ayarlandı")
            elif device_type == 'sensor':
                GPIO.setup(pin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
                print(f"[GPIO] Pin {pin} (Sensör - Cihaz {device_id}) giriş olarak ayarlandı")
    
    def control_device(self, device_id, value=None):
        """Cihazı kontrol et"""
        if device_id not in DEVICES_CONFIG:
            return False
        
        config = DEVICES_CONFIG[device_id]
        pin = config['pin']
        device_type = config['type']
        
        try:
            if device_type in ['light', 'relay']:
                # Açık/Kapalı cihazları kontrol et
                state = GPIO.HIGH if value else GPIO.LOW
                GPIO.output(pin, state)
                print(f"[DEVICE] Cihaz {device_id} {'AÇIK' if value else 'KAPALI'} yapıldı")
                return True
                
            elif device_type == 'pwm':
                # PWM cihazlarını kontrol et (0-100%)
                if device_id in self.pwm_instances and value is not None:
                    duty_cycle = max(0, min(100, value))
                    self.pwm_instances[device_id].ChangeDutyCycle(duty_cycle)
                    print(f"[PWM] Cihaz {device_id} %{duty_cycle} ayarlandı")
                    return True
                    
        except Exception as e:
            print(f"[ERROR] Cihaz {device_id} kontrol hatası: {e}")
            return False
        
        return False
    
    def read_sensor(self, device_id):
        """Sensörü oku"""
        if device_id not in DEVICES_CONFIG:
            return None
        
        config = DEVICES_CONFIG[device_id]
        pin = config['pin']
        device_type = config['type']
        
        try:
            if device_type == 'sensor':
                state = GPIO.input(pin)
                print(f"[SENSOR] Cihaz {device_id} Durumu: {state}")
                return state
                
        except Exception as e:
            print(f"[ERROR] Sensör {device_id} okuma hatası: {e}")
        
        return None
    
    def sync_with_api(self):
        """API ile durumu senkronize et"""
        try:
            response = requests.get(f'{API_URL}/devices', timeout=5)
            if response.status_code == 200:
                devices = response.json()
                print(f"[API] {len(devices)} cihaz API'den alındı")
                
                for device in devices:
                    device_id = device.get('id')
                    status = device.get('status')
                    value = device.get('value')
                    
                    if device_id in DEVICES_CONFIG:
                        if DEVICES_CONFIG[device_id]['type'] == 'pwm' and value:
                            self.control_device(device_id, value)
                        else:
                            self.control_device(device_id, status)
                            
        except requests.exceptions.RequestException as e:
            print(f"[API] Bağlantı hatası: {e}")
    
    def cleanup(self):
        """GPIO temizle"""
        print("[GPIO] GPIO temizleniyor...")
        GPIO.cleanup()

def sync_loop(controller):
    """Periyodik senkronizasyon döngüsü"""
    while True:
        try:
            controller.sync_with_api()
            time.sleep(UPDATE_INTERVAL)
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(f"[ERROR] Senkronizasyon döngüsü hatası: {e}")
            time.sleep(UPDATE_INTERVAL)

def main():
    """Ana program"""
    print("=" * 50)
    print("SmartHome Raspberry Pi Controller")
    print("=" * 50)
    
    controller = SmartHomeController()
    
    # Senkronizasyon döngüsünü başlat
    sync_thread = threading.Thread(target=sync_loop, args=(controller,), daemon=True)
    sync_thread.start()
    
    try:
        print("[SYSTEM] Sistem hazır. Kapatmak için Ctrl+C tuşu basınız...")
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[SYSTEM] Sistem kapatılıyor...")
        controller.cleanup()
        print("[SYSTEM] Sistem başarıyla kapatıldı")

if __name__ == '__main__':
    main()
