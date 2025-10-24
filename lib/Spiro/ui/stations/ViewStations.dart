import 'package:horizonui/Spiro/data/models/StationType.dart';
import 'package:horizonui/Spiro/data/models/Status.dart';
import 'package:horizonui/Spiro/ui/stations/ConnectStations.dart';

import '../../data/models/Station.dart';
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
                    connection.setStations(getStationsList(response.data)),
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

  void getStationTypes() {
    hasNetwork(() => {closeNetwork(), getStationTypes()}).then(
      (value) => {
        if (value)
          {
            showLoading("Loading :)....."),
            getDataManager()
                .getStationTypes()
                .then(
                  (response) => {
                    closeLoading(),
                    connection.setStationTypes(
                      getStationTypeList(response.data),
                    ),
                  },
                )
                .onError(
                  (error, stackTrace) => {
                    handleError(
                      error,
                      () => {dismissError(), getStationTypes()},
                      () => {dismissError()},
                      "Retry",
                    ),
                  },
                ),
          },
      },
    );
  }

  void getStatus() {
    hasNetwork(() => {closeNetwork(), getStatus()}).then(
      (value) => {
        if (value)
          {
            showLoading("Loading :)....."),
            getDataManager()
                .getStatus()
                .then(
                  (response) => {
                    closeLoading(),
                    connection.setStatus(getStatusList(response.data)),
                  },
                )
                .onError(
                  (error, stackTrace) => {
                    handleError(
                      error,
                      () => {dismissError(), getStatus()},
                      () => {dismissError()},
                      "Retry",
                    ),
                  },
                ),
          },
      },
    );
  }

  List<Station> getStationsList(List<dynamic> value) {
    List<Station> types = [];
    for (var element in value) {
      types.add(Station.fromJson(element));
    }
    return types;
  }

  List<StationType> getStationTypeList(List<dynamic> value) {
    List<StationType> types = [];
    for (var element in value) {
      types.add(StationType.fromJson(element));
    }
    return types;
  }

  List<Status> getStatusList(List<dynamic> value) {
    List<Status> types = [];
    for (var element in value) {
      types.add(Status.fromJson(element));
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
