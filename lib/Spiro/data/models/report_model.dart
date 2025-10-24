class Report {
  final String id;
  final String title;
  final String description;
  final String category;
  final String period;
  final DateTime? lastGenerated;
  final String format;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.period,
    this.lastGenerated,
    required this.format,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      period: json['period'] ?? '',
      lastGenerated: json['lastGenerated'] != null
          ? DateTime.parse(json['lastGenerated'])
          : null,
      format: json['format'] ?? 'PDF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'period': period,
      if (lastGenerated != null)
        'lastGenerated': lastGenerated!.toIso8601String(),
      'format': format,
    };
  }
}
