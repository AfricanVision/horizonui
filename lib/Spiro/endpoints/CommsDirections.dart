import '../configs/Env.dart';

bool isProd = false;

String baseUrl = isProd ? spiroRouteProd : spiroRouteLocal;

String registerUser = 'agents';

String createBattery = 'battery/add';

String getBatteryById = 'battery/';

String getAllBatteries = 'battery/all';

String updateBattery = 'battery/update';

String createBatteryHistory = 'battery/history/register';

String getBatteryHistoryById = 'battery/history/';

String getAllBatteryHistory = 'battery/history/all';

String updateBatteryHistory = 'battery/history/update';

String getStationsUrl = 'stations';

String saveStations = 'stations';
