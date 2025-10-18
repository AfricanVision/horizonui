import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/ui/dashboard/ConnectDashBoard.dart';
import '../../data/internal/application/Agents.dart';
import '../parent/ParentViewModel.dart';

class ViewDashboard extends ParentViewModel {
  ConnectDashBoard connection;

  List<Agent> agents = [];
  bool isLoading = false;
  String errorMessage = '';

  ViewDashboard(super.context, this.connection);

  void getAgents() {
    print('getAgents called'); // Debug

    hasNetwork(() {
      closeNetwork();
      getAgents();
    }).then((value) {
      if (value) {
        print('Has network, showing loading'); // Debug
        showLoading("Loading :).....");

        getDataManager().getAgents().then((response) {
          print('API call successful'); // Debug
          print('Response data: ${response.data}'); // Debug
          print('Response status: ${response.statusCode}'); // Debug
          print('Response headers: ${response.headers}'); // Debug

          closeLoading();

          // Check if response data is valid
          if (response.data != null) {
            try {
              List<Agent> agents = getAgentList(response.data);
              print('Parsed ${agents.length} agents'); // Debug
              connection.setAgents(agents);
            } catch (e) {
              print('Error parsing agents: $e'); // Debug
              handleError(
                  'Failed to parse agent data: $e',
                      () {
                    dismissError();
                    getAgents();
                  },
                      () {
                    dismissError();
                  },
                  "Retry"
              );
            }
          } else {
            print('Response data is null'); // Debug
            handleError(
                'No data received from server',
                    () {
                  dismissError();
                  getAgents();
                },
                    () {
                  dismissError();
                },
                "Retry"
            );
          }
        }).catchError((error, stackTrace) {
          print('API call error: $error');
          print('Stack trace: $stackTrace');
          closeLoading();

          handleError(
              error,
                  () {
                dismissError();
                getAgents();
              },
                  () {
                dismissError();
              },
              "Retry"
          );
        });
      } else {
        print('No network available'); // Debug
        handleError(
            'No internet connection',
                () {
              dismissError();
              getAgents();
            },
                () {
              dismissError();
            },
            "Retry"
        );
      }
    }).catchError((error) {
      print('Error in network check: $error'); // Debug
      handleError(
          'Network check failed: $error',
              () {
            dismissError();
            getAgents();
          },
              () {
            dismissError();
          },
          "Retry"
      );
    });
  }

  List<Agent> getAgentList(dynamic response) {
    print('ViewDashboard: Parsing agent list');
    print('Response data type: ${response.runtimeType}');

    List<Agent> types = [];

    if (response is List) {
      print('Response is a List with ${response.length} items');
      for (var element in response) {
        try {
          print('Raw element: $element');
          print('Element type: ${element.runtimeType}');

          Agent agent = Agent.fromJson(element);
          types.add(agent);
          print('Added agent: ${agent.firstname} ${agent.lastname}');
        } catch (e) {
          print('Error parsing agent: $e');
        }
      }
    } else {
      print('Unexpected response type: ${response.runtimeType}');
      print('Response content: $response');
    }

    return types;
  }

  Future<void> refreshDashboardData() async {
    try {
      print('Refreshing dashboard data...');
      getAgents();
    } catch (e) {
      print('Error refreshing dashboard data: $e');
      rethrow;
    }
  }
}