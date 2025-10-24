import 'package:horizonui/Spiro/data/models/incident_model.dart';

class IncidentViewModel {
  final String baseUrl = 'http://localhost:8080/api';

  // Mock data methods - will be replaced with actual API calls when backend is ready
  Future<List<String>> loadStations() async {
    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      // TODO: Replace with actual API call
      // final response = await http.get(Uri.parse('$baseUrl/stations'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((item) => item['name'] as String).toList();
      // }

      // Mock data for testing
      return [
        'Accra Central',
        'Lagos Island',
        'Nairobi CBD',
        'Kumasi Hub',
        'Tamale Station',
      ];
    } catch (e) {
      throw Exception('Failed to load stations: $e');
    }
  }

  Future<List<Incident>> loadIncidents() async {
    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 500));

      // TODO: Replace with actual API call
      // final response = await http.get(Uri.parse('$baseUrl/incidents'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((item) => Incident.fromJson(item)).toList();
      // }

      // Mock data for testing - returns empty list until backend is ready
      return [];
    } catch (e) {
      throw Exception('Failed to load incidents: $e');
    }
  }

  Future<Incident> createIncident(Incident incident) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('$baseUrl/incidents'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(incident.toJson()),
      // );
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return Incident.fromJson(json.decode(response.body));
      // }

      // Mock success response
      await Future.delayed(Duration(milliseconds: 500));
      return incident;
    } catch (e) {
      throw Exception('Failed to create incident: $e');
    }
  }

  Future<Incident> updateIncident(String incidentId, Incident incident) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.put(
      //   Uri.parse('$baseUrl/incidents/$incidentId'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(incident.toJson()),
      // );
      // if (response.statusCode == 200) {
      //   return Incident.fromJson(json.decode(response.body));
      // }

      // Mock success response
      await Future.delayed(Duration(milliseconds: 500));
      return incident;
    } catch (e) {
      throw Exception('Failed to update incident: $e');
    }
  }
}
