import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/device.dart';

class DeviceService extends ChangeNotifier {
  static const String baseUrl = 'http://192.168.1.100:3000/api';
  
  List<Device> _devices = [];
  bool _isLoading = false;
  String? _error;

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDevices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devices'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _devices = data.map((json) => Device.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Cihazlar yüklenemedi: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Bağlantı hatası: $e';
      // Offline mod için örnek verileri kullan
      _loadMockData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDevice(Device device) async {
    try {
      final newStatus = !device.status;
      final response = await http.post(
        Uri.parse('$baseUrl/devices/${device.id}/toggle'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final updatedDevice = Device.fromJson(jsonDecode(response.body));
        final index = _devices.indexWhere((d) => d.id == device.id);
        if (index != -1) {
          _devices[index] = updatedDevice;
          notifyListeners();
        }
      } else {
        _error = 'Cihaz durumu değiştirilemiyor';
      }
    } catch (e) {
      _error = 'İşlem başarısız: $e';
      notifyListeners();
    }
  }

  Future<void> updateDeviceValue(Device device, double value) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/devices/${device.id}/value'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': value}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final updatedDevice = Device.fromJson(jsonDecode(response.body));
        final index = _devices.indexWhere((d) => d.id == device.id);
        if (index != -1) {
          _devices[index] = updatedDevice;
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Değer güncellenemedi: $e';
      notifyListeners();
    }
  }

  Future<void> createDevice(Device device) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/devices'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(device.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final newDevice = Device.fromJson(jsonDecode(response.body));
        _devices.add(newDevice);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Cihaz eklenemedi: $e';
      notifyListeners();
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/devices/$deviceId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _devices.removeWhere((d) => d.id == deviceId);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Cihaz silinemedi: $e';
      notifyListeners();
    }
  }

  void _loadMockData() {
    _devices = [
      Device(
        id: '1',
        name: 'Salon Işığı',
        type: 'light',
        location: 'Salon',
        status: true,
        value: 85,
        unit: '%',
      ),
      Device(
        id: '2',
        name: 'Yatak Odası Işığı',
        type: 'light',
        location: 'Yatak Odası',
        status: false,
      ),
      Device(
        id: '3',
        name: 'Klima',
        type: 'temperature',
        location: 'Salon',
        status: true,
        value: 22,
        unit: '°C',
      ),
      Device(
        id: '4',
        name: 'Ön Kapı',
        type: 'door',
        location: 'Giriş',
        status: false,
      ),
      Device(
        id: '5',
        name: 'Hareket Sensörü',
        type: 'motion',
        location: 'Koridor',
        status: true,
      ),
    ];
  }

  Future<Map<String, dynamic>> getSystemStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/status'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'status': 'offline'};
    } catch (e) {
      return {'status': 'offline', 'error': e.toString()};
    }
  }
}
