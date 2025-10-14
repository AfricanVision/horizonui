import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/ui/dashboard/ConnectDashBoard.dart';
import '../../data/internal/application/Agents.dart';
import '../home/ConnectHome.dart';
import '../parent/ParentViewModel.dart';
import '../dashboard/Dashboard.dart';

class ViewDashboard extends ParentViewModel {
  ConnectDashBoard connection;

  ViewDashboard(super.context, this.connection);

   sendAgent(Agent data) async {
    hasNetwork(() => { closeNetwork(), sendAgent(data)}).then((value) => {
      if(value){
        showLoading("Fetching Agents....."),
        getDataManager().sendAgent(data).then((response) => {
          closeLoading(),
         // connection.setProductCategories(getItemList(response.data))
        }).onError((error, stackTrace) => {
          handleError(error, () => {dismissError(), sendAgent(data)}, () => {dismissError()},"Retry")
        })
      }
    });
  }


  void getAgents() {
    hasNetwork(() => { closeNetwork(), getAgents()}).then((value) => {
      if(value){
        showLoading("Loading :)....."),
        getDataManager().getAgents().then((response) => {
          closeLoading(),
          connection.setAgents(getAgentList(response.data))
        }).onError((error, stackTrace) => {
          handleError(error, () => {dismissError(), getAgents()}, () => {dismissError()}, "Retry")
        })
      }
    });
  }

  List<Agent> getAgentList(List<dynamic> value) {

    List<Agent> types = [];

    for (var element in value) {
      types.add(Agent.fromJson(element));
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