class BatteryHistoryRequest {
  String id;
  String batteryId;
  String action;
  String description;
  String timestamp;
  String performedBy;

  BatteryHistoryRequest({
    required this.id,
    required this.batteryId,
    required this.action,
    required this.description,
    required this.timestamp,
    required this.performedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batteryId': batteryId,
      'action': action,
      'description': description,
      'timestamp': timestamp,
      'performedBy': performedBy,
    };
  }

  factory BatteryHistoryRequest.fromJson(Map<String, dynamic> json) {
    return BatteryHistoryRequest(
      id: json['id'] ?? '',
      batteryId: json['batteryId'] ?? '',
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] ?? '',
      performedBy: json['performedBy'] ?? '',
    );
  }
}