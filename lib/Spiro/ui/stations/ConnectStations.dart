import 'package:horizonui/Spiro/data/models/StationType.dart';
import 'package:horizonui/Spiro/data/models/Status.dart';

import '../../data/models/Station.dart';

abstract class ConnectStations {
  void setStations(List<Station> stationsList) {}

  void setStationTypes(List<StationType> stationTypeList);

  void setStatus(List<Status> status);
}
