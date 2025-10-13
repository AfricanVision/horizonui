class Country {
  final String id;
  final String name;
  final String code;
  final int totalAgents;
  final int totalSwaps;
  final String status; // 'active', 'warning', 'maintenance'
  final List<Station> stations;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.totalAgents,
    required this.totalSwaps,
    required this.status,
    required this.stations,
  });

  static List<Country> getCountries() {
    return [
      Country(
        id: 'KE',
        name: 'Kenya',
        code: 'KE',
        totalAgents: 180,
        totalSwaps: 3458,
        status: 'active',
        stations: Station.getKenyaStations(),
      ),
      Country(
        id: 'RW',
        name: 'Rwanda',
        code: 'RW',
        totalAgents: 91,
        totalSwaps: 1687,
        status: 'active',
        stations: Station.getRwandaStations(),
      ),
      Country(
        id: 'UG',
        name: 'Uganda',
        code: 'UG',
        totalAgents: 120,
        totalSwaps: 2234,
        status: 'warning',
        stations: Station.getUgandaStations(),
      ),
    ];
  }
}

class Station {
  final String id;
  final String name;
  final String location;
  final int agents;
  final int capacity;
  final String status;
  final double latitude;
  final double longitude;

  Station({
    required this.id,
    required this.name,
    required this.location,
    required this.agents,
    required this.capacity,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  static List<Station> getKenyaStations() {
    return [
      Station(
        id: 'KE-NBO-001',
        name: 'Nairobi CBD',
        location: 'Moi Avenue',
        agents: 35,
        capacity: 50,
        status: 'active',
        latitude: -1.2864,
        longitude: 36.8172,
      ),
      Station(
        id: 'KE-NBO-002',
        name: 'Nairobi Westlands',
        location: 'Westlands',
        agents: 28,
        capacity: 40,
        status: 'active',
        latitude: -1.2676,
        longitude: 36.8070,
      ),
      Station(
        id: 'KE-NBO-003',
        name: 'Nairobi Eastleigh',
        location: 'Eastleigh',
        agents: 32,
        capacity: 45,
        status: 'active',
        latitude: -1.2809,
        longitude: 36.8428,
      ),
      Station(
        id: 'KE-MBA-001',
        name: 'Mombasa Nyali',
        location: 'Nyali',
        agents: 24,
        capacity: 35,
        status: 'active',
        latitude: -4.0435,
        longitude: 39.6682,
      ),
      Station(
        id: 'KE-KSM-001',
        name: 'Kisumu Central',
        location: 'Kisumu',
        agents: 18,
        capacity: 30,
        status: 'active',
        latitude: -0.0917,
        longitude: 34.7680,
      ),
      Station(
        id: 'KE-NKR-001',
        name: 'Nakuru Town',
        location: 'Nakuru',
        agents: 15,
        capacity: 25,
        status: 'active',
        latitude: -0.3031,
        longitude: 36.0800,
      ),
      Station(
        id: 'KE-ELD-001',
        name: 'Eldoret Hub',
        location: 'Eldoret',
        agents: 12,
        capacity: 20,
        status: 'warning',
        latitude: 0.5143,
        longitude: 35.2698,
      ),
      Station(
        id: 'KE-THK-001',
        name: 'Thika Station',
        location: 'Thika',
        agents: 16,
        capacity: 25,
        status: 'active',
        latitude: -1.0332,
        longitude: 37.0694,
      ),
    ];
  }

  static List<Station> getRwandaStations() {
    return [
      Station(
        id: 'RW-KGL-001',
        name: 'Kigali Kimironko',
        location: 'Kimironko',
        agents: 25,
        capacity: 35,
        status: 'active',
        latitude: -1.9536,
        longitude: 30.1040,
      ),
      Station(
        id: 'RW-KGL-002',
        name: 'Kigali Nyabugogo',
        location: 'Nyabugogo',
        agents: 22,
        capacity: 30,
        status: 'active',
        latitude: -1.9659,
        longitude: 30.0445,
      ),
      Station(
        id: 'RW-KGL-003',
        name: 'Kigali Remera',
        location: 'Remera',
        agents: 20,
        capacity: 28,
        status: 'active',
        latitude: -1.9489,
        longitude: 30.0971,
      ),
      Station(
        id: 'RW-MSZ-001',
        name: 'Musanze Hub',
        location: 'Musanze',
        agents: 14,
        capacity: 20,
        status: 'active',
        latitude: -1.4989,
        longitude: 29.6346,
      ),
      Station(
        id: 'RW-HUY-001',
        name: 'Huye Station',
        location: 'Huye',
        agents: 10,
        capacity: 15,
        status: 'active',
        latitude: -2.5971,
        longitude: 29.7389,
      ),
    ];
  }

  static List<Station> getUgandaStations() {
    return [
      Station(
        id: 'UG-KLA-001',
        name: 'Kampala Central',
        location: 'Central Division',
        agents: 30,
        capacity: 40,
        status: 'active',
        latitude: 0.3163,
        longitude: 32.5822,
      ),
      Station(
        id: 'UG-KLA-002',
        name: 'Kampala Ntinda',
        location: 'Ntinda',
        agents: 25,
        capacity: 35,
        status: 'active',
        latitude: 0.3476,
        longitude: 32.6147,
      ),
      Station(
        id: 'UG-KLA-003',
        name: 'Kampala Kawempe',
        location: 'Kawempe',
        agents: 22,
        capacity: 30,
        status: 'warning',
        latitude: 0.3717,
        longitude: 32.5656,
      ),
      Station(
        id: 'UG-EBB-001',
        name: 'Entebbe Station',
        location: 'Entebbe',
        agents: 18,
        capacity: 25,
        status: 'active',
        latitude: 0.0522,
        longitude: 32.4435,
      ),
      Station(
        id: 'UG-JIN-001',
        name: 'Jinja Hub',
        location: 'Jinja',
        agents: 15,
        capacity: 22,
        status: 'active',
        latitude: 0.4244,
        longitude: 33.2040,
      ),
      Station(
        id: 'UG-MBA-001',
        name: 'Mbarara Regional',
        location: 'Mbarara',
        agents: 10,
        capacity: 18,
        status: 'active',
        latitude: -0.6069,
        longitude: 30.6582,
      ),
    ];
  }
}
