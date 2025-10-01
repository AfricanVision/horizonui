
import '../about/external/data/BatteryMapping.dart';
import '../about/external/data/VehicleMapping.dart';

abstract class ConnectComms{
  sendBatteryItem(BatteryMapping batteryItem);
  sendVehicleItem(VehicleMapping vehicleItem);
}