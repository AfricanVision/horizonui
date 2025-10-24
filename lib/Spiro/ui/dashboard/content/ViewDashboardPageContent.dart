import 'dart:convert';

import 'package:horizonui/Spiro/data/models/agent_model.dart';
import 'package:horizonui/Spiro/data/models/alert_model.dart';
import 'package:horizonui/Spiro/data/models/dashboard_data_model.dart';
import 'package:horizonui/Spiro/ui/dashboard/content/ConnectDashboardPageContent.dart';
import 'package:http/http.dart' as http;

import '../../parent/ParentViewModel.dart';

class ViewDashboardPageContent extends ParentViewModel {
  final String baseUrl = 'http://localhost:8080/api/dashboard';

  ConnectDashboardPageContent connection;

  ViewDashboardPageContent(super.context, this.connection);

  // API Methods
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
        throw Exception(
          'Failed to load dashboard data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  Future<List<DashboardAgent>> getOnShiftAgents() async {
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
        return data.map((item) => DashboardAgent.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load on-shift agents: ${response.statusCode}',
        );
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
