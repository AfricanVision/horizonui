import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/DesignSystem.dart';
import '../agents/agents_page.dart';
import '../analytics/analytics_page.dart';
import '../batteries/batteries_page.dart';
import '../incidents/incidents_page.dart';
import '../reports/reports_page.dart';
import '../settings/settings_page.dart';
import '../stations/stations_page.dart';
import 'DashboardService.dart';

// FIXED: Added utility widgets to prevent render overflow
class ClampedBox extends StatelessWidget {
  final Widget child;

  const ClampedBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
          ),
          child: child,
        );
      },
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  String _selectedMenuItem = 'Dashboard';
  Widget _currentPage = DashboardPageContent();
  bool _isSidebarOpen = true;
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      duration: SpiroDesignSystem.duration300,
      vsync: this,
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: SpiroDesignSystem.easeOut,
    );
    _sidebarController.forward();
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _navigateToPage(String pageName) {
    debugPrint('Navigating to: $pageName');

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
        case 'Settings':
          _currentPage = SettingsPage();
          break;
        default:
          _currentPage = DashboardPageContent();
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _sidebarController.forward();
      } else {
        _sidebarController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpiroDesignSystem.gray50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Enhanced Animated Sidebar - FIXED OVERFLOW
              AnimatedBuilder(
                animation: _sidebarAnimation,
                builder: (context, child) {
                  final sidebarWidth = (_isSidebarOpen
                      ? (constraints.maxWidth > 1200 ? 280.0 : 250.0) *
                            _sidebarAnimation.value
                      : 0.0);

                  return Container(
                    width: sidebarWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          SpiroDesignSystem.primaryBlue600,
                          SpiroDesignSystem.primaryBlue700,
                        ],
                      ),
                      boxShadow: SpiroDesignSystem.shadowXl,
                    ),
                    child: ClipRect(
                      child: Opacity(
                        opacity: _sidebarAnimation.value,
                        child: sidebarWidth > 100
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Enhanced Header with glassmorphism - FIXED TEXT OVERFLOW
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          SpiroDesignSystem.primaryBlue500,
                                          SpiroDesignSystem.primaryBlue600,
                                        ],
                                      ),
                                    ),
                                    padding: EdgeInsets.all(
                                      SpiroDesignSystem.space3,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Spiro Control',
                                            style: SpiroDesignSystem.titleL
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ).fadeIn(),
                                        ),
                                        SizedBox(
                                          height: SpiroDesignSystem.space0_5,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Operations Control Tower',
                                            style: SpiroDesignSystem.bodyL
                                                .copyWith(
                                                  color: Colors.white70,
                                                ),
                                          ).fadeIn(),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            SpiroDesignSystem.primaryBlue600,
                                            SpiroDesignSystem.primaryBlue700,
                                          ],
                                        ),
                                      ),
                                      child: ScrollConfiguration(
                                        behavior: ScrollConfiguration.of(
                                          context,
                                        ).copyWith(scrollbars: false),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          physics: ClampingScrollPhysics(),
                                          children: [
                                            _buildMenuItem(
                                              'Dashboard',
                                              Icons.dashboard_outlined,
                                              Icons.dashboard,
                                            ),
                                            _buildMenuItem(
                                              'Agents',
                                              Icons.people_outline,
                                              Icons.people,
                                            ),
                                            _buildMenuItem(
                                              'Stations',
                                              Icons.ev_station_outlined,
                                              Icons.ev_station,
                                            ),
                                            _buildMenuItem(
                                              'Batteries',
                                              Icons.battery_std_outlined,
                                              Icons.battery_std,
                                            ),
                                            _buildMenuItem(
                                              'Analytics',
                                              Icons.analytics_outlined,
                                              Icons.analytics,
                                            ),
                                            _buildMenuItem(
                                              'Incidents',
                                              Icons.warning_amber_outlined,
                                              Icons.warning_amber,
                                            ),
                                            _buildMenuItem(
                                              'Reports',
                                              Icons.assessment_outlined,
                                              Icons.assessment,
                                            ),
                                            _buildMenuItem(
                                              'Settings',
                                              Icons.settings_outlined,
                                              Icons.settings,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Enhanced User Profile Section - FIXED OVERFLOW
                                  Container(
                                    margin: EdgeInsets.all(
                                      SpiroDesignSystem.space2,
                                    ),
                                    padding: EdgeInsets.all(
                                      SpiroDesignSystem.space3,
                                    ),
                                    decoration: SpiroDesignSystem
                                        .glassMorphismDecoration,
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: SpiroDesignSystem
                                                  .primaryGradient,
                                              boxShadow: SpiroDesignSystem
                                                  .shadowPrimary,
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              radius: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: SpiroDesignSystem.space2,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Shawn Matunda',
                                                  style: SpiroDesignSystem.bodyL
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  'Global Admin',
                                                  style: SpiroDesignSystem.bodyS
                                                      .copyWith(
                                                        color: Colors.white70,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: 0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    SpiroDesignSystem.radiusMd,
                                                  ),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.logout,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.zero,
                                              onPressed: () => _handleLogout(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).slideIn(),
                                ],
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                  );
                },
              ),

              // Enhanced Main Content Area - FIXED FLEX OVERFLOW
              Expanded(
                child: ClampedBox(
                  child: Stack(
                    children: [
                      _currentPage.fadeIn(),

                      // Enhanced Sidebar Toggle Button - FIXED POSITIONING
                      Positioned(
                        left: SpiroDesignSystem.space4,
                        top: SpiroDesignSystem.space4,
                        child: SafeArea(
                          child: AnimatedScale(
                            scale: _isSidebarOpen ? 0.9 : 1.1,
                            duration: SpiroDesignSystem.duration200,
                            child: InkWell(
                              onTap: _toggleSidebar,
                              borderRadius: BorderRadius.circular(
                                SpiroDesignSystem.radiusFull,
                              ),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: SpiroDesignSystem.primaryGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: SpiroDesignSystem.shadowPrimary,
                                ),
                                child: Icon(
                                  _isSidebarOpen
                                      ? Icons.chevron_left
                                      : Icons.menu,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData outlineIcon,
    IconData filledIcon,
  ) {
    bool isSelected = _selectedMenuItem == title;
    return AnimatedContainer(
      duration: SpiroDesignSystem.duration200,
      margin: EdgeInsets.symmetric(
        horizontal: SpiroDesignSystem.space2,
        vertical: SpiroDesignSystem.space0_5,
      ),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [Colors.white24, Colors.white12],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        border: isSelected ? Border.all(color: Colors.white30, width: 1) : null,
        boxShadow: isSelected ? SpiroDesignSystem.shadowSm : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToPage(title),
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
          child: ListTile(
            leading: SizedBox(
              width: 24,
              height: 24,
              child: AnimatedSwitcher(
                duration: SpiroDesignSystem.duration150,
                child: Icon(
                  isSelected ? filledIcon : outlineIcon,
                  color: Colors.white,
                  size: 20,
                  key: ValueKey(isSelected),
                ),
              ),
            ),
            title: Text(
              title,
              style: SpiroDesignSystem.bodyL.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.white,
              ),
            ),
            trailing: isSelected
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white30,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    debugPrint('Logging out...');
    // Implement logout logic here
  }
}

// Dashboard Page Content
class DashboardPageContent extends StatefulWidget {
  const DashboardPageContent({super.key});

  @override
  State<DashboardPageContent> createState() => _DashboardPageContentState();
}

class _DashboardPageContentState extends State<DashboardPageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _barAnimation;
  bool _animationPlayed = false;
  bool _isRefreshing = false;

  // Dashboard service and data
  final DashboardService _dashboardService = DashboardService();
  DashboardData? _dashboardData;
  List<Agent> _onShiftAgents = [];
  List<Alert> _activeAlerts = [];

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

    // Load initial data
    _loadDashboardData();

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

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isRefreshing = true;
      });

      // Load all dashboard data concurrently
      final results = await Future.wait([
        _dashboardService.getDashboardData(),
        _dashboardService.getOnShiftAgents(),
        _dashboardService.getActiveAlerts(),
      ]);

      if (mounted) {
        setState(() {
          _dashboardData = results[0] as DashboardData;
          _onShiftAgents = results[1] as List<Agent>;
          _activeAlerts = results[2] as List<Alert>;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
          // Use fallback mock data when API is not available
          _dashboardData = DashboardData(
            activeAgents: 1229,
            swapsToday: 999,
            totalSwaps: 99999,
            activeIssues: 20,
            downtimePercentage: 2.1,
            powerUsage: 12.4,
            powerUsage14DayAvg: 11.8,
            targetSwaps: '100,000',
          );
          _onShiftAgents = [
            Agent(
              id: 'AGQ01',
              name: 'John Doe',
              station: 'Accra Central',
              status: 'online',
              shift: 'Morning',
            ),
            Agent(
              id: 'AGQ02',
              name: 'Sarah Wilson',
              station: 'Lagos Island',
              status: 'busy',
              shift: 'Morning',
            ),
            Agent(
              id: 'AGQ03',
              name: 'Michael Chen',
              station: 'Nairobi CBD',
              status: 'online',
              shift: 'Morning',
            ),
            Agent(
              id: 'AGQ04',
              name: 'Emma Johnson',
              station: 'Kumasi Hub',
              status: 'break',
              shift: 'Morning',
            ),
          ];
          _activeAlerts = [
            Alert(
              title: 'Power Consumption Critical',
              description:
                  'Station power usage exceeds maximum safe parameters',
              location: 'Power Systems - Kumasi Hub • Ghana',
              time: '45 minutes ago',
              type: 'critical',
            ),
            Alert(
              title: 'Network Connectivity Issues',
              description:
                  'Intermittent WiFi connectivity affecting operations',
              location: 'Network - Tamale Station • Ghana',
              time: '1 hour ago',
              type: 'warning',
            ),
          ];
        });

        // Show a snackbar to indicate fallback data is being used
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using offline data - API server not available'),
            backgroundColor: SpiroDesignSystem.warning600,
            duration: Duration(seconds: 3),
          ),
        );
      }
      debugPrint('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Page Header with gradient - FIXED LAYOUT
          Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space6),
            decoration: BoxDecoration(
              gradient: SpiroDesignSystem.primaryGradient,
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
              boxShadow: SpiroDesignSystem.shadowPrimary,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Operations Control Dashboard',
                        style: SpiroDesignSystem.displayM.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ).fadeIn(),
                      SizedBox(height: SpiroDesignSystem.space1),
                      Text(
                        'Real-time operations monitoring • ${DateTime.now().toString().substring(0, 19)}',
                        style: SpiroDesignSystem.bodyL.copyWith(
                          color: Colors.white70,
                        ),
                      ).fadeIn(),
                    ],
                  ),
                ),
                // Single refresh button that actually works
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusFull,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _refreshData,
                      borderRadius: BorderRadius.circular(
                        SpiroDesignSystem.radiusFull,
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: _isRefreshing
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).slideIn(),
          SizedBox(height: SpiroDesignSystem.space6),

          // Enhanced Stats Grid with real data
          _buildStatsGrid(),
          SizedBox(height: SpiroDesignSystem.space6),

          // Enhanced Africa Map Section
          _buildAfricaMapSection(),
          SizedBox(height: SpiroDesignSystem.space6),

          // Enhanced Main Content Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildMainContentColumn()),
              SizedBox(width: SpiroDesignSystem.space4),
              Expanded(flex: 1, child: _buildSideContentColumn()),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    debugPrint('Refreshing dashboard data...');
    _animationController.reset();
    _animationController.forward();
    await _loadDashboardData();
  }

  Widget _buildStatsGrid() {
    if (_dashboardData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: SpiroDesignSystem.primaryBlue600,
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: SpiroDesignSystem.space4,
      mainAxisSpacing: SpiroDesignSystem.space4,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Active Agents',
          '${_dashboardData!.activeAgents}',
          '19 total • +12% vs last week',
          '+12%',
          true,
          SpiroDesignSystem.success500,
        ).slideIn(),
        _buildStatCard(
          'Swaps Today',
          '${_dashboardData!.swapsToday}',
          '${_dashboardData!.totalSwaps} total • Target: ${_dashboardData!.targetSwaps}',
          '+69%',
          true,
          SpiroDesignSystem.primaryBlue500,
        ).slideIn(),
        _buildStatCard(
          'Active Issues',
          '${_dashboardData!.activeIssues}',
          'Across all stations critical',
          null,
          false,
          SpiroDesignSystem.danger500,
        ).slideIn(),
        _buildStatCard(
          'Downtime %',
          '${_dashboardData!.downtimePercentage}%',
          '${100 - _dashboardData!.downtimePercentage}% uptime good',
          null,
          true,
          SpiroDesignSystem.warning500,
        ).slideIn(),
        _buildStatCard(
          'Power Usage',
          '${_dashboardData!.powerUsage} MW',
          '14-day avg: ${_dashboardData!.powerUsage14DayAvg} MW',
          '+3.2%',
          true,
          SpiroDesignSystem.info500,
        ).slideIn(),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String mainValue,
    String subtitle,
    String? trend,
    bool? trendPositive,
    Color accentColor,
  ) {
    return MouseRegion(
      onEnter: (_) {},
      child: AnimatedContainer(
        duration: SpiroDesignSystem.duration200,
        decoration: SpiroDesignSystem.cardDecoration.copyWith(
          border: Border.all(
            color: accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(SpiroDesignSystem.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusSm,
                    ),
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space2),
                Expanded(
                  child: Text(
                    title,
                    style: SpiroDesignSystem.bodyL.copyWith(
                      fontWeight: FontWeight.w600,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              mainValue,
              style: SpiroDesignSystem.displayM.copyWith(
                fontWeight: FontWeight.w700,
                color: SpiroDesignSystem.gray900,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: SpiroDesignSystem.bodyS.copyWith(
                    color: SpiroDesignSystem.gray600,
                  ),
                ),
                if (trend != null) ...[
                  SizedBox(height: SpiroDesignSystem.space1),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpiroDesignSystem.space2,
                      vertical: SpiroDesignSystem.space0_5,
                    ),
                    decoration: BoxDecoration(
                      color: trendPositive == true
                          ? SpiroDesignSystem.success50
                          : SpiroDesignSystem.danger50,
                      borderRadius: BorderRadius.circular(
                        SpiroDesignSystem.radiusFull,
                      ),
                      border: Border.all(
                        color: trendPositive == true
                            ? SpiroDesignSystem.success200
                            : SpiroDesignSystem.danger200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      trend,
                      style: SpiroDesignSystem.caption.copyWith(
                        color: trendPositive == true
                            ? SpiroDesignSystem.success700
                            : SpiroDesignSystem.danger700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAfricaMapSection() {
    return Container(
      width: double.infinity,
      decoration: SpiroDesignSystem.cardDecoration,
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  gradient: SpiroDesignSystem.primaryGradient,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Icon(Icons.public, color: Colors.white, size: 20),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Africa Operations Map',
                      style: SpiroDesignSystem.titleM.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    Text(
                      'Real-time station monitoring across Africa',
                      style: SpiroDesignSystem.bodyS.copyWith(
                        color: SpiroDesignSystem.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: SpiroDesignSystem.success50,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusFull,
                  ),
                  border: Border.all(
                    color: SpiroDesignSystem.success200,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: SpiroDesignSystem.space3,
                  vertical: SpiroDesignSystem.space1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: SpiroDesignSystem.success500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: SpiroDesignSystem.space1),
                    Text(
                      'Live',
                      style: SpiroDesignSystem.caption.copyWith(
                        color: SpiroDesignSystem.success700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
              border: Border.all(
                color: SpiroDesignSystem.primaryBlue200,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(-1.2921, 36.8219), // Nairobi, Kenya
                  initialZoom: 5.0,
                  maxZoom: 18.0,
                  minZoom: 3.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.horizon.app',
                  ),
                  MarkerLayer(
                    markers: [
                      // Nairobi Station
                      Marker(
                        point: LatLng(-1.2921, 36.8219),
                        width: 32,
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: SpiroDesignSystem.success500,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.ev_station,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      // Lagos Station
                      Marker(
                        point: LatLng(6.5244, 3.3792),
                        width: 32,
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: SpiroDesignSystem.primaryBlue500,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.ev_station,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      // Accra Station
                      Marker(
                        point: LatLng(5.6037, -0.1870),
                        width: 32,
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: SpiroDesignSystem.warning500,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.ev_station,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      // Kumasi Station
                      Marker(
                        point: LatLng(6.6885, -1.6244),
                        width: 32,
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: SpiroDesignSystem.danger500,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.ev_station,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).slideIn();
  }

  Widget _buildMainContentColumn() {
    return Column(
      children: [
        _buildChartsRow(),
        SizedBox(height: SpiroDesignSystem.space6),
        _buildSwapsTrendSection(),
      ],
    );
  }

  Widget _buildSideContentColumn() {
    return Column(
      children: [
        _buildAgentsSection(),
        SizedBox(height: SpiroDesignSystem.space6),
        _buildActiveAlerts(),
      ],
    );
  }

  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildDowntimeChart().slideIn()),
        SizedBox(width: SpiroDesignSystem.space4),
        Expanded(child: _buildPowerConsumptionChart().slideIn()),
      ],
    );
  }

  Widget _buildDowntimeChart() {
    return _buildChartContainer(
      'Station Downtime Analysis',
      Icons.timeline,
      SpiroDesignSystem.warning500,
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            labelStyle: SpiroDesignSystem.bodyS.copyWith(
              color: SpiroDesignSystem.gray600,
            ),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(
              text: 'Percentage',
              textStyle: SpiroDesignSystem.bodyS.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
            labelStyle: SpiroDesignSystem.bodyS.copyWith(
              color: SpiroDesignSystem.gray600,
            ),
          ),
          plotAreaBorderWidth: 0,
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: [
                ChartData('Station A', 60, SpiroDesignSystem.primaryBlue500),
                ChartData('Station B', 85, SpiroDesignSystem.warning500),
                ChartData('Station C', 45, SpiroDesignSystem.success500),
                ChartData('Station D', 70, SpiroDesignSystem.info500),
                ChartData('Station E', 55, SpiroDesignSystem.danger500),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: SpiroDesignSystem.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusXs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerConsumptionChart() {
    return _buildChartContainer(
      'Power Consumption Trend',
      Icons.electric_bolt,
      SpiroDesignSystem.primaryBlue500,
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            title: AxisTitle(
              text: 'Date',
              textStyle: SpiroDesignSystem.bodyS.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
            labelStyle: SpiroDesignSystem.bodyS.copyWith(
              color: SpiroDesignSystem.gray600,
            ),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(
              text: 'Power (kWh)',
              textStyle: SpiroDesignSystem.bodyS.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
            labelStyle: SpiroDesignSystem.bodyS.copyWith(
              color: SpiroDesignSystem.gray600,
            ),
          ),
          plotAreaBorderWidth: 0,
          series: <CartesianSeries>[
            LineSeries<ChartData, String>(
              dataSource: [
                ChartData('Sep 26', 800, SpiroDesignSystem.primaryBlue500),
                ChartData('Sep 28', 650, SpiroDesignSystem.primaryBlue500),
                ChartData('Sep 30', 720, SpiroDesignSystem.primaryBlue500),
                ChartData('Oct 2', 580, SpiroDesignSystem.primaryBlue500),
                ChartData('Oct 4', 690, SpiroDesignSystem.primaryBlue500),
                ChartData('Oct 6', 750, SpiroDesignSystem.primaryBlue500),
                ChartData('Oct 8', 820, SpiroDesignSystem.primaryBlue500),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              color: SpiroDesignSystem.primaryBlue500,
              width: 3,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: SpiroDesignSystem.caption.copyWith(
                  color: SpiroDesignSystem.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              markerSettings: MarkerSettings(
                isVisible: true,
                color: SpiroDesignSystem.primaryBlue600,
                borderColor: Colors.white,
                borderWidth: 2,
                width: 8,
                height: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(
    String title,
    IconData icon,
    Color iconColor,
    Widget chart,
  ) {
    return Container(
      decoration: SpiroDesignSystem.cardDecoration,
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Expanded(
                child: Text(
                  title,
                  style: SpiroDesignSystem.titleM.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SpiroDesignSystem.gray900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          chart,
        ],
      ),
    );
  }

  Widget _buildSwapsTrendSection() {
    final List<BarData> barData = [
      BarData(800, SpiroDesignSystem.primaryBlue500, 'Mon'),
      BarData(600, SpiroDesignSystem.warning500, 'Tue'),
      BarData(400, SpiroDesignSystem.danger500, 'Wed'),
      BarData(550, SpiroDesignSystem.success500, 'Thu'),
      BarData(300, SpiroDesignSystem.info500, 'Fri'),
      BarData(200, SpiroDesignSystem.warning500, 'Sat'),
      BarData(450, SpiroDesignSystem.primaryBlue500, 'Sun'),
    ];

    return Container(
      decoration: SpiroDesignSystem.cardDecoration,
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  gradient: SpiroDesignSystem.primaryGradient,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Icon(Icons.trending_up, color: Colors.white, size: 18),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Swaps Trend',
                      style: SpiroDesignSystem.titleM.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    Text(
                      'Battery swap activity analysis',
                      style: SpiroDesignSystem.bodyS.copyWith(
                        color: SpiroDesignSystem.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          Container(
            height: 200,
            padding: EdgeInsets.all(SpiroDesignSystem.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  SpiroDesignSystem.gray50,
                  SpiroDesignSystem.gray100.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
              border: Border.all(color: SpiroDesignSystem.gray200, width: 1),
            ),
            child: AnimatedBuilder(
              animation: _barAnimation,
              builder: (context, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: barData.map((data) {
                    final animatedHeight = data.height * _barAnimation.value;
                    return _buildAnimatedBar(
                      animatedHeight,
                      data.color,
                      data.label,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    ).slideIn();
  }

  Widget _buildAnimatedBar(double height, Color color, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: height / 6, // Scale down for better visualization
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(SpiroDesignSystem.radiusXs),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(height: SpiroDesignSystem.space2),
        Text(
          label,
          style: SpiroDesignSystem.caption.copyWith(
            color: SpiroDesignSystem.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAgentsSection() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SpiroDesignSystem.primaryBlue50,
                  SpiroDesignSystem.primaryBlue100.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SpiroDesignSystem.radiusLg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(SpiroDesignSystem.space2),
                  decoration: BoxDecoration(
                    gradient: SpiroDesignSystem.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                  ),
                  child: Icon(Icons.people, color: Colors.white, size: 18),
                ),
                SizedBox(width: SpiroDesignSystem.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'On-Shift Agents',
                        style: SpiroDesignSystem.titleM.copyWith(
                          fontWeight: FontWeight.w600,
                          color: SpiroDesignSystem.gray900,
                        ),
                      ),
                      Text(
                        '${_onShiftAgents.length} agents currently active',
                        style: SpiroDesignSystem.bodyS.copyWith(
                          color: SpiroDesignSystem.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SpiroDesignSystem.space2,
                    vertical: SpiroDesignSystem.space1,
                  ),
                  decoration: BoxDecoration(
                    color: SpiroDesignSystem.success50,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusFull,
                    ),
                    border: Border.all(
                      color: SpiroDesignSystem.success200,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '100%',
                    style: SpiroDesignSystem.caption.copyWith(
                      color: SpiroDesignSystem.success700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space3),
            decoration: BoxDecoration(
              color: SpiroDesignSystem.gray50,
              border: Border(
                bottom: BorderSide(color: SpiroDesignSystem.gray200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildTableHeader('ID')),
                Expanded(flex: 3, child: _buildTableHeader('Name')),
                Expanded(flex: 3, child: _buildTableHeader('Station')),
                Expanded(flex: 2, child: _buildTableHeader('Status')),
                Expanded(flex: 2, child: _buildTableHeader('Shift')),
              ],
            ),
          ),
          Expanded(
            child: _onShiftAgents.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: SpiroDesignSystem.primaryBlue600,
                    ),
                  )
                : ListView.builder(
                    itemCount: _onShiftAgents.length,
                    itemBuilder: (context, index) {
                      final agent = _onShiftAgents[index];
                      return _buildAgentRow(
                        agent.id,
                        agent.name,
                        agent.station,
                        agent.status,
                        agent.shift,
                      );
                    },
                  ),
          ),
        ],
      ),
    ).slideIn();
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: SpiroDesignSystem.bodyS.copyWith(
        fontWeight: FontWeight.w600,
        color: SpiroDesignSystem.gray700,
      ),
    );
  }

  Widget _buildAgentRow(
    String id,
    String name,
    String station,
    String status,
    String shift,
  ) {
    Color statusColor = SpiroDesignSystem.getStatusColor(status);
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space3),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: SpiroDesignSystem.gray100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              id,
              style: SpiroDesignSystem.monoS.copyWith(
                color: SpiroDesignSystem.gray800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: SpiroDesignSystem.bodyS.copyWith(
                color: SpiroDesignSystem.gray800,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              station,
              style: SpiroDesignSystem.bodyS.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.3),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space1_5),
                Flexible(
                  child: Text(
                    status,
                    style: SpiroDesignSystem.bodyS.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              shift,
              style: SpiroDesignSystem.bodyS.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlerts() {
    return Container(
      width: double.infinity,
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SpiroDesignSystem.danger50,
                  SpiroDesignSystem.danger100.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(SpiroDesignSystem.radiusLg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(SpiroDesignSystem.space2),
                  decoration: BoxDecoration(
                    gradient: SpiroDesignSystem.dangerGradient,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                  ),
                  child: Icon(
                    Icons.warning_amber,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Alerts',
                        style: SpiroDesignSystem.titleM.copyWith(
                          fontWeight: FontWeight.w600,
                          color: SpiroDesignSystem.gray900,
                        ),
                      ),
                      Text(
                        '${_activeAlerts.length} critical alerts require attention',
                        style: SpiroDesignSystem.bodyS.copyWith(
                          color: SpiroDesignSystem.danger600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(SpiroDesignSystem.space1_5),
                  decoration: BoxDecoration(
                    color: SpiroDesignSystem.danger500,
                    shape: BoxShape.circle,
                    boxShadow: SpiroDesignSystem.shadowCritical,
                  ),
                  child: Text(
                    '${_activeAlerts.length}',
                    style: SpiroDesignSystem.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(SpiroDesignSystem.space4),
            child: _activeAlerts.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: SpiroDesignSystem.primaryBlue600,
                    ),
                  )
                : Column(
                    children: _activeAlerts.map((alert) {
                      Color alertColor = alert.type == 'critical'
                          ? SpiroDesignSystem.danger500
                          : alert.type == 'warning'
                          ? SpiroDesignSystem.warning500
                          : SpiroDesignSystem.info500;
                      IconData alertIcon = alert.type == 'critical'
                          ? Icons.electric_bolt
                          : alert.type == 'warning'
                          ? Icons.wifi_off
                          : Icons.info;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: SpiroDesignSystem.space3,
                        ),
                        child: _buildAlertItem(
                          alert.title,
                          alert.description,
                          alert.location,
                          alert.time,
                          alertColor,
                          alertIcon,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    ).slideIn();
  }

  Widget _buildAlertItem(
    String title,
    String description,
    String location,
    String time,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.05), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space1_5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusSm,
                  ),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              SizedBox(width: SpiroDesignSystem.space2),
              Expanded(
                child: Text(
                  title,
                  style: SpiroDesignSystem.bodyL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space2),
          Text(
            description,
            style: SpiroDesignSystem.bodyS.copyWith(
              color: SpiroDesignSystem.gray700,
              height: 1.4,
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space2),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 12,
                color: SpiroDesignSystem.gray500,
              ),
              SizedBox(width: SpiroDesignSystem.space1),
              Expanded(
                child: Text(
                  location,
                  style: SpiroDesignSystem.caption.copyWith(
                    color: SpiroDesignSystem.gray600,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 12,
                color: SpiroDesignSystem.gray500,
              ),
              SizedBox(width: SpiroDesignSystem.space1),
              Text(
                time,
                style: SpiroDesignSystem.caption.copyWith(
                  color: SpiroDesignSystem.gray600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
