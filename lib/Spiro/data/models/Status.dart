class Status {
  String id;
  String name;
  String description;
  DateTime? created;

  Status({
    required this.id,
    required this.name,
    required this.created,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'updatedBy': description,
      'createdAt': created?.toIso8601String(),
    };
  }

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      created: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
