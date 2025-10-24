import '../configs/Env.dart';

bool isProd = false;

String baseUrl = isProd
    ? "${spiroRouteProd}spiro/horizon/"
    : "${spiroRouteLocal}spiro/horizon/";

String registerUser = 'agents';

String createBatteryUrl = 'battery/add';

String getBatteryById = 'battery/';

String getAllBatteries = 'battery/all';

String updateBattery = 'battery/update';

String createBatteryHistory = 'battery/history/register';

String getBatteryHistoryById = 'battery/history/';

String getAllBatteryHistory = 'battery/history/all';

String updateBatteryHistory = 'battery/history/update';

String getStationsUrl = 'station/all';

String getStationTypeUrl = 'station-types/all';

String saveStations = 'stations';

String getStatusUrl = 'status/all';
