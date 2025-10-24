class Station {
  final String? id;
  final String name;
  final String country;
  final String attendant;
  final String status;
  final String createdBy;
  final String? updatedBy;
  final DateTime? timestamp;

  Station({
    this.id,
    required this.name,
    required this.country,
    required this.attendant,
    required this.status,
    required this.createdBy,
    this.updatedBy,
    this.timestamp,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      attendant: json['attendant'] ?? '',
      status: json['status'] ?? 'Active',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'country': country,
      'attendant': attendant,
      'status': status,
      'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    };
  }
}
