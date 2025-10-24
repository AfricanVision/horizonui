class Alert {
  final String title;
  final String description;
  final String location;
  final String time;
  final String type;

  Alert({
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.type,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? 'info',
    );
  }
}
