import 'package:flutter/material.dart';
import '../../data/internal/application/Agents.dart';
import '../home/ConnectHome.dart';
import '../parent/ParentViewModel.dart';
import '../dashboard/Dashboard.dart';

class ViewHome extends ParentViewModel {
  ConnectHome connection;

  ViewHome(super.context, this.connection);

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


  Future<void> refreshDashboardData() async {
    try {
      print('Refreshing dashboard data...');
    } catch (e) {
      print('Error refreshing dashboard data: $e');
      rethrow;
    }
  }
}