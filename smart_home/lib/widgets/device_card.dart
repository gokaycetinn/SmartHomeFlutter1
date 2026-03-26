import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../services/device_service.dart';
import '../screens/device_detail_screen.dart';

class DeviceCard extends StatefulWidget {
  final Device device;

  const DeviceCard({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sliderValue = widget.device.value ?? 0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getDeviceIcon() {
    switch (widget.device.type) {
      case 'light':
        return widget.device.status ? Icons.lightbulb : Icons.lightbulb_outline;
      case 'temperature':
        return Icons.thermostat;
      case 'door':
        return widget.device.status
            ? Icons.door_front_door
            : Icons.door_front_door_outlined;
      case 'motion':
        return Icons.motion_photos_on;
      case 'plug':
        return Icons.power_settings_new;
      default:
        return Icons.devices;
    }
  }

  Color _getDeviceColor() {
    switch (widget.device.type) {
      case 'light':
        return Colors.amber;
      case 'temperature':
        return Colors.blue;
      case 'door':
        return Colors.brown;
      case 'motion':
        return Colors.purple;
      case 'plug':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getDeviceColor();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DeviceDetailScreen(device: widget.device),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (['light', 'door', 'plug'].contains(widget.device.type)) {
              context
                  .read<DeviceService>()
                  .toggleDevice(widget.device);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.device.status ? color : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getDeviceIcon(),
                        color: widget.device.status
                            ? Colors.white
                            : Colors.grey.shade600,
                        size: 28,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.device.status
                            ? Colors.green.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.device.status ? 'Açık' : 'Kapalı',
                        style: TextStyle(
                          color: widget.device.status
                              ? Colors.green.shade700
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.device.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.device.location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                if (widget.device.type == 'light' &&
                    widget.device.value != null) ...[
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.device.value?.toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: color,
                          inactiveTrackColor: color.withOpacity(0.2),
                          thumbColor: color,
                        ),
                        child: Slider(
                          value: _sliderValue,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() => _sliderValue = value);
                            context
                                .read<DeviceService>()
                                .updateDeviceValue(widget.device, value);
                          },
                        ),
                      ),
                    ],
                  ),
                ] else if (widget.device.value != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.device.value?.toStringAsFixed(1)}${widget.device.unit ?? ''}',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                      ),
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.grey.shade600),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Son güncelleme: ${widget.device.lastUpdated.hour}:${widget.device.lastUpdated.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
