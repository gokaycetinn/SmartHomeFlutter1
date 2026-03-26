import 'package:flutter/material.dart';
import '../models/device.dart';
import 'device_card.dart';

class DeviceGrid extends StatelessWidget {
  final List<Device> devices;

  const DeviceGrid({Key? key, required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.devices_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Hiç cihaz bulunamadı'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Cihaz Ekle'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) => DeviceCard(device: devices[index]),
    );
  }
}
