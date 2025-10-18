import 'package:flutter_dotenv/flutter_dotenv.dart';


class Env {
  static const String spiroRouteLocal = String.fromEnvironment(
      'SPIRO_LOCAL_PATH',
      defaultValue: 'http://localhost:8080'
  );

  static const String spiroRouteProd = String.fromEnvironment(
      'SPIRO_PRODUCTION_PATH',
      defaultValue: 'http://192.168.1.59'
  );

  static const String apiKey = String.fromEnvironment(
      'API_KEY',
      defaultValue: 'user-api-key-12345'
  );

  static const String localisedAppVersion = String.fromEnvironment(
      'LOCALISED_APP_VERSION',
      defaultValue: '1.0.0'
  );
}