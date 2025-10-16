// Dashboard Data Models with Complete Structure

class DashboardMetrics {
  final int activeAgents;
  final int totalAgents;
  final int swapsToday;
  final int swapsTarget;
  final int activeIssues;
  final double downtimePercentage;
  final double powerUsage;
  final double powerUsageAvg;
  final DateTime lastUpdated;

  DashboardMetrics({
    required this.activeAgents,
    required this.totalAgents,
    required this.swapsToday,
    required this.swapsTarget,
    required this.activeIssues,
    required this.downtimePercentage,
    required this.powerUsage,
    required this.powerUsageAvg,
    required this.lastUpdated,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      activeAgents: json['activeAgents'] ?? 0,
      totalAgents: json['totalAgents'] ?? 0,
      swapsToday: json['swapsToday'] ?? 0,
      swapsTarget: json['swapsTarget'] ?? 350,
      activeIssues: json['activeIssues'] ?? 0,
      downtimePercentage: (json['downtimePercentage'] ?? 0.0).toDouble(),
      powerUsage: (json['powerUsage'] ?? 0.0).toDouble(),
      powerUsageAvg: (json['powerUsageAvg'] ?? 0.0).toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  double get swapsProgress => (swapsToday / swapsTarget) * 100;
  double get agentUtilization => (activeAgents / totalAgents) * 100;
}

class ShiftAgent {
  final String id;
  final String name;
  final String station;
  final String status;
  final String shift;
  final int swapsCompleted;
  final String checkInTime;
  final double hoursWorked;

  ShiftAgent({
    required this.id,
    required this.name,
    required this.station,
    required this.status,
    required this.shift,
    required this.swapsCompleted,
    required this.checkInTime,
    required this.hoursWorked,
  });

  factory ShiftAgent.fromJson(Map<String, dynamic> json) {
    return ShiftAgent(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      station: json['station'] ?? '',
      status: json['status'] ?? 'offline',
      shift: json['shift'] ?? '',
      swapsCompleted: json['swapsCompleted'] ?? 0,
      checkInTime: json['checkInTime'] ?? '',
      hoursWorked: (json['hoursWorked'] ?? 0.0).toDouble(),
    );
  }
}

class IncidentAlert {
  final String id;
  final String title;
  final String description;
  final String location;
  final String status;
  final String priority;
  final String type;
  final DateTime timestamp;
  final String timeElapsed;
  final String assignedTo;

  IncidentAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.priority,
    required this.type,
    required this.timestamp,
    required this.timeElapsed,
    required this.assignedTo,
  });

  factory IncidentAlert.fromJson(Map<String, dynamic> json) {
    return IncidentAlert(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      type: json['type'] ?? 'info',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      timeElapsed: json['timeElapsed'] ?? '',
      assignedTo: json['assignedTo'] ?? 'Unassigned',
    );
  }

  bool get isCritical => priority == 'critical' || priority == 'high';
}

class SwapTrendData {
  final String date;
  final int currentWeek;
  final int previousWeek;
  final double percentage;

  SwapTrendData({
    required this.date,
    required this.currentWeek,
    required this.previousWeek,
    required this.percentage,
  });

  factory SwapTrendData.fromJson(Map<String, dynamic> json) {
    return SwapTrendData(
      date: json['date'] ?? '',
      currentWeek: json['currentWeek'] ?? 0,
      previousWeek: json['previousWeek'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }
}

class BatteryLifecycleData {
  final String category;
  final int count;
  final double percentage;
  final String description;

  BatteryLifecycleData({
    required this.category,
    required this.count,
    required this.percentage,
    required this.description,
  });

  factory BatteryLifecycleData.fromJson(Map<String, dynamic> json) {
    return BatteryLifecycleData(
      category: json['category'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
    );
  }
}

class PowerConsumptionData {
  final String hour;
  final double consumption;
  final double maxCapacity;
  final bool isPeak;

  PowerConsumptionData({
    required this.hour,
    required this.consumption,
    required this.maxCapacity,
    required this.isPeak,
  });

  factory PowerConsumptionData.fromJson(Map<String, dynamic> json) {
    return PowerConsumptionData(
      hour: json['hour'] ?? '',
      consumption: (json['consumption'] ?? 0.0).toDouble(),
      maxCapacity: (json['maxCapacity'] ?? 0.0).toDouble(),
      isPeak: json['isPeak'] ?? false,
    );
  }
}

class CountryMetrics {
  final String countryCode;
  final String countryName;
  final int stations;
  final int activeAgents;
  final int swapsToday;
  final String status;
  final double lat;
  final double lng;

  CountryMetrics({
    required this.countryCode,
    required this.countryName,
    required this.stations,
    required this.activeAgents,
    required this.swapsToday,
    required this.status,
    required this.lat,
    required this.lng,
  });

  factory CountryMetrics.fromJson(Map<String, dynamic> json) {
    return CountryMetrics(
      countryCode: json['countryCode'] ?? '',
      countryName: json['countryName'] ?? '',
      stations: json['stations'] ?? 0,
      activeAgents: json['activeAgents'] ?? 0,
      swapsToday: json['swapsToday'] ?? 0,
      status: json['status'] ?? 'operational',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }
}

class StationMarker {
  final String id;
  final String name;
  final String status;
  final double lat;
  final double lng;
  final int activeAgents;
  final int swapsToday;
  final double powerUsage;
  final int activeIssues;

  StationMarker({
    required this.id,
    required this.name,
    required this.status,
    required this.lat,
    required this.lng,
    required this.activeAgents,
    required this.swapsToday,
    required this.powerUsage,
    required this.activeIssues,
  });

  factory StationMarker.fromJson(Map<String, dynamic> json) {
    return StationMarker(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'operational',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      activeAgents: json['activeAgents'] ?? 0,
      swapsToday: json['swapsToday'] ?? 0,
      powerUsage: (json['powerUsage'] ?? 0.0).toDouble(),
      activeIssues: json['activeIssues'] ?? 0,
    );
  }
}
