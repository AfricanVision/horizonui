class DashboardData {
  final int activeAgents;
  final int swapsToday;
  final int totalSwaps;
  final int activeIssues;
  final double downtimePercentage;
  final double powerUsage;
  final double powerUsage14DayAvg;
  final String targetSwaps;

  DashboardData({
    required this.activeAgents,
    required this.swapsToday,
    required this.totalSwaps,
    required this.activeIssues,
    required this.downtimePercentage,
    required this.powerUsage,
    required this.powerUsage14DayAvg,
    required this.targetSwaps,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      activeAgents: json['activeAgents'] ?? 0,
      swapsToday: json['swapsToday'] ?? 0,
      totalSwaps: json['totalSwaps'] ?? 0,
      activeIssues: json['activeIssues'] ?? 0,
      downtimePercentage: json['downtimePercentage']?.toDouble() ?? 0.0,
      powerUsage: json['powerUsage']?.toDouble() ?? 0.0,
      powerUsage14DayAvg: json['powerUsage14DayAvg']?.toDouble() ?? 0.0,
      targetSwaps: json['targetSwaps']?.toString() ?? '100,000',
    );
  }
}
