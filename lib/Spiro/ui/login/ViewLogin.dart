import '../../data/internal/application/UserRole.dart';
import '../parent/ParentViewModel.dart';
import 'ConnectLogin.dart';

class ViewLogin extends ParentViewModel {
  ConnectLogin connection;

  ViewLogin(super.context, this.connection);

  Future<bool> validateLogin(
    String username,
    String password,
    UserRole role,
  ) async {
    //demo credentials
    return true;
  }
}
