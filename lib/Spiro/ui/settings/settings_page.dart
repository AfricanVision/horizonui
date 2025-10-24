import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/ui/settings/ConnectSettings.dart';

import '../../utils/DesignSystem.dart';
import 'Settings.dart';

class SettingsPageState extends State<SettingsPage> implements ConnectSettings {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  bool _autoBackup = true;
  bool _twoFactorAuth = false;
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'GMT+3 (East Africa Time)';
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpiroDesignSystem.gray50,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SpiroDesignSystem.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: SpiroDesignSystem.space8),
            LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout: stack vertically on smaller screens
                if (constraints.maxWidth < 900) {
                  return Column(
                    children: [
                      _buildAccountSettings(),
                      SizedBox(height: SpiroDesignSystem.space6),
                      _buildNotificationSettings(),
                      SizedBox(height: SpiroDesignSystem.space6),
                      _buildSecuritySettings(),
                      SizedBox(height: SpiroDesignSystem.space6),
                      _buildPreferencesSettings(),
                    ],
                  );
                } else {
                  // Side-by-side layout for larger screens
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildAccountSettings(),
                            SizedBox(height: SpiroDesignSystem.space6),
                            _buildNotificationSettings(),
                            SizedBox(height: SpiroDesignSystem.space6),
                            _buildSecuritySettings(),
                          ],
                        ),
                      ),
                      SizedBox(width: SpiroDesignSystem.space6),
                      Expanded(flex: 1, child: _buildPreferencesSettings()),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: BoxDecoration(
        gradient: SpiroDesignSystem.primaryGradient,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        boxShadow: SpiroDesignSystem.shadowPrimary,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            ),
            child: Icon(Icons.settings, color: Colors.white, size: 32),
          ),
          SizedBox(width: SpiroDesignSystem.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: SpiroDesignSystem.displayM.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: SpiroDesignSystem.space1),
                Text(
                  'Manage your account, preferences, and system settings',
                  style: SpiroDesignSystem.bodyL.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  color: SpiroDesignSystem.primaryBlue100,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: SpiroDesignSystem.primaryBlue600,
                  size: 20,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Text(
                'Account Settings',
                style: SpiroDesignSystem.titleL.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space5),
          _buildProfileSection(),
          Divider(height: 32, color: SpiroDesignSystem.gray200),
          _buildSettingItem(
            'Email Address',
            'admin@spirocontrol.com',
            Icons.email_outlined,
            onTap: () => _showFeatureDialog(
              'Email Address',
              'Update your email address',
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space3),
          _buildSettingItem(
            'Phone Number',
            '+254 712 345 678',
            Icons.phone_outlined,
            onTap: () =>
                _showFeatureDialog('Phone Number', 'Update your phone number'),
          ),
          SizedBox(height: SpiroDesignSystem.space3),
          _buildSettingItem(
            'Change Password',
            'Last changed 30 days ago',
            Icons.lock_outline,
            onTap: () => _showFeatureDialog(
              'Change Password',
              'Create a new password for your account',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: SpiroDesignSystem.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: SpiroDesignSystem.shadowPrimary,
          ),
          child: Icon(Icons.person, color: Colors.white, size: 40),
        ),
        SizedBox(width: SpiroDesignSystem.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shawn Matunda',
                style: SpiroDesignSystem.titleL.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space1),
              Text(
                'Global Administrator',
                style: SpiroDesignSystem.bodyL.copyWith(
                  color: SpiroDesignSystem.gray600,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space2),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SpiroDesignSystem.space2,
                  vertical: SpiroDesignSystem.space1,
                ),
                decoration: BoxDecoration(
                  color: SpiroDesignSystem.success50,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusSm,
                  ),
                  border: Border.all(color: SpiroDesignSystem.success200),
                ),
                child: Text(
                  'Active',
                  style: SpiroDesignSystem.bodyS.copyWith(
                    color: SpiroDesignSystem.success700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: SpiroDesignSystem.primaryBlue50,
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          ),
          child: IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: SpiroDesignSystem.primaryBlue600,
            ),
            onPressed: () => _showFeatureDialog(
              'Edit Profile',
              'Update your profile information',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  color: SpiroDesignSystem.warning100,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: SpiroDesignSystem.warning600,
                  size: 20,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Text(
                'Notification Settings',
                style: SpiroDesignSystem.titleL.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space5),
          _buildSwitchSetting(
            'Enable Notifications',
            'Receive all system notifications',
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
          ),
          SizedBox(height: SpiroDesignSystem.space3),
          _buildSwitchSetting(
            'Email Notifications',
            'Get alerts via email',
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
          ),
          SizedBox(height: SpiroDesignSystem.space3),
          _buildSwitchSetting(
            'Push Notifications',
            'Receive push notifications',
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  color: SpiroDesignSystem.danger100,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Icon(
                  Icons.security_outlined,
                  color: SpiroDesignSystem.danger600,
                  size: 20,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Text(
                'Security Settings',
                style: SpiroDesignSystem.titleL.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space5),
          _buildSwitchSetting(
            'Two-Factor Authentication',
            'Add extra security to your account',
            _twoFactorAuth,
            (value) {
              setState(() => _twoFactorAuth = value);
              _showSuccessMessage(
                value
                    ? 'Two-Factor Authentication enabled'
                    : 'Two-Factor Authentication disabled',
              );
            },
          ),
          SizedBox(height: SpiroDesignSystem.space3),
          _buildSwitchSetting(
            'Auto Backup',
            'Automatically backup your data',
            _autoBackup,
            (value) {
              setState(() => _autoBackup = value);
              _showSuccessMessage(
                value ? 'Auto Backup enabled' : 'Auto Backup disabled',
              );
            },
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          _buildSettingItem(
            'Active Sessions',
            '3 active sessions',
            Icons.devices_outlined,
            onTap: () => _showFeatureDialog(
              'Active Sessions',
              'Manage your active login sessions',
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space3),
          _buildSettingItem(
            'Login History',
            'View recent login activity',
            Icons.history_outlined,
            onTap: () => _showFeatureDialog(
              'Login History',
              'View your recent login activity',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSettings() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  color: SpiroDesignSystem.info100,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Icon(
                  Icons.tune_outlined,
                  color: SpiroDesignSystem.info600,
                  size: 20,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Expanded(
                child: Text(
                  'Preferences',
                  style: SpiroDesignSystem.titleL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SpiroDesignSystem.gray900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space5),
          _buildDropdownSetting(
            'Language',
            _selectedLanguage,
            ['English', 'Swahili', 'French', 'Arabic'],
            (value) => setState(() => _selectedLanguage = value!),
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          _buildDropdownSetting(
            'Timezone',
            _selectedTimezone,
            [
              'GMT+3 (East Africa Time)',
              'GMT+1 (West Africa Time)',
              'GMT+2 (Central Africa Time)',
            ],
            (value) => setState(() => _selectedTimezone = value!),
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          _buildDropdownSetting(
            'Theme',
            _selectedTheme,
            ['Light', 'Dark', 'Auto'],
            (value) => setState(() => _selectedTheme = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: SpiroDesignSystem.gray50,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        border: Border.all(color: SpiroDesignSystem.gray200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(SpiroDesignSystem.space4),
            child: Row(
              children: [
                Icon(icon, color: SpiroDesignSystem.primaryBlue600, size: 20),
                SizedBox(width: SpiroDesignSystem.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: SpiroDesignSystem.bodyL.copyWith(
                          fontWeight: FontWeight.w600,
                          color: SpiroDesignSystem.gray900,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: SpiroDesignSystem.bodyS.copyWith(
                          color: SpiroDesignSystem.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: SpiroDesignSystem.gray400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      decoration: BoxDecoration(
        color: SpiroDesignSystem.gray50,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        border: Border.all(color: SpiroDesignSystem.gray200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SpiroDesignSystem.bodyL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SpiroDesignSystem.gray900,
                  ),
                ),
                SizedBox(height: SpiroDesignSystem.space0_5),
                Text(
                  subtitle,
                  style: SpiroDesignSystem.bodyS.copyWith(
                    color: SpiroDesignSystem.gray600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: SpiroDesignSystem.primaryBlue600,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SpiroDesignSystem.bodyL.copyWith(
            fontWeight: FontWeight.w600,
            color: SpiroDesignSystem.gray900,
          ),
        ),
        SizedBox(height: SpiroDesignSystem.space2),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SpiroDesignSystem.space4,
            vertical: SpiroDesignSystem.space2,
          ),
          decoration: BoxDecoration(
            color: SpiroDesignSystem.gray50,
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            border: Border.all(color: SpiroDesignSystem.gray300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: SpiroDesignSystem.gray600,
              ),
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray900,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: (newValue) {
                onChanged(newValue);
                _showSuccessMessage('$label updated to $newValue');
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showFeatureDialog(String title, String message) {
    final TextEditingController _dialogController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: SpiroDesignSystem.primaryBlue600),
            SizedBox(width: SpiroDesignSystem.space3),
            Expanded(
              child: Text(
                title,
                style: SpiroDesignSystem.titleL.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
            SizedBox(height: SpiroDesignSystem.space4),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
                boxShadow: SpiroDesignSystem.shadowSm,
              ),
              child: TextField(
                controller: _dialogController,
                style: TextStyle(
                  color: SpiroDesignSystem.gray900,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: _getHintText(title),
                  hintStyle: TextStyle(
                    color: SpiroDesignSystem.gray500,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    _getIconForField(title),
                    color: SpiroDesignSystem.primaryBlue600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: SpiroDesignSystem.gray50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                    borderSide: BorderSide(color: SpiroDesignSystem.gray300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                    borderSide: BorderSide(color: SpiroDesignSystem.gray300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                    borderSide: BorderSide(
                      color: SpiroDesignSystem.primaryBlue600,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
                obscureText: title == 'Change Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: SpiroDesignSystem.primaryGradient,
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
              boxShadow: SpiroDesignSystem.shadowSm,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (_dialogController.text.trim().isNotEmpty) {
                    Navigator.of(context).pop();
                    _showSuccessMessage('$title updated successfully');
                  } else {
                    _showSuccessMessage('Please enter a value');
                  }
                },
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SpiroDesignSystem.space4,
                    vertical: SpiroDesignSystem.space2,
                  ),
                  child: Text(
                    'Save',
                    style: SpiroDesignSystem.bodyL.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getHintText(String title) {
    switch (title) {
      case 'Email Address':
        return 'Enter new email address';
      case 'Phone Number':
        return 'Enter phone number';
      case 'Change Password':
        return 'Enter new password';
      case 'Edit Profile':
        return 'Enter your name';
      default:
        return 'Enter value';
    }
  }

  IconData _getIconForField(String title) {
    switch (title) {
      case 'Email Address':
        return Icons.email_outlined;
      case 'Phone Number':
        return Icons.phone_outlined;
      case 'Change Password':
        return Icons.lock_outline;
      case 'Edit Profile':
        return Icons.person_outline;
      default:
        return Icons.edit_outlined;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: SpiroDesignSystem.space2),
            Expanded(
              child: Text(
                message,
                style: SpiroDesignSystem.bodyL.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: SpiroDesignSystem.success600,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        ),
      ),
    );
  }
}
