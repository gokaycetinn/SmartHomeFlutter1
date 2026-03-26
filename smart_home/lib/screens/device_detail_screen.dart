import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late Device device;

  @override
  void initState() {
    super.initState();
    device = widget.device;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cihaz Kartı
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(),
                      size: 64,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    device.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    device.location,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Durum Bilgisi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durum',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Geçerli Durum'),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: device.status ? Colors.green.shade100 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              device.status ? 'AÇIK' : 'KAPALI',
                              style: TextStyle(
                                color: device.status ? Colors.green.shade700 : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (device.value != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Değer'),
                            const SizedBox(height: 4),
                            Text(
                              '${device.value}${device.unit ?? ''}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Detaylı Bilgi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detaylar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Cihaz ID'),
                    trailing: Text(device.id),
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                  ListTile(
                    title: const Text('Tür'),
                    trailing: Text(device.type),
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                  ListTile(
                    title: const Text('Konum'),
                    trailing: Text(device.location),
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                  ListTile(
                    title: const Text('Son Güncelleme'),
                    trailing: Text(
                      '${device.lastUpdated.hour}:${device.lastUpdated.minute.toString().padLeft(2, '0')}',
                    ),
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // İşlem Butonları
          ElevatedButton.icon(
            onPressed: () {
              // Cihazı düzenle
            },
            icon: const Icon(Icons.edit),
            label: const Text('Düzenle'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              // Cihazı sil
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (device.type) {
      case 'light':
        return Icons.lightbulb;
      case 'temperature':
        return Icons.thermostat;
      case 'door':
        return Icons.door_front_door;
      case 'motion':
        return Icons.motion_photos_on;
      case 'plug':
        return Icons.power_settings_new;
      default:
        return Icons.devices;
    }
  }
}
