class Device {
  final String id;
  final String name;
  final String type; // light, temperature, door, motion, etc.
  final String location;
  bool status;
  double? value;
  String? unit;
  DateTime lastUpdated;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.status,
    this.value,
    this.unit,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? false,
      value: json['value']?.toDouble(),
      unit: json['unit'],
      lastUpdated: json['lastUpdated'] != null 
        ? DateTime.parse(json['lastUpdated'])
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'location': location,
    'status': status,
    'value': value,
    'unit': unit,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  Device copyWith({
    String? id,
    String? name,
    String? type,
    String? location,
    bool? status,
    double? value,
    String? unit,
    DateTime? lastUpdated,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      location: location ?? this.location,
      status: status ?? this.status,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
