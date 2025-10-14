import '../configs/Env.dart';


bool isProd = false;

String prospectRoute =  isProd ? "$spiroRouteProd/Prospect/" : "$spiroRouteLocal:20002/Prospect/";

String partnersRoute = isProd ? "$spiroRouteProd/Partners/" : "$spiroRouteLocal:20005/Partners/";

String relayRoute = isProd ? "$spiroRouteProd/spiroRelay" : "$spiroRouteLocal:/spiroRelay";

String registerUser = 'agents';

String registerStatus = 'Status';










