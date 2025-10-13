import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../agents/agents_page.dart';
import '../stations/stations_page.dart';
import '../batteries/batteries_page.dart';
import '../analytics/analytics_page.dart';
import '../incidents/incidents_page.dart';
import '../reports/reports_page.dart';
import '../data_entry/data_entry_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedMenuItem = 'Dashboard';
  Widget _currentPage = DashboardPageContent();
  bool _isSidebarOpen = true;

  void _navigateToPage(String pageName) {
    print('Navigating to: $pageName'); // Debug print

    setState(() {
      _selectedMenuItem = pageName;
      switch (pageName) {
        case 'Dashboard':
          _currentPage = DashboardPageContent();
          break;
        case 'Agents':
          _currentPage = AgentsPage();
          break;
        case 'Stations':
          _currentPage = StationsPage();
          break;
        case 'Batteries':
          _currentPage = BatteriesPage();
          break;
        case 'Analytics':
          _currentPage = AnalyticsPage();
          break;
        case 'Incidents':
          _currentPage = IncidentsPage();
          break;
        case 'Reports':
          _currentPage = ReportsPage();
          break;
        case 'Data Entry':
          _currentPage = DataEntryPage();
          break;
        default:
          _currentPage = DashboardPageContent();
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Animated Sidebar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isSidebarOpen ? 280 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: _isSidebarOpen
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  height: 120,
                  width: double.infinity,
                  color: shawnblue,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWithColor('Spiro App', 20, TextType.Bold, Colors.white),
                      SizedBox(height: 4),
                      textWithColor('Control Tower', 14, TextType.Regular, Colors.white),
                    ],
                  ),
                ),

                // Navigation Menu
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuSection('MAIN MENU', [
                        _buildMenuItem('Dashboard', Icons.dashboard),
                        _buildMenuItem('Agents', Icons.people),
                        _buildMenuItem('Stations', Icons.ev_station),
                        _buildMenuItem('Batteries', Icons.battery_std),
                        _buildMenuItem('Analytics', Icons.analytics),
                        _buildMenuItem('Incidents', Icons.warning),
                        _buildMenuItem('Reports', Icons.assessment),
                        _buildMenuItem('Data Entry', Icons.data_usage),
                      ]),
                      Divider(height: 32),
                      _buildMenuSection('SYSTEM', [
                        _buildMenuItem('Settings', Icons.settings),
                      ]),
                    ],
                  ),
                ),

                // User Profile Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: shawnblue,
                        child: Icon(Icons.person, color: Colors.white, size: 20),
                        radius: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text('Shawn Matunda', 14, TextType.Bold),
                            textWithColor('Global Admin', 12, TextType.Regular, Colors.grey[600]!),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, size: 20, color: Colors.grey[600]),
                        onPressed: () => _handleLogout(),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : SizedBox.shrink(),
          ),

          // Main Content Area with Toggle Button
          Expanded(
            child: Stack(
              children: [
                _currentPage,

                // Sidebar Toggle Button
                Positioned(
                  left: 16,
                  top: 16,
                  child: InkWell(
                    onTap: _toggleSidebar,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: shawnblue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isSidebarOpen ? Icons.chevron_left : Icons.chevron_right,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    bool isSelected = _selectedMenuItem == title;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? shawnblue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? shawnblue : Colors.grey[700],
          size: 20,
        ),
        title: textWithColor(
          title,
          14,
          isSelected ? TextType.Bold : TextType.Regular,
          isSelected ? shawnblue : Colors.grey[700]!,
        ),
        trailing: isSelected ? Icon(Icons.arrow_forward_ios, size: 14, color: shawnblue) : null,
        selected: isSelected,
        onTap: () => _navigateToPage(title),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: textWithColor(title, 12, TextType.Bold, Colors.grey[600]!),
        ),
        ...items,
      ],
    );
  }

  void _handleLogout() {
    print('Logging out...');
    // Implement logout logic here
  }
}

// Dashboard Page Content
class DashboardPageContent extends StatefulWidget {
  const DashboardPageContent({super.key});

  @override
  State<DashboardPageContent> createState() => _DashboardPageContentState();
}

class _DashboardPageContentState extends State<DashboardPageContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _barAnimation;
  bool _animationPlayed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _barAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_animationPlayed) {
        _animationController.forward();
        _animationPlayed = true;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: shawnblue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWithColor('Dashboard', 24, TextType.Bold, Colors.white),
                      SizedBox(height: 4),
                      textWithColor('Control tower overview', 16, TextType.Regular, Colors.white),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => _refreshData(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Stats Grid
          _buildStatsGrid(),
          SizedBox(height: 24),

          // Africa Map Section
          _buildAfricaMapSection(),
          SizedBox(height: 24),

          // Main Content Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildMainContentColumn()),
              SizedBox(width: 16),
              Expanded(flex: 1, child: _buildSideContentColumn()),
            ],
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    print('Refreshing data...');
    // Reset and replay animation when refreshing
    _animationController.reset();
    _animationController.forward();
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Active Agents', '1229', '19 total • +12% vs last week', '+12%', true),
        _buildStatCard('Swaps Today', '999', '99,999 total • Target: 100,000', '+69%', true),
        _buildStatCard('Active Issues', '20', 'Across all stations critical', null, false),
        _buildStatCard('Downtime %', '2.1%', '97.9% uptime good', null, true),
        _buildStatCard('Power Usage', '12.4 MW', '14-day avg: 11.8 MW', '+3.2%', true),
      ],
    );
  }

  Widget _buildStatCard(String title, String mainValue, String subtitle, String? trend, bool? trendPositive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWithColor(title, 14, TextType.SemiBold, Colors.grey[700]!),
          text(mainValue, 24, TextType.Bold),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWithColor(subtitle, 12, TextType.Regular, Colors.grey[600]!),
              if (trend != null) ...[
                SizedBox(height: 4),
                textWithColor(trend, 12, TextType.SemiBold, trendPositive == true ? Colors.green : Colors.red),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAfricaMapSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(value: true, onChanged: (v) {}),
              SizedBox(width: 8),
              text('Africa Operations Map', 16, TextType.Bold),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: text('Africa Map Visualization', 16, TextType.Regular),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentColumn() {
    return Column(
      children: [
        _buildChartsRow(),
        SizedBox(height: 24),
        _buildSwapsTrendSection(),
      ],
    );
  }

  Widget _buildSideContentColumn() {
    return Column(
      children: [
        _buildAgentsSection(),
        SizedBox(height: 24),
        _buildActiveAlerts(),
      ],
    );
  }

  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildDowntimeChart()),
        SizedBox(width: 16),
        Expanded(child: _buildPowerConsumptionChart()),
      ],
    );
  }

  Widget _buildDowntimeChart() {
    return _buildChartContainer(
      'Downtime %',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Percentage')),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: [
                ChartData('Station A', 60, Colors.blue),
                ChartData('Station B', 85, Colors.orange),
                ChartData('Station C', 45, Colors.red),
                ChartData('Station D', 70, Colors.green),
                ChartData('Station E', 55, Colors.purple),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPowerConsumptionChart() {
    return _buildChartContainer(
      'Power Consumption (14-day)',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date')),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Power (kWh)')),
          series: <CartesianSeries>[
            LineSeries<ChartData, String>(
              dataSource: [
                ChartData('Sep 26', 800, Colors.blue),
                ChartData('Sep 28', 650, Colors.blue),
                ChartData('Sep 30', 720, Colors.blue),
                ChartData('Oct 2', 580, Colors.blue),
                ChartData('Oct 4', 690, Colors.blue),
                ChartData('Oct 6', 750, Colors.blue),
                ChartData('Oct 8', 820, Colors.blue),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(isVisible: true),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(title, 16, TextType.Bold),
          SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildSwapsTrendSection() {
    final List<BarData> barData = [
      BarData(800, Colors.blue, 'Mon'),
      BarData(600, Colors.orange, 'Tue'),
      BarData(400, Colors.orange, 'Wed'),
      BarData(550, Colors.blue, 'Thu'),
      BarData(300, Colors.orange, 'Fri'),
      BarData(200, Colors.orange, 'Sat'),
      BarData(450, Colors.orange, 'Sun'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text('Swaps Trend', 16, TextType.Bold),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: AnimatedBuilder(
              animation: _barAnimation,
              builder: (context, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: barData.map((data) {
                    final animatedHeight = data.height * _barAnimation.value;
                    return _buildAnimatedBar(animatedHeight, data.color, data.label);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBar(double height, Color color, String label) {
    return Column(
      children: [
        Container(
          width: 20,
          height: height / 8, // Scale down for better visualization
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        SizedBox(height: 4),
        text(label, 10, TextType.Regular),
      ],
    );
  }

  Widget _buildAgentsSection() {
    return Container(
      width: double.infinity,
      height: 300, // Same height as Africa operations map
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: text('On-Shift Agents', 16, TextType.Bold),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: text('ID', 12, TextType.Bold)),
                Expanded(flex: 3, child: text('Name', 12, TextType.Bold)),
                Expanded(flex: 3, child: text('Station', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Status', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Shift', 12, TextType.Bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildAgentRow('AGQ01', 'John Doe', 'Accra Central', 'online', 'Morning'),
                _buildAgentRow('AGQ02', 'Sarah Wilson', 'Lagos Island', 'busy', 'Morning'),
                _buildAgentRow('AGQ03', 'Michael Chen', 'Nairobi CBD', 'online', 'Morning'),
                _buildAgentRow('AGQ04', 'Emma Johnson', 'Kumasi Hub', 'break', 'Morning'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentRow(String id, String name, String station, String status, String shift) {
    Color statusColor = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(flex: 2, child: text(id, 12, TextType.Regular)),
          Expanded(flex: 3, child: text(name, 12, TextType.Regular)),
          Expanded(flex: 3, child: text(station, 12, TextType.Regular)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                SizedBox(width: 4),
                text(status, 12, TextType.Regular),
              ],
            ),
          ),
          Expanded(flex: 2, child: text(shift, 12, TextType.Regular)),
        ],
      ),
    );
  }

  Widget _buildActiveAlerts() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(16), child: text('Active Alerts', 16, TextType.Bold)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: textWithColor(
                '3 critical alerts require immediate attention',
                12,
                TextType.SemiBold,
                Colors.red
            ),
          ),
          SizedBox(height: 16),
          _buildAlertItem('Power Consumption High', 'Station power usage exceeds normal parameters', 'Power - Kumasi Hub • Ghana', '45 minutes ago', Colors.red),
          SizedBox(height: 12),
          _buildAlertItem('Connectivity Issues', 'Intermittent WiFi connectivity reported', 'Connectivity - Tamale Station • Ghana', '1 hour ago', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String description, String location, String time, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: textWithColor(title, 12, TextType.Bold, color)),
              Icon(Icons.help_outline, size: 16, color: color),
            ],
          ),
          SizedBox(height: 4),
          text(description, 11, TextType.Regular),
          SizedBox(height: 4),
          textWithColor(location, 10, TextType.Regular, Colors.grey[600]!),
          SizedBox(height: 4),
          textWithColor(time, 10, TextType.Regular, Colors.grey[600]!),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'break':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;
  ChartData(this.x, this.y, this.color);
}

class BarData {
  final double height;
  final Color color;
  final String label;
  BarData(this.height, this.color, this.label);
}