import 'package:horizonui/Spiro/ui/stations/ConnectStations.dart';
import 'package:horizonui/Spiro/ui/stations/Stations.dart';

import '../../data/models/StationsRequest.dart';
import '../parent/ParentViewModel.dart';

class ViewStations extends ParentViewModel {
  ConnectStations connection;

  ViewStations(super.context, this.connection);

  void getStations() {
    hasNetwork(() => {closeNetwork(), getStations()}).then(
      (value) => {
        if (value)
          {
            showLoading("Loading :)....."),
            getDataManager()
                .getStations()
                .then(
                  (response) => {
                    closeLoading(),
                    connection.setStations(
                      getStationsList([response.toList()]),
                    ),
                  },
                )
                .onError(
                  (error, stackTrace) => {
                    handleError(
                      error,
                      () => {dismissError(), getStations()},
                      () => {dismissError()},
                      "Retry",
                    ),
                  },
                ),
          },
      },
    );
  }

  List<Stations> getStationsList(List<dynamic> value) {
    List<Stations> types = [];
    for (var element in value) {
      types.add(StationsRequest.fromJson(element));
    }
    return types;
  }

  Future<void> refreshDashboardData() async {
    try {
      print('Refreshing dashboard data...');
    } catch (e) {
      print('Error refreshing dashboard data: $e');
      rethrow;
    }
  }
}
