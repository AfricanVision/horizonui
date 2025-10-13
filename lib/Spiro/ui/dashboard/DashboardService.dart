import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl = 'http://localhost:8080/api/dashboard';

  Future<DashboardData> getDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('GET Dashboard Response Status: ${response.statusCode}');
      print('GET Dashboard Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return DashboardData.fromJson(data);
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  Future<List<Agent>> getOnShiftAgents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/on-shift-agents'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Agent.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load on-shift agents: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading on-shift agents: $e');
      throw Exception('Failed to load on-shift agents: $e');
    }
  }

  Future<List<Alert>> getActiveAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/active-alerts'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Alert.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load active alerts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading active alerts: $e');
      throw Exception('Failed to load active alerts: $e');
    }
  }
}

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

class Agent {
  final String id;
  final String name;
  final String station;
  final String status;
  final String shift;

  Agent({
    required this.id,
    required this.name,
    required this.station,
    required this.status,
    required this.shift,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      station: json['station'] ?? '',
      status: json['status'] ?? 'offline',
      shift: json['shift'] ?? '',
    );
  }
}

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