
import 'package:helpline/Spiro/about/external/data/BatteryMapping.dart';

abstract class ConnectHome{
  void setItem(BatteryMapping batteryItem) {}

  void setFailure(BatteryMapping batteryItem, Object? error) {}

}