import '../configs/Env.dart';


bool isProd = false;

String prospectRoute =  isProd ? "$spiroRouteProd/Prospect/" : "$spiroRouteLocal:20002/Prospect/";

String partnersRoute = isProd ? "$spiroRouteProd/Partners/" : "$spiroRouteLocal:20005/Partners/";

String relayRoute = isProd ? "$spiroRouteProd/spiroRelay" : "$spiroRouteLocal:/spiroRelay";

String registerUser = 'agents';

String createBattery = 'battery/add';

String getBatteryById = 'battery/';

String getAllBatteries = 'battery/all';

String updateBattery = 'battery/update';

String createBatteryHistory = 'battery/history/register';

String getBatteryHistoryById = 'battery/history/';

String getAllBatteryHistory = 'battery/history/all';

String updateBatteryHistory = 'battery/history/update';








