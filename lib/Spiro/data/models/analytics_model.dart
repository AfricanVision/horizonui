class AnalyticsData {
  final int totalSwaps;
  final int swapsToday;
  final double avgSwapTime;
  final double peakHourUtilization;
  final int activeBatteries;
  final double avgBatteryHealth;
  final int totalRevenue;
  final double customerSatisfaction;

  AnalyticsData({
    required this.totalSwaps,
    required this.swapsToday,
    required this.avgSwapTime,
    required this.peakHourUtilization,
    required this.activeBatteries,
    required this.avgBatteryHealth,
    required this.totalRevenue,
    required this.customerSatisfaction,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      totalSwaps: json['totalSwaps'] ?? 0,
      swapsToday: json['swapsToday'] ?? 0,
      avgSwapTime: (json['avgSwapTime'] ?? 0).toDouble(),
      peakHourUtilization: (json['peakHourUtilization'] ?? 0).toDouble(),
      activeBatteries: json['activeBatteries'] ?? 0,
      avgBatteryHealth: (json['avgBatteryHealth'] ?? 0).toDouble(),
      totalRevenue: json['totalRevenue'] ?? 0,
      customerSatisfaction: (json['customerSatisfaction'] ?? 0).toDouble(),
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }
}
