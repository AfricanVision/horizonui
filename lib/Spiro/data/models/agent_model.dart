class DashboardAgent {
  final String id;
  final String name;
  final String station;
  final String status;
  final String shift;

  DashboardAgent({
    required this.id,
    required this.name,
    required this.station,
    required this.status,
    required this.shift,
  });

  factory DashboardAgent.fromJson(Map<String, dynamic> json) {
    return DashboardAgent(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      station: json['station'] ?? '',
      status: json['status'] ?? 'offline',
      shift: json['shift'] ?? '',
    );
  }
}
