@echo off
REM SmartHome Kurulum Betiği - Windows

echo ==========================================
echo SmartHome Kurulumu - Windows
echo ==========================================
echo.

REM Node.js paketleri yükle
echo [1/3] Backend bağımlılıkları yükleniyor...
cd backend
call npm install

if %errorlevel% neq 0 (
    echo ERROR: npm install başarısız
    pause
    exit /b 1
)

REM Raspberry Pi klasörü kontrol et
echo [2/3] Proje yapısı kontrol ediliyor...
if not exist "raspberry_pi\smarthome_controller.py" (
    echo ERROR: Raspberry Pi script bulunamadı
    pause
    exit /b 1
)

echo [3/3] Tamamlandı!
echo.
echo ==========================================
echo Kurulum başarılı!
echo ==========================================
echo.
echo Başlatmak için:
echo   Backend: npm start (backend klasöründen)
echo   Frontend: flutter run (smart_home klasöründen)
echo   RPi: python3 raspberry_pi\smarthome_controller.py
echo.
pause
