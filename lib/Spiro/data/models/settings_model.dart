class UserSettings {
  final String userId;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool autoBackup;
  final bool twoFactorAuth;
  final String language;
  final String timezone;
  final String theme;

  UserSettings({
    required this.userId,
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.autoBackup,
    required this.twoFactorAuth,
    required this.language,
    required this.timezone,
    required this.theme,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['userId'] ?? '',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? false,
      autoBackup: json['autoBackup'] ?? true,
      twoFactorAuth: json['twoFactorAuth'] ?? false,
      language: json['language'] ?? 'English',
      timezone: json['timezone'] ?? 'GMT+3 (East Africa Time)',
      theme: json['theme'] ?? 'Light',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'autoBackup': autoBackup,
      'twoFactorAuth': twoFactorAuth,
      'language': language,
      'timezone': timezone,
      'theme': theme,
    };
  }

  UserSettings copyWith({
    String? userId,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? autoBackup,
    bool? twoFactorAuth,
    String? language,
    String? timezone,
    String? theme,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      autoBackup: autoBackup ?? this.autoBackup,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      theme: theme ?? this.theme,
    );
  }
}
