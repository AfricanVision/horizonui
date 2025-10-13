class UserRole {
  final String id;
  final String role; // 'global', 'local', or 'agent'
  final String username;
  final String password;
  final String label;

  UserRole({
    required this.id,
    required this.role,
    required this.username,
    required this.password,
    required this.label,
  });

  static List<UserRole> getRoleOptions() {
    return [
      UserRole(
        id: '1',
        role: 'global',
        username: 'globaladmin',
        password: 'admin123',
        label: 'Global Admin',
      ),
      UserRole(
        id: '2',
        role: 'local',
        username: 'localadmin',
        password: 'admin123',
        label: 'Local Admin',
      ),
      UserRole(
        id: '3',
        role: 'agent',
        username: 'agentadmin',
        password: 'agent123',
        label: 'Agent Admin',
      ),
    ];
  }
}

class LoggedInUser {
  final String id;
  final String name;
  final String role;
  final String? country;

  LoggedInUser({
    required this.id,
    required this.name,
    required this.role,
    this.country,
  });
}
