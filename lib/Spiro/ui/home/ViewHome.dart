
import '../../data/internal/application/Agents.dart';
import '../parent/ParentViewModel.dart';
import 'ConnectHome.dart';

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



}