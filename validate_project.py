#!/usr/bin/env python3
"""
SmartHome Proje Doğrulama Betiği
Proje yapısı ve dosyaları kontrol et
"""

import os
import json
from pathlib import Path

class ProjectValidator:
    def __init__(self, base_path):
        self.base_path = Path(base_path)
        self.results = {
            'total': 0,
            'passed': 0,
            'failed': 0,
            'warnings': []
        }
    
    def check_file_exists(self, file_path, required=True):
        """Dosyanın var olup olmadığını kontrol et"""
        full_path = self.base_path / file_path
        exists = full_path.exists()
        status = "✅" if exists else ("⚠️" if not required else "❌")
        
        print(f"{status} {file_path}")
        self.results['total'] += 1
        
        if exists:
            self.results['passed'] += 1
        elif required:
            self.results['failed'] += 1
        else:
            self.results['warnings'].append(f"Optional file missing: {file_path}")
    
    def check_directory_exists(self, dir_path):
        """Klasörün var olup olmadığını kontrol et"""
        full_path = self.base_path / dir_path
        exists = full_path.is_dir()
        status = "✅" if exists else "❌"
        
        print(f"{status} {dir_path}/")
        self.results['total'] += 1
        
        if exists:
            self.results['passed'] += 1
        else:
            self.results['failed'] += 1
    
    def validate_json(self, file_path):
        """JSON dosyasının geçerliliğini kontrol et"""
        full_path = self.base_path / file_path
        try:
            with open(full_path, 'r') as f:
                json.load(f)
            print(f"✅ {file_path} (valid JSON)")
            self.results['passed'] += 1
        except Exception as e:
            print(f"❌ {file_path} (invalid JSON: {e})")
            self.results['failed'] += 1
        self.results['total'] += 1
    
    def run_validation(self):
        """Tüm doğrulamaları çalıştır"""
        print("\n" + "="*60)
        print("SmartHome Proje Doğrulama")
        print("="*60 + "\n")
        
        print("📁 Klasör Yapısı:")
        self.check_directory_exists("smart_home")
        self.check_directory_exists("backend")
        self.check_directory_exists("raspberry_pi")
        
        print("\n📱 Flutter Dosyaları:")
        self.check_file_exists("smart_home/pubspec.yaml")
        self.check_file_exists("smart_home/lib/main.dart")
        self.check_file_exists("smart_home/lib/models/device.dart")
        self.check_file_exists("smart_home/lib/services/device_service.dart")
        self.check_file_exists("smart_home/lib/screens/home_screen.dart")
        self.check_file_exists("smart_home/lib/screens/settings_screen.dart")
        self.check_file_exists("smart_home/lib/screens/statistics_screen.dart")
        self.check_file_exists("smart_home/lib/screens/device_detail_screen.dart")
        self.check_file_exists("smart_home/lib/widgets/device_card.dart")
        self.check_file_exists("smart_home/lib/widgets/device_grid.dart")
        
        print("\n🔌 Backend Dosyaları:")
        self.check_file_exists("backend/package.json")
        self.check_file_exists("backend/server.js")
        self.check_file_exists("backend/routes/devices.js")
        self.check_file_exists("backend/config/devices.js")
        self.check_file_exists("backend/.env")
        
        print("\n🖥️ Raspberry Pi Dosyaları:")
        self.check_file_exists("raspberry_pi/smarthome_controller.py")
        
        print("\n📚 Doksimanlar:")
        self.check_file_exists("README.md")
        self.check_file_exists("INSTALLATION_GUIDE.md")
        self.check_file_exists("QUICKSTART.md")
        self.check_file_exists("PROJECT_SUMMARY.md")
        self.check_file_exists("DIRECTORY_STRUCTURE.md")
        
        print("\n⚙️ Kurulum Dosyaları:")
        self.check_file_exists("install.bat")
        self.check_file_exists("start.bat")
        self.check_file_exists("install_rpi.sh", required=False)
        self.check_file_exists("start.sh", required=False)
        
        print("\n🔍 JSON Doğrulaması:")
        self.validate_json("backend/package.json")
        self.validate_json("extension.json")
        
        print("\n" + "="*60)
        print("SONUÇLAR")
        print("="*60)
        print(f"Toplam: {self.results['total']}")
        print(f"Başarılı: {self.results['passed']} ✅")
        print(f"Başarısız: {self.results['failed']} ❌")
        
        if self.results['warnings']:
            print(f"\nUyarılar:")
            for warning in self.results['warnings']:
                print(f"  ⚠️ {warning}")
        
        status = "✅ BAŞARILI" if self.results['failed'] == 0 else "❌ BAŞARISIZ"
        print(f"\nDurumu: {status}\n")
        
        return self.results['failed'] == 0

if __name__ == "__main__":
    base_path = os.path.dirname(os.path.abspath(__file__))
    validator = ProjectValidator(base_path)
    success = validator.run_validation()
    exit(0 if success else 1)
