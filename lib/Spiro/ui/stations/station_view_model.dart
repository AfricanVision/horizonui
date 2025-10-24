import 'package:horizonui/Spiro/data/models/station_model.dart';

class StationViewModel {
  final String baseUrl = 'http://localhost:8080/api';

  Future<List<Station>> loadStations() async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.get(Uri.parse('$baseUrl/stations'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((item) => Station.fromJson(item)).toList();
      // }

      // Mock data for testing
      await Future.delayed(Duration(milliseconds: 500));
      return [];
    } catch (e) {
      throw Exception('Failed to load stations: $e');
    }
  }

  Future<Station> addStation(Station station) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('$baseUrl/stations'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(station.toJson()),
      // );
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return Station.fromJson(json.decode(response.body));
      // }

      // Mock success response
      await Future.delayed(Duration(milliseconds: 500));
      return station;
    } catch (e) {
      throw Exception('Failed to add station: $e');
    }
  }

  Future<Station> updateStation(String stationId, Station station) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.put(
      //   Uri.parse('$baseUrl/stations/$stationId'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(station.toJson()),
      // );
      // if (response.statusCode == 200) {
      //   return Station.fromJson(json.decode(response.body));
      // }

      // Mock success response
      await Future.delayed(Duration(milliseconds: 500));
      return station;
    } catch (e) {
      throw Exception('Failed to update station: $e');
    }
  }

  Future<void> deleteStation(String stationId) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.delete(Uri.parse('$baseUrl/stations/$stationId'));
      // if (response.statusCode != 200 && response.statusCode != 204) {
      //   throw Exception('Failed to delete station');
      // }

      // Mock success response
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to delete station: $e');
    }
  }
}
