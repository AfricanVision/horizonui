import 'package:flutter_dotenv/flutter_dotenv.dart';


String spiroRouteProd = dotenv.get('spiro_PRODUCTION_PATH', fallback: '');

String spiroRouteLocal = dotenv.get('spiro_LOCAL_PATH', fallback: '');

String localisedAppVersion = dotenv.get('LOCALISED_APP_VERSION', fallback: '');
