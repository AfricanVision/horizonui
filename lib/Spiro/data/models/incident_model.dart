class Incident {
  final String? id;
  final String incidentType;
  final String priority;
  final String status;
  final String? station;
  final String? assignedTo;
  final String? customerName;
  final String? vehicleId;
  final String? batteryId;
  final String description;
  final String? reporterContact;
  final String timestamp;
  final String reportedBy;
  final List<String>? photoUrls;

  Incident({
    this.id,
    required this.incidentType,
    required this.priority,
    required this.status,
    this.station,
    this.assignedTo,
    this.customerName,
    this.vehicleId,
    this.batteryId,
    required this.description,
    this.reporterContact,
    required this.timestamp,
    required this.reportedBy,
    this.photoUrls,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
      incidentType: json['incidentType'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      station: json['station'],
      assignedTo: json['assignedTo'],
      customerName: json['customerName'],
      vehicleId: json['vehicleId'],
      batteryId: json['batteryId'],
      description: json['description'] ?? '',
      reporterContact: json['reporterContact'],
      timestamp: json['timestamp'] ?? '',
      reportedBy: json['reportedBy'] ?? '',
      photoUrls: json['photoUrls'] != null
          ? List<String>.from(json['photoUrls'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'incidentType': incidentType,
      'priority': priority,
      'status': status,
      if (station != null) 'station': station,
      if (assignedTo != null) 'assignedTo': assignedTo,
      if (customerName != null) 'customerName': customerName,
      if (vehicleId != null) 'vehicleId': vehicleId,
      if (batteryId != null) 'batteryId': batteryId,
      'description': description,
      if (reporterContact != null) 'reporterContact': reporterContact,
      'timestamp': timestamp,
      'reportedBy': reportedBy,
      if (photoUrls != null) 'photoUrls': photoUrls,
    };
  }
}
