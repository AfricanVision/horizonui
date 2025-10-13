import 'package:flutter/material.dart';

import '../../data/internal/application/UserRole.dart';
import 'DashboardState.dart';

class Dashboard extends StatefulWidget {
  final UserRole? userRole;

  const Dashboard({super.key, this.userRole});

  @override
  State<Dashboard> createState() => DashboardState();
}
