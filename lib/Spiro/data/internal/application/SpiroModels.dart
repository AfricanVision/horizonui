class Agent {
  final String id;
  final String name;
  final String stationId;
  final String status; // 'active', 'inactive', 'on-shift'
  final int swapsToday;
  final String shift; // 'morning', 'afternoon', 'night'
  final String phone;
  final String email;

  Agent({
    required this.id,
    required this.name,
    required this.stationId,
    required this.status,
    required this.swapsToday,
    required this.shift,
    required this.phone,
    required this.email,
  });

  static List<Agent> getKenyaAgents() {
    return [
      Agent(
        id: 'AG-KE-001',
        name: 'John Kamau',
        stationId: 'KE-NBO-001',
        status: 'active',
        swapsToday: 23,
        shift: 'morning',
        phone: '+254712345001',
        email: 'john.kamau@spiro.com',
      ),
      Agent(
        id: 'AG-KE-002',
        name: 'Sarah Wanjiku',
        stationId: 'KE-NBO-001',
        status: 'active',
        swapsToday: 19,
        shift: 'morning',
        phone: '+254712345002',
        email: 'sarah.wanjiku@spiro.com',
      ),
      Agent(
        id: 'AG-KE-003',
        name: 'Michael Omondi',
        stationId: 'KE-NBO-002',
        status: 'active',
        swapsToday: 21,
        shift: 'afternoon',
        phone: '+254712345003',
        email: 'michael.omondi@spiro.com',
      ),
      Agent(
        id: 'AG-KE-004',
        name: 'Emma Achieng',
        stationId: 'KE-NBO-003',
        status: 'on-shift',
        swapsToday: 18,
        shift: 'afternoon',
        phone: '+254712345004',
        email: 'emma.achieng@spiro.com',
      ),
      Agent(
        id: 'AG-KE-005',
        name: 'Anna Muthoni',
        stationId: 'KE-MBA-001',
        status: 'active',
        swapsToday: 15,
        shift: 'morning',
        phone: '+254712345005',
        email: 'anna.muthoni@spiro.com',
      ),
      Agent(
        id: 'AG-KE-006',
        name: 'James Kipchoge',
        stationId: 'KE-KSM-001',
        status: 'active',
        swapsToday: 17,
        shift: 'night',
        phone: '+254712345006',
        email: 'james.kipchoge@spiro.com',
      ),
    ];
  }
}

class Incident {
  final String id;
  final String stationId;
  final String type; // 'battery', 'power', 'equipment', 'safety'
  final String priority; // 'critical', 'high', 'medium', 'low'
  final String status; // 'open', 'in-progress', 'resolved'
  final String description;
  final String reporter;
  final DateTime timestamp;

  Incident({
    required this.id,
    required this.stationId,
    required this.type,
    required this.priority,
    required this.status,
    required this.description,
    required this.reporter,
    required this.timestamp,
  });

  static List<Incident> getRecentIncidents() {
    return [
      Incident(
        id: 'INC-001',
        stationId: 'KE-NBO-001',
        type: 'battery',
        priority: 'critical',
        status: 'in-progress',
        description: 'Battery swap station offline',
        reporter: 'John Kamau',
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
      ),
      Incident(
        id: 'INC-002',
        stationId: 'KE-ELD-001',
        type: 'power',
        priority: 'high',
        status: 'open',
        description: 'Power outage affecting operations',
        reporter: 'System',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
      ),
      Incident(
        id: 'INC-003',
        stationId: 'KE-MBA-001',
        type: 'equipment',
        priority: 'medium',
        status: 'open',
        description: 'Charging equipment maintenance needed',
        reporter: 'Anna Muthoni',
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
      ),
    ];
  }
}

class MetricData {
  final int totalAgents;
  final int activeAgents;
  final int totalSwaps;
  final int swapsToday;
  final int totalIncidents;
  final double downtimePercent;
  final int powerStations;
  final double totalPower;

  MetricData({
    required this.totalAgents,
    required this.activeAgents,
    required this.totalSwaps,
    required this.swapsToday,
    required this.totalIncidents,
    required this.downtimePercent,
    required this.powerStations,
    required this.totalPower,
  });

  static MetricData getGlobalMetrics() {
    return MetricData(
      totalAgents: 391,
      activeAgents: 356,
      totalSwaps: 7379,
      swapsToday: 142,
      totalIncidents: 8,
      downtimePercent: 2.3,
      powerStations: 19,
      totalPower: 45.8,
    );
  }

  static MetricData getKenyaMetrics() {
    return MetricData(
      totalAgents: 180,
      activeAgents: 165,
      totalSwaps: 3458,
      swapsToday: 67,
      totalIncidents: 3,
      downtimePercent: 1.8,
      powerStations: 8,
      totalPower: 22.4,
    );
  }

  static MetricData getRwandaMetrics() {
    return MetricData(
      totalAgents: 91,
      activeAgents: 84,
      totalSwaps: 1687,
      swapsToday: 35,
      totalIncidents: 2,
      downtimePercent: 2.1,
      powerStations: 5,
      totalPower: 11.2,
    );
  }

  static MetricData getUgandaMetrics() {
    return MetricData(
      totalAgents: 120,
      activeAgents: 107,
      totalSwaps: 2234,
      swapsToday: 40,
      totalIncidents: 3,
      downtimePercent: 3.5,
      powerStations: 6,
      totalPower: 12.2,
    );
  }
}
