import 'Country.dart';
import 'StationType.dart';
import 'Status.dart';

class Station {
  String id;
  String name;
  double longitude;
  Status statusId;
  double latitude;
  String createdBy;
  String updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Country country;
  StationType stationType;

  Station({
    required this.id,
    required this.name,
    required this.longitude,
    required this.statusId,
    required this.latitude,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
    required this.stationType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'statusId': statusId,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'country': country,
      'stationType': stationType,
    };
  }

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      longitude: (json['longitude'] ?? 0).toDouble(),
      latitude: (json['latitude'] ?? 0).toDouble(),
      statusId: (json['statusId']),
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      country: (json['country']),
      stationType: (json['stationType']),
    );
  }
}
