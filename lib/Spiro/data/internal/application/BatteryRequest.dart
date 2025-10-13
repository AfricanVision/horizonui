class BatteryRequest {
  String id;
  String oem;
  String serialNumber;
  String createdBy;
  String batteryTypeId;

  BatteryRequest({
    required this.id,
    required this.oem,
    required this.serialNumber,
    required this.createdBy,
    required this.batteryTypeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oem': oem,
      'serialNumber': serialNumber,
      'createdBy': createdBy,
      'batteryTypeId': batteryTypeId,
    };
  }

  factory BatteryRequest.fromJson(Map<String, dynamic> json) {
    return BatteryRequest(
      id: json['id'] ?? '',
      oem: json['oem'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      createdBy: json['createdBy'] ?? '',
      batteryTypeId: json['batteryTypeId'] ?? '',
    );
  }
}