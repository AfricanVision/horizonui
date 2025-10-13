import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../configs/Navigator.dart';
import '../../data/internal/application/NavigatorType.dart';
import '../../data/internal/application/TextType.dart';
import '../../data/internal/application/UserRole.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import '../dashboard/Dashboard.dart';
import 'ConnectLogin.dart';
import 'Login.dart';
import 'ViewLogin.dart';

class LoginState extends State<Login> implements ConnectLogin {
  ViewLogin? _model;

  UserRole? _selectedRole;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewLogin>.reactive(
      viewModelBuilder: () => ViewLogin(context, this),
      onViewModelReady: (viewModel) => {_model = viewModel},
      builder: (context, viewModel, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[50]!, Colors.white, Colors.green[50]!],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildMainCard(),
                    const SizedBox(height: 24),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gradient Logo
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[600]!, Colors.blue[700]!],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: textWithColor('S', 32, TextType.Bold, colorMilkWhite),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text('Spiro Control Tower', 28, TextType.Bold),
                const SizedBox(height: 4),
                textWithColor(
                  'Battery Swap Station Management System',
                  14,
                  TextType.Regular,
                  Colors.grey[600]!,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Card Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                text('Welcome Back', 24, TextType.Bold),
                const SizedBox(height: 8),
                textWithColor(
                  _selectedRole != null
                      ? 'Enter your credentials to continue'
                      : 'Select your role to get started',
                  14,
                  TextType.Regular,
                  Colors.grey[600]!,
                ),
              ],
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: _selectedRole == null
                ? _buildRoleSelection()
                : _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelection() {
    final roleOptions = UserRole.getRoleOptions();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: roleOptions
                .map(
                  (role) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: _buildRoleCard(role),
                    ),
                  ),
                )
                .toList(),
          );
        } else {
          return Column(
            children: roleOptions
                .map(
                  (role) => Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: _buildRoleCard(role),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildRoleCard(UserRole role) {
    final config = _getRoleConfig(role.role);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _handleRoleSelect(role),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: config['bgColor'],
            border: Border.all(color: config['borderColor'], width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: config['borderColor'].withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Circle
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: config['bgColor'],
                  border: Border.all(color: config['borderColor'], width: 3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: config['iconColor'].withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  config['icon'],
                  size: 40,
                  color: config['iconColor'],
                ),
              ),
              const SizedBox(height: 24),

              // Role Title
              text(role.label, 20, TextType.Bold),
              const SizedBox(height: 12),

              // Description
              textWithColor(
                _getRoleDescription(role.role),
                13,
                TextType.Regular,
                Colors.grey[700]!,
              ),
              const SizedBox(height: 16),

              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: config['badgeColor'],
                  border: Border.all(color: config['borderColor']),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getCountryBadge(role.role),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 4),
                    textWithColor(
                      role.role == 'global' ? 'All Countries' : 'Kenya',
                      12,
                      TextType.Bold,
                      config['iconColor'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    if (_selectedRole == null) return const SizedBox();

    final config = _getRoleConfig(_selectedRole!.role);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          // Selected Role Display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[300]!, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: config['bgColor'],
                    border: Border.all(color: config['borderColor'], width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    config['icon'],
                    size: 28,
                    color: config['iconColor'],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(_selectedRole!.label, 18, TextType.Bold),
                      const SizedBox(height: 6),
                      textWithColor(
                        _getRoleDescription(_selectedRole!.role),
                        12,
                        TextType.Regular,
                        Colors.grey[600]!,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: config['badgeColor'],
                          border: Border.all(color: config['borderColor']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getCountryBadge(_selectedRole!.role),
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            textWithColor(
                              _selectedRole!.role == 'global'
                                  ? 'All Countries'
                                  : 'Kenya',
                              10,
                              TextType.Bold,
                              config['iconColor'],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Username Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: text('Username', 14, TextType.Bold),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                autofocus: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: text('Password', 14, TextType.Bold),
              ),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Error Message
          if (_errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: textWithColor(
                      _errorMessage,
                      13,
                      TextType.Regular,
                      Colors.red[700]!,
                    ),
                  ),
                ],
              ),
            ),

          // Demo Credentials Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border.all(color: Colors.blue[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
                    SizedBox(width: 8),
                    textWithColor(
                      'Demo Credentials',
                      12,
                      TextType.Bold,
                      Colors.blue[700]!,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                textWithColor(
                  'Username: ${_selectedRole!.username}',
                  11,
                  TextType.Regular,
                  Colors.blue[700]!,
                ),
                const SizedBox(height: 4),
                textWithColor(
                  'Password: ${_selectedRole!.role == 'agent' ? 'agent123' : 'admin123'}',
                  11,
                  TextType.Regular,
                  Colors.blue[700]!,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: colorMilkWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: text('Login', 16, TextType.Bold),
            ),
          ),
          const SizedBox(height: 12),

          // Back Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: _handleBack,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back, size: 18),
                  const SizedBox(width: 8),
                  text('Back to Role Selection', 14, TextType.Regular),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return textWithColor(
      '© 2025 Spiro. All rights reserved.',
      12,
      TextType.Regular,
      Colors.grey[500]!,
    );
  }

  Map<String, dynamic> _getRoleConfig(String role) {
    switch (role) {
      case 'global':
        return {
          'icon': Icons.public,
          'badgeColor': Colors.blue[100],
          'borderColor': Colors.blue[300]!,
          'iconColor': Colors.blue[600]!,
          'bgColor': Colors.blue[50],
        };
      case 'local':
        return {
          'icon': Icons.location_city,
          'badgeColor': Colors.green[100],
          'borderColor': Colors.green[300]!,
          'iconColor': Colors.green[600]!,
          'bgColor': Colors.green[50],
        };
      case 'agent':
        return {
          'icon': Icons.person,
          'badgeColor': Colors.orange[100],
          'borderColor': Colors.orange[300]!,
          'iconColor': Colors.orange[600]!,
          'bgColor': Colors.orange[50],
        };
      default:
        return {
          'icon': Icons.person,
          'badgeColor': Colors.grey[100],
          'borderColor': Colors.grey[300]!,
          'iconColor': Colors.grey[600]!,
          'bgColor': Colors.grey[50],
        };
    }
  }

  String _getRoleDescription(String role) {
    switch (role) {
      case 'global':
        return 'Full access to Kenya, Rwanda, and Uganda operations';
      case 'local':
        return 'Kenya operations management and administration';
      case 'agent':
        return 'Field agent operations and data entry';
      default:
        return '';
    }
  }

  String _getCountryBadge(String role) {
    switch (role) {
      case 'global':
        return '🌍';
      case 'local':
      case 'agent':
        return '🇰🇪';
      default:
        return '';
    }
  }

  void _handleRoleSelect(UserRole role) {
    setState(() {
      _selectedRole = role;
      _usernameController.clear();
      _passwordController.clear();
      _errorMessage = '';
    });
  }

  void _handleBack() {
    setState(() {
      _selectedRole = null;
      _usernameController.clear();
      _passwordController.clear();
      _errorMessage = '';
    });
  }

  void _handleLogin() {
    setState(() {
      _errorMessage = '';
    });

    if (_selectedRole == null) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validate credentials
    if (username == _selectedRole!.username &&
        password == _selectedRole!.password) {
      // Successful login - navigate to dashboard with user role
      SpiroNavigation().navigateToPage(
        NavigatorType.openFully,
        Dashboard(userRole: _selectedRole),
        context,
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }
}
