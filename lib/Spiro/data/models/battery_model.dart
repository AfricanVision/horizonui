class Battery {
  final String? id;
  final String oem;
  final String serialNumber;
  final String batteryTypeId;
  final String? status;
  final int? chargeLevel;
  final int? cycleCount;
  final String? health;
  final DateTime? lastSwapDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Battery({
    this.id,
    required this.oem,
    required this.serialNumber,
    required this.batteryTypeId,
    this.status,
    this.chargeLevel,
    this.cycleCount,
    this.health,
    this.lastSwapDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      id: json['id'],
      oem: json['oem'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      batteryTypeId: json['batteryTypeId'] ?? '',
      status: json['status'],
      chargeLevel: json['chargeLevel'],
      cycleCount: json['cycleCount'],
      health: json['health'],
      lastSwapDate: json['lastSwapDate'] != null
          ? DateTime.parse(json['lastSwapDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'oem': oem,
      'serialNumber': serialNumber,
      'batteryTypeId': batteryTypeId,
      if (status != null) 'status': status,
      if (chargeLevel != null) 'chargeLevel': chargeLevel,
      if (cycleCount != null) 'cycleCount': cycleCount,
      if (health != null) 'health': health,
      if (lastSwapDate != null) 'lastSwapDate': lastSwapDate!.toIso8601String(),
    };
  }
}

class BatteryStats {
  final int totalBatteries;
  final int availableBatteries;
  final int inUseBatteries;
  final int chargingBatteries;
  final int maintenanceBatteries;
  final double averageHealth;
  final double utilizationRate;

  BatteryStats({
    required this.totalBatteries,
    required this.availableBatteries,
    required this.inUseBatteries,
    required this.chargingBatteries,
    required this.maintenanceBatteries,
    required this.averageHealth,
    required this.utilizationRate,
  });

  factory BatteryStats.fromJson(Map<String, dynamic> json) {
    return BatteryStats(
      totalBatteries: json['totalBatteries'] ?? 0,
      availableBatteries: json['availableBatteries'] ?? 0,
      inUseBatteries: json['inUseBatteries'] ?? 0,
      chargingBatteries: json['chargingBatteries'] ?? 0,
      maintenanceBatteries: json['maintenanceBatteries'] ?? 0,
      averageHealth: (json['averageHealth'] ?? 0).toDouble(),
      utilizationRate: (json['utilizationRate'] ?? 0).toDouble(),
    );
  }
}
