import 'package:flutter/material.dart';

import '../../../data/internal/application/Country.dart';
import '../../../data/internal/application/TextType.dart';
import '../../../designs/Component.dart';

class CountryMapWidget extends StatefulWidget {
  final String countryCode;

  const CountryMapWidget({Key? key, required this.countryCode})
    : super(key: key);

  @override
  State<CountryMapWidget> createState() => _CountryMapWidgetState();
}

class _CountryMapWidgetState extends State<CountryMapWidget> {
  String? selectedStation;
  Country? country;

  @override
  void initState() {
    super.initState();
    _loadCountryData();
  }

  @override
  void didUpdateWidget(CountryMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryCode != widget.countryCode) {
      _loadCountryData();
    }
  }

  void _loadCountryData() {
    final countries = Country.getCountries();
    setState(() {
      country = countries.firstWhere(
        (c) => c.code == widget.countryCode,
        orElse: () => countries[0],
      );
    });
  }

  Map<String, StationVisualData> _generateStationCoordinates() {
    if (country == null) return {};

    // Generate evenly distributed coordinates for stations
    final Map<String, StationVisualData> visualData = {};
    final stations = country!.stations;

    // Predefined positions for better visual distribution
    final List<Offset> positions = [
      Offset(320, 280), // Center
      Offset(280, 260), // West
      Offset(350, 290), // East
      Offset(480, 380), // Far East
      Offset(180, 240), // Far West
      Offset(240, 220), // North-West
      Offset(200, 180), // North
      Offset(340, 250), // North-East
      Offset(300, 340), // South
      Offset(400, 300), // Center-East
    ];

    for (int i = 0; i < stations.length; i++) {
      final station = stations[i];
      final position = positions[i % positions.length];

      visualData[station.id] = StationVisualData(
        coordinates: position,
        color: _getStatusColor(station.status),
      );
    }

    return visualData;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Color(0xFF10B981); // green
      case 'warning':
        return Color(0xFFF59E0B); // orange
      case 'maintenance':
        return Color(0xFFEF4444); // red
      default:
        return Color(0xFF6B7280); // gray
    }
  }

  String _getCountryFlag(String code) {
    switch (code) {
      case 'KE':
        return '🇰🇪';
      case 'RW':
        return '🇷🇼';
      case 'UG':
        return '🇺🇬';
      default:
        return '🌍';
    }
  }

  Widget _buildConnectivityIndicator(String connectivity) {
    final strength = connectivity == 'excellent'
        ? 3
        : connectivity == 'good'
        ? 2
        : 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 3,
          height: (index + 1) * 4.0,
          margin: EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            color: index < strength ? Colors.green[500] : Colors.grey[300],
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (country == null) {
      return Center(child: CircularProgressIndicator());
    }

    final stationVisuals = _generateStationCoordinates();
    final activeStations = country!.stations
        .where((s) => s.status == 'active')
        .length;
    final warningStations = country!.stations
        .where((s) => s.status == 'warning')
        .length;
    final totalSwapsToday = country!.stations.fold<int>(
      0,
      (sum, s) => sum + (s.capacity ~/ 5), // Approximate daily swaps
    );

    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9FAFB), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Stack(
        children: [
          // Background Grid Pattern
          CustomPaint(size: Size.infinite, painter: CountryGridPainter()),

          // Title Header
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.map, color: Colors.blue[600], size: 20),
                      SizedBox(width: 8),
                      Text(
                        _getCountryFlag(country!.code),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 8),
                      text('${country!.name} Stations', 16, TextType.Bold),
                    ],
                  ),
                  SizedBox(height: 4),
                  textWithColor(
                    '${country!.stations.length} active locations',
                    10,
                    TextType.Regular,
                    Colors.grey[600]!,
                  ),
                ],
              ),
            ),
          ),

          // Legend
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  text('Station Status', 10, TextType.Bold),
                  SizedBox(height: 8),
                  _buildLegendItem(
                    Color(0xFF10B981),
                    'Active ($activeStations)',
                  ),
                  if (warningStations > 0) ...[
                    SizedBox(height: 6),
                    _buildLegendItem(
                      Color(0xFFF59E0B),
                      'Warning ($warningStations)',
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Station Markers (Background circles)
          CustomPaint(
            size: Size.infinite,
            painter: StationMarkersPainter(
              stations: country!.stations,
              stationVisuals: stationVisuals,
              selectedStation: selectedStation,
            ),
          ),

          // Interactive Station Overlays
          ...country!.stations.map((station) {
            final visual = stationVisuals[station.id];
            if (visual == null) return SizedBox.shrink();

            final isSelected = selectedStation == station.id;
            final size = isSelected ? 28.0 : 20.0;

            return Positioned(
              left: visual.coordinates.dx - size / 2,
              top: visual.coordinates.dy - size / 2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStation = isSelected ? null : station.id;
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),

          // Station Info Card
          if (selectedStation != null) ...[
            Builder(
              builder: (context) {
                final station = country!.stations.firstWhere(
                  (s) => s.id == selectedStation,
                );
                final visual = stationVisuals[station.id]!;

                // Calculate daily swaps estimate
                final dailySwaps = station.capacity ~/ 5;

                return Positioned(
                  left: visual.coordinates.dx + 25 > 450
                      ? visual.coordinates.dx - 325
                      : visual.coordinates.dx + 25,
                  top: visual.coordinates.dy - 140 < 10
                      ? 10
                      : visual.coordinates.dy - 140,
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(station.name, 14, TextType.Bold),
                                  SizedBox(height: 2),
                                  textWithColor(
                                    station.location,
                                    10,
                                    TextType.Regular,
                                    Colors.grey[600]!,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  station.status,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _getStatusColor(station.status),
                                ),
                              ),
                              child: textWithColor(
                                station.status.toUpperCase(),
                                8,
                                TextType.Bold,
                                _getStatusColor(station.status),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Stats Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildStationStatCard(
                                Icons.people,
                                'Agents',
                                station.agents.toString(),
                                Colors.blue[50]!,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildStationStatCard(
                                Icons.battery_charging_full,
                                'Capacity',
                                station.capacity.toString(),
                                Colors.green[50]!,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Additional Info
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.battery_charging_full,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 6),
                                      textWithColor(
                                        'Today',
                                        9,
                                        TextType.Regular,
                                        Colors.grey[600]!,
                                      ),
                                    ],
                                  ),
                                  textWithColor(
                                    '$dailySwaps swaps',
                                    10,
                                    TextType.Bold,
                                    Colors.grey[900]!,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.flash_on,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 6),
                                      textWithColor(
                                        'Power',
                                        9,
                                        TextType.Regular,
                                        Colors.grey[600]!,
                                      ),
                                    ],
                                  ),
                                  textWithColor(
                                    '${85 + (station.agents % 15)}%',
                                    10,
                                    TextType.Bold,
                                    Colors.green[600]!,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.wifi,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 6),
                                      textWithColor(
                                        'Connectivity',
                                        9,
                                        TextType.Regular,
                                        Colors.grey[600]!,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _buildConnectivityIndicator(
                                        station.agents > 25
                                            ? 'excellent'
                                            : station.agents > 15
                                            ? 'good'
                                            : 'fair',
                                      ),
                                      SizedBox(width: 6),
                                      textWithColor(
                                        station.agents > 25
                                            ? 'Excellent'
                                            : station.agents > 15
                                            ? 'Good'
                                            : 'Fair',
                                        9,
                                        TextType.Bold,
                                        Colors.grey[900]!,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          // Summary Stats
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  text('Summary', 10, TextType.Bold),
                  SizedBox(height: 8),
                  _buildSummaryRow(
                    'Total Agents',
                    country!.totalAgents.toString(),
                  ),
                  SizedBox(height: 6),
                  _buildSummaryRow(
                    'Total Capacity',
                    country!.stations
                        .fold<int>(0, (sum, s) => sum + s.capacity)
                        .toString(),
                  ),
                  SizedBox(height: 6),
                  _buildSummaryRow(
                    'Today',
                    '$totalSwapsToday swaps',
                    valueColor: Colors.green[600]!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        textWithColor(label, 9, TextType.Regular, Colors.grey[600]!),
      ],
    );
  }

  Widget _buildStationStatCard(
    IconData icon,
    String label,
    String value,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey[600]),
              SizedBox(width: 6),
              Flexible(
                child: textWithColor(
                  label,
                  9,
                  TextType.Regular,
                  Colors.grey[600]!,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          text(value, 16, TextType.Bold),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWithColor(label, 9, TextType.Regular, Colors.grey[600]!),
        SizedBox(width: 20),
        textWithColor(
          value,
          10,
          TextType.Bold,
          valueColor ?? Colors.grey[900]!,
        ),
      ],
    );
  }
}

// Station Visual Data Model
class StationVisualData {
  final Offset coordinates;
  final Color color;

  StationVisualData({required this.coordinates, required this.color});
}

// Country Grid Painter
class CountryGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF3B82F6).withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Station Markers Painter
class StationMarkersPainter extends CustomPainter {
  final List<Station> stations;
  final Map<String, StationVisualData> stationVisuals;
  final String? selectedStation;

  StationMarkersPainter({
    required this.stations,
    required this.stationVisuals,
    required this.selectedStation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final station in stations) {
      final visual = stationVisuals[station.id];
      if (visual == null) continue;

      final isSelected = selectedStation == station.id;
      final markerSize = isSelected ? 14.0 : 10.0;

      // Draw glow effect for selected
      if (isSelected) {
        final glowPaint = Paint()
          ..color = visual.color.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(visual.coordinates, 20, glowPaint);
      }

      // Draw main circle
      final circlePaint = Paint()
        ..color = visual.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(visual.coordinates, markerSize, circlePaint);

      // Draw white border
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(visual.coordinates, markerSize, borderPaint);
    }
  }

  @override
  bool shouldRepaint(StationMarkersPainter oldDelegate) {
    return selectedStation != oldDelegate.selectedStation;
  }
}
