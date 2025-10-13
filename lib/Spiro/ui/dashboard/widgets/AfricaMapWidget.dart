import 'package:flutter/material.dart';

import '../../../data/internal/application/Country.dart';
import '../../../data/internal/application/TextType.dart';
import '../../../designs/Component.dart';

class AfricaMapWidget extends StatefulWidget {
  final Function(String?) onCountrySelect;
  final String? selectedCountry;

  const AfricaMapWidget({
    Key? key,
    required this.onCountrySelect,
    this.selectedCountry,
  }) : super(key: key);

  @override
  State<AfricaMapWidget> createState() => _AfricaMapWidgetState();
}

class _AfricaMapWidgetState extends State<AfricaMapWidget>
    with SingleTickerProviderStateMixin {
  String? hoveredCountry;
  late AnimationController _pulseController;
  List<Country> countries = [];

  // Map visual coordinates for each country
  final Map<String, CountryVisualData> countryVisuals = {
    'KE': CountryVisualData(
      coordinates: Offset(380, 280),
      color: Color(0xFF10B981), // green
      flag: '🇰🇪',
    ),
    'RW': CountryVisualData(
      coordinates: Offset(280, 320),
      color: Color(0xFF3B82F6), // blue
      flag: '🇷🇼',
    ),
    'UG': CountryVisualData(
      coordinates: Offset(240, 240),
      color: Color(0xFF8B5CF6), // purple
      flag: '🇺🇬',
    ),
  };

  @override
  void initState() {
    super.initState();
    countries = Country.getCountries();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStations = countries.fold<int>(
      0,
      (sum, country) => sum + country.stations.length,
    );
    final totalAgents = countries.fold<int>(
      0,
      (sum, country) => sum + country.totalAgents,
    );
    final totalSwaps = countries.fold<int>(
      0,
      (sum, country) => sum + country.totalSwaps,
    );

    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[50]!, Colors.green[50]!],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Stack(
        children: [
          // Background Grid Pattern
          CustomPaint(size: Size.infinite, painter: GridPatternPainter()),

          // Title
          Positioned(
            top: 24,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.map, color: Colors.blue[600], size: 24),
                    SizedBox(width: 8),
                    text('East Africa Operations Map', 20, TextType.Bold),
                  ],
                ),
                SizedBox(height: 4),
                textWithColor(
                  'Click a country to view detailed operations',
                  12,
                  TextType.Regular,
                  Colors.grey[600]!,
                ),
              ],
            ),
          ),

          // Legend
          Positioned(
            top: 24,
            right: 24,
            child: Container(
              padding: EdgeInsets.all(16),
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
                  text('Network Status', 12, TextType.Bold),
                  SizedBox(height: 12),
                  _buildLegendItem(Colors.green[500]!, 'Active Operations'),
                  SizedBox(height: 8),
                  _buildLegendItem(Colors.orange[500]!, 'Warning Status'),
                ],
              ),
            ),
          ),

          // Country Markers
          CustomPaint(
            size: Size.infinite,
            painter: CountryMarkersPainter(
              countries: countries,
              countryVisuals: countryVisuals,
              selectedCountry: widget.selectedCountry,
              hoveredCountry: hoveredCountry,
              pulseAnimation: _pulseController,
            ),
          ),

          // Interactive Overlay for Click Detection
          ...countries.map((country) {
            final visual = countryVisuals[country.code]!;
            final isSelected = widget.selectedCountry == country.code;
            final isHovered = hoveredCountry == country.code;
            final size = isSelected
                ? 80.0
                : isHovered
                ? 70.0
                : 60.0;

            return Positioned(
              left: visual.coordinates.dx - size / 2,
              top: visual.coordinates.dy - size / 2,
              child: GestureDetector(
                onTap: () {
                  widget.onCountrySelect(isSelected ? null : country.code);
                },
                child: MouseRegion(
                  onEnter: (_) => setState(() => hoveredCountry = country.code),
                  onExit: (_) => setState(() => hoveredCountry = null),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        visual.flag,
                        style: TextStyle(fontSize: size / 2.5),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),

          // Country Info Cards
          ...countries.map((country) {
            final visual = countryVisuals[country.code]!;
            final isSelected = widget.selectedCountry == country.code;
            final isHovered = hoveredCountry == country.code;

            if (!isSelected && !isHovered) return SizedBox.shrink();

            return Positioned(
              left: visual.coordinates.dx + 60,
              top: visual.coordinates.dy - 80,
              child: _buildCountryInfoCard(country, visual, isSelected),
            );
          }).toList(),

          // Summary Stats
          Positioned(
            bottom: 24,
            left: 24,
            child: Container(
              padding: EdgeInsets.all(16),
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
                  text('Regional Summary', 12, TextType.Bold),
                  SizedBox(height: 12),
                  _buildStatRow('Total Countries', '${countries.length}'),
                  SizedBox(height: 8),
                  _buildStatRow('Total Stations', totalStations.toString()),
                  SizedBox(height: 8),
                  _buildStatRow('Active Agents', totalAgents.toString()),
                  SizedBox(height: 8),
                  _buildStatRow('Total Swaps', totalSwaps.toString()),
                ],
              ),
            ),
          ),

          // Clear Filter Button
          if (widget.selectedCountry != null)
            Positioned(
              bottom: 24,
              right: 24,
              child: ElevatedButton.icon(
                onPressed: () => widget.onCountrySelect(null),
                icon: Icon(Icons.clear, size: 16),
                label: textWithColor(
                  'Clear Filter',
                  12,
                  TextType.Bold,
                  Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        textWithColor(label, 10, TextType.Regular, Colors.grey[600]!),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWithColor(label, 10, TextType.Regular, Colors.grey[600]!),
        SizedBox(width: 24),
        text(value, 12, TextType.Bold),
      ],
    );
  }

  Widget _buildCountryInfoCard(
    Country country,
    CountryVisualData visual,
    bool isSelected,
  ) {
    final statusText = country.status == 'active' ? 'EXCELLENT' : 'WARNING';
    final statusColor = country.status == 'active'
        ? Colors.green[600]!
        : Colors.orange[600]!;

    return Container(
      width: 280,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: visual.color, width: 2),
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
              Row(
                children: [
                  Text(visual.flag, style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  text(country.name, 16, TextType.Bold),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor),
                ),
                child: textWithColor(
                  statusText,
                  10,
                  TextType.Bold,
                  statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.location_on,
                  'Stations',
                  country.stations.length.toString(),
                  Colors.grey[100]!,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.people,
                  'Agents',
                  country.totalAgents.toString(),
                  Colors.grey[100]!,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Total Swaps
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.battery_charging_full,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    textWithColor(
                      'Total Swaps',
                      10,
                      TextType.Regular,
                      Colors.grey[600]!,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(country.totalSwaps.toString(), 18, TextType.Bold),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Colors.green[600],
                        ),
                        SizedBox(width: 4),
                        textWithColor(
                          '+12%',
                          12,
                          TextType.Bold,
                          Colors.green[600]!,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  widget.onCountrySelect(isSelected ? null : country.code),
              style: ElevatedButton.styleFrom(
                backgroundColor: visual.color,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: textWithColor(
                isSelected ? 'View All Countries' : 'View Details',
                12,
                TextType.Bold,
                Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Flexible(
                child: textWithColor(
                  label,
                  10,
                  TextType.Regular,
                  Colors.grey[600]!,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          text(value, 18, TextType.Bold),
        ],
      ),
    );
  }
}

// Country Visual Data Model
class CountryVisualData {
  final Offset coordinates;
  final Color color;
  final String flag;

  CountryVisualData({
    required this.coordinates,
    required this.color,
    required this.flag,
  });
}

// Grid Pattern Painter
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

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

// Country Markers Painter
class CountryMarkersPainter extends CustomPainter {
  final List<Country> countries;
  final Map<String, CountryVisualData> countryVisuals;
  final String? selectedCountry;
  final String? hoveredCountry;
  final Animation<double> pulseAnimation;

  CountryMarkersPainter({
    required this.countries,
    required this.countryVisuals,
    required this.selectedCountry,
    required this.hoveredCountry,
    required this.pulseAnimation,
  }) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    for (final country in countries) {
      final visual = countryVisuals[country.code];
      if (visual == null) continue;

      final isSelected = selectedCountry == country.code;
      final isHovered = hoveredCountry == country.code;
      final markerSize = isSelected
          ? 40.0
          : isHovered
          ? 35.0
          : 30.0;

      // Draw pulse effect for selected country
      if (isSelected) {
        final pulsePaint = Paint()
          ..color = visual.color.withOpacity(0.2 * (1 - pulseAnimation.value))
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          visual.coordinates,
          40 + (20 * pulseAnimation.value),
          pulsePaint,
        );
      }

      // Draw main circle
      final circlePaint = Paint()
        ..color = visual.color.withOpacity(
          isSelected
              ? 1.0
              : isHovered
              ? 0.9
              : 0.8,
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(visual.coordinates, markerSize, circlePaint);

      // Draw white border
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(visual.coordinates, markerSize, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CountryMarkersPainter oldDelegate) {
    return selectedCountry != oldDelegate.selectedCountry ||
        hoveredCountry != oldDelegate.hoveredCountry;
  }
}
