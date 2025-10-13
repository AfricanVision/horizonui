import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:horizonui/Spiro/data/internal/application/Agents.dart';


class AgentService {
  final String baseUrl = 'http://localhost:8080/api';
  final String apikey = 'admin-api-key-67890';


  Future<List<Agent>> getAgents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/agents'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-KEY': apikey
        },
      );

      print('GET Agents Response Status: ${response.statusCode}');
      print('GET Agents Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Agent.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load agents: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error loading agents: $e');
      throw Exception('Failed to load agents: $e');
    }
  }

  Future<Agent> addAgent(Agent agent) async {
    try {
      final Map<String, dynamic> requestBody = {
        'firstname': agent.firstname,
        'middlename': agent.middlename,
        'lastname': agent.lastname,
        'dob': agent.dob,
        'nationality': agent.nationality,
        'identification': agent.identification,
        'phonenumber': agent.phonenumber,
        'email': agent.email,
        'statusId': agent.statusId,
        'createdBy': agent.createdBy,
      };

      print('Sending agent data: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/agents'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-KEY': apikey
        },
        body: json.encode(requestBody),
      );

      print('POST Agent Response Status: ${response.statusCode}');
      print('POST Agent Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Agent.fromJson(responseData);
      } else {
        throw Exception('Failed to add agent: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error adding agent: $e');
      throw Exception('Failed to add agent: $e');
    }
  }

  Future<Agent> updateAgent(String agentId, Agent agent) async {
    try {
      final Map<String, dynamic> requestBody = {
        "firstname": "John",
        "middlename": "Michael",
        "lastname": "Doe",
        "dob": "1990-05-15",
        "nationality": "Kenyan",
        "identification": "A123456789",
        "phonenumber": "255712345678",
        "email": "john.doe@example.com",
        "statusId": "active-status-id",
        "createdBy": "admin",
        "updatedBy": "admin"
      };

      print('Updating agent data: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/agents/update'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('UPDATE Agent Response Status: ${response.statusCode}');
      print('UPDATE Agent Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Agent.fromJson(responseData);
      } else {
        throw Exception('Failed to update agent: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error updating agent: $e');
      throw Exception('Failed to update agent: $e');
    }
  }




}