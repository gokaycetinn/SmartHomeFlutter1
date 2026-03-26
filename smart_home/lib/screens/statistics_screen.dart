import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/device_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
      ),
      body: Consumer<DeviceService>(
        builder: (context, deviceService, _) {
          final devices = deviceService.devices;
          final activeDevices = devices.where((d) => d.status).length;
          final totalDevices = devices.length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Özet Kartları
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Aktif Cihazlar',
                      value: activeDevices.toString(),
                      subtitle: '$totalDevices / $totalDevices',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Pasif Cihazlar',
                      value: (totalDevices - activeDevices).toString(),
                      subtitle: 'Kapalı',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Cihaz Tipleri Grafiği
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cihaz Türleri',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: _buildPieChartSections(devices),
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cihaz Listesi
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cihaz Detayları',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...devices.map((device) => Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              device.status ? Icons.check_circle : Icons.cancel,
                              color: device.status ? Colors.green : Colors.grey,
                            ),
                            title: Text(device.name),
                            subtitle: Text(device.location),
                            trailing: device.value != null
                              ? Text('${device.value}${device.unit ?? ''}')
                              : null,
                          ),
                          const Divider(height: 0),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(devices) {
    final types = <String, int>{};
    final colors = <String, Color>{
      'light': Colors.amber,
      'temperature': Colors.blue,
      'door': Colors.brown,
      'motion': Colors.purple,
      'plug': Colors.red,
    };

    for (var device in devices) {
      types[device.type] = (types[device.type] ?? 0) + 1;
    }

    int index = 0;
    return types.entries.map((entry) {
      final section = PieChartSectionData(
        color: colors[entry.key] ?? Colors.grey,
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: 50,
      );
      index++;
      return section;
    }).toList();
  }
}
