@echo off
REM SmartHome Başlama Betiği - Windows

echo ==========================================
echo SmartHome Sistemi Başlatılıyor...
echo ==========================================
echo.

REM API Sunucusunu başlat
echo [1/2] API Sunucusu başlatılıyor (Port 3000)...
start "SmartHome API" cmd /k "cd backend && npm start"

echo [2/2] Bekletiliyor...
timeout /t 3

echo.
echo ==========================================
echo SmartHome API Çalışıyor!
echo ==========================================
echo.
echo API Adresi: http://localhost:3000
echo API Docs: http://localhost:3000/health
echo.
echo Uygulamayı başlatmak için flutter run komutunu çalıştırın
echo.
pause
