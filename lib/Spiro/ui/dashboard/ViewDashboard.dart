import 'package:flutter/material.dart';
import '../../data/internal/application/Agents.dart';
import '../home/ConnectHome.dart';
import '../parent/ParentViewModel.dart';
import '../dashboard/Dashboard.dart';

class ViewHome extends ParentViewModel {
  ConnectHome connection;

  ViewHome(super.context, this.connection);

  Future<bool> sendAgent(Agent userData) async {
    try {
      return await getDataManager().sendAgent(userData);
    } catch (e) {
      rethrow;
    }
  }

  Widget getDashboard() {
    return Dashboard();
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