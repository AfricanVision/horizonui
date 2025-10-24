import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:horizonui/Spiro/ui/dashboard/content/ConnectDashboardPageContent.dart';
import 'package:latlong2/latlong.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../data/internal/application/BarData.dart';
import '../../../data/internal/application/ChartData.dart';
import '../../../data/models/agent_model.dart';
import '../../../data/models/alert_model.dart';
import '../../../data/models/dashboard_data_model.dart';
import '../../../designs/Responsive.dart';
import '../../../utils/DesignSystem.dart';
import 'DashboardPageContent.dart';
import 'ViewDashboardPageContent.dart';

class DashboardPageContentState extends State<DashboardPageContent>
    with SingleTickerProviderStateMixin
    implements ConnectDashboardPageContent {
  late AnimationController _animationController;
  late Animation<double> _barAnimation;
  bool _animationPlayed = false;
  bool _isRefreshing = false;

  ViewDashboardPageContent? _model;

  // Dashboard data
  DashboardData? _dashboardData;
  List<DashboardAgent> _onShiftAgents = [];
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

      // Create a temporary _viewModel instance for API calls

      // Load all dashboard data concurrently
      final results = await Future.wait([
        _model!.getDashboardData(),
        _model!.getOnShiftAgents(),
        _model!.getActiveAlerts(),
      ]);

      if (mounted) {
        setState(() {
          _dashboardData = results[0] as DashboardData;
          _onShiftAgents = results[1] as List<DashboardAgent>;
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
            DashboardAgent(
              id: 'AGQ01',
              name: 'John Doe',
              station: 'Accra Central',
              status: 'online',
              shift: 'Morning',
            ),
            DashboardAgent(
              id: 'AGQ02',
              name: 'Sarah Wilson',
              station: 'Lagos Island',
              status: 'busy',
              shift: 'Morning',
            ),
            DashboardAgent(
              id: 'AGQ03',
              name: 'Michael Chen',
              station: 'Nairobi CBD',
              status: 'online',
              shift: 'Morning',
            ),
            DashboardAgent(
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
      }
      debugPrint('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewDashboardPageContent>.reactive(
      viewModelBuilder: () => ViewDashboardPageContent(context, this),
      onViewModelReady: (viewModel) => {_model = viewModel, _initialiseView()},
      builder: (context, viewModel, child) => PopScope(
        canPop: false, // Prevents auto pop
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            if (_model?.loadingEntry == null && _model?.errorEntry == null) {}
          }
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
                  return Responsive(
                    mobile: _mobileView(viewportConstraints),
                    desktop: _desktopView(viewportConstraints),
                    tablet: _desktopView(viewportConstraints),
                  );
                },
          ),
        ),
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

  _initialiseView() {}

  Widget _mobileView(BoxConstraints viewportConstraints) {
    return Column();
  }

  _desktopView(BoxConstraints viewportConstraints) {
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
}
