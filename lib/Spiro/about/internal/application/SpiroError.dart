
import 'Severity.dart';

class SpiroError {
  double code;
  String message;
  String helper;
  String title;
  String severity;

  SpiroError({required this.code, required this.message, required this.helper,  required this.title,  required this.severity});

  factory SpiroError.fromJson(Map<String, dynamic> json) {

    return SpiroError(
      code: json['code'],
      message: json['message'],
      helper: json['helper'],
      title: json['title'],
      severity: json['severity'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['helper'] = helper;
    data['title'] = title;
    data['severity'] = severity;
    return data;
  }

  Severity getSeverityEnum(String severityString) {
    for (Severity severity in Severity.values) {
      if (severityString == severity.name) {
        return severity;
      }
    }
    return Severity.error;
  }
}