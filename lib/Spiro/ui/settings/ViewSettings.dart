import 'package:horizonui/Spiro/data/models/settings_model.dart';

class SettingsViewModel {
  final String baseUrl = 'http://localhost:8080/api';

  Future<UserSettings> loadUserSettings(String userId) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.get(Uri.parse('$baseUrl/settings/$userId'));
      // if (response.statusCode == 200) {
      //   return UserSettings.fromJson(json.decode(response.body));
      // }

      // Mock default settings
      await Future.delayed(Duration(milliseconds: 500));
      return UserSettings(
        userId: userId,
        notificationsEnabled: true,
        emailNotifications: true,
        pushNotifications: false,
        autoBackup: true,
        twoFactorAuth: false,
        language: 'English',
        timezone: 'GMT+3 (East Africa Time)',
        theme: 'Light',
      );
    } catch (e) {
      throw Exception('Failed to load user settings: $e');
    }
  }

  Future<UserSettings> updateSettings(UserSettings settings) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.put(
      //   Uri.parse('$baseUrl/settings/${settings.userId}'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(settings.toJson()),
      // );
      // if (response.statusCode == 200) {
      //   return UserSettings.fromJson(json.decode(response.body));
      // }

      // Mock success response
      await Future.delayed(Duration(milliseconds: 500));
      return settings;
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  Future<void> resetToDefaults(String userId) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.post(Uri.parse('$baseUrl/settings/$userId/reset'));
      // if (response.statusCode != 200) {
      //   throw Exception('Failed to reset settings');
      // }

      // Mock success response
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to reset settings: $e');
    }
  }
}
