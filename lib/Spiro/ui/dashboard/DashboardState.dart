import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/ui/dashboard/ConnectDashBoard.dart';
import 'package:stacked/stacked.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../designs/Responsive.dart';
import '../../utils/Colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../data/internal/application/Agents.dart';


import '../agents/agents_page.dart';
import '../stations/stations_page.dart';
import '../batteries/batteries_page.dart';
import '../analytics/analytics_page.dart';
import '../incidents/incidents_page.dart';
import '../reports/reports_page.dart';
import 'Dashboard.dart';
import 'ViewDashboard.dart';

class DashboardState extends State<Dashboard> implements ConnectDashBoard{
  String _selectedMenuItem = 'Dashboard';
  Widget _currentPage = DashboardPageContent(model: null, agents: [],);
  bool _isSidebarOpen = true;

  ViewDashboard? _model;
  List<Agent> _agents = [];



  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewDashboard>.reactive(
      viewModelBuilder: () => ViewDashboard(context, this),
      onViewModelReady: (viewModel) => {
        _model = viewModel,
        _initialiseView()
      },
      builder: (context, viewModel, child) => PopScope(canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              if (viewModel.loadingEntry == null && viewModel.errorEntry == null) {
                _closeApp();
              }
            }
          },child: Scaffold(
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                  return Responsive(
                    mobile: _mobileView(viewportConstraints),
                    desktop: _desktopView(viewportConstraints),
                    tablet: _desktopView(viewportConstraints),
                  );
                }),)),);
  }

  _initialiseView() async {
    _model?.getAgents();
  }

  _mobileView(BoxConstraints viewportConstraints){
    return DashboardPageContent(model: _model, agents: _agents);
  }

  _desktopView(BoxConstraints viewportConstraints){
    return Row(
      children: [
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
                    ]),
                    Divider(height: 32),
                    _buildMenuSection('SYSTEM', [
                      _buildMenuItem('Settings', Icons.settings),
                    ]),
                  ],
                ),
              ),

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

        Expanded(
          child: Stack(
            children: [
              _currentPage,

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
    );
  }

  void _navigateToPage(String pageName) {
    print('Navigating to: $pageName');

    setState(() {
      _selectedMenuItem = pageName;
      switch (pageName) {
        case 'Dashboard':
          _currentPage = DashboardPageContent(model: _model, agents: _agents,);
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
        default:
          _currentPage = DashboardPageContent(model: _model, agents: _agents,);
      }
    });
  }




  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
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
  }

  void _closeApp() {

  }

  @override
  void setAgents(List<Agent> response) {
    print('Agents received in DashboardState: ${response.length}');

    setState(() {
      _agents = response;
    });

    for (var agent in response) {
      print('Agent: ${agent.firstname} ${agent.lastname} - ${agent.email} - ${agent.statusId}');
    }
  }}

class DashboardPageContent extends StatefulWidget {
  final ViewDashboard? model;
  final List<Agent> agents;

  const DashboardPageContent({super.key, required this.model, required this.agents});

  @override
  State<DashboardPageContent> createState() => _DashboardPageContentState();
}

class _DashboardPageContentState extends State<DashboardPageContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _barAnimation;
  bool _animationPlayed = false;

  ViewDashboard? get _model => widget.model;

  // FIXED: Use widget.agents instead of _model?.agents to get the actual data passed from parent
  List<Agent> get _agents => widget.agents;

  bool get _isLoading => _model?.isLoading ?? false;
  String get _errorMessage => _model?.errorMessage ?? '';

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

    // FIXED: Use widget.agents directly for initial check
    if (widget.agents.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_animationPlayed) {
          _animationController.forward();
          _animationPlayed = true;
        }
      });
    }
  }

  @override
  void didUpdateWidget(DashboardPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // FIXED: Compare widget.agents directly for updates
    if (widget.agents != oldWidget.agents && widget.agents.isNotEmpty) {
      _animationController.reset();
      _animationController.forward();
    }
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
                  icon: _isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Icon(Icons.refresh, color: Colors.white),
                  onPressed: _isLoading ? null : () => _refreshData(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          if (_errorMessage.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: textWithColor(_errorMessage, 14, TextType.Regular, Colors.red),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.red),
                    onPressed: () => _model?.getAgents(),
                  ),
                ],
              ),
            ),

          if (_errorMessage.isNotEmpty) SizedBox(height: 16),

          if (_isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    text('Loading dashboard data...', 16, TextType.Regular),
                  ],
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildStatsGrid(),
                SizedBox(height: 24),

                _buildAfricaMapSection(),
                SizedBox(height: 24),

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
        ],
      ),
    );
  }

  void _refreshData() {
    print('Refreshing data...');
    _animationController.reset();
    _animationController.forward();
    _model?.getAgents();
  }

  Widget _buildStatsGrid() {
    // DEBUG: Print agent data to verify it's reaching the stats grid
    print('Building stats grid with ${_agents.length} agents');
    if (_agents.isNotEmpty) {
      print('Sample agents: ${_agents.take(2).map((a) => '${a.firstname} ${a.lastname}').toList()}');
    }

    int totalAgents = _agents.length;
    int activeAgents = _agents.where((agent) => agent.statusId?.toLowerCase().contains('active') == true).length;
    int agentsWithEmail = _agents.where((agent) => agent.email != null && agent.email!.isNotEmpty).length;
    double activePercentage = totalAgents > 0 ? (activeAgents / totalAgents * 100) : 0;

    // DEBUG: Print calculated stats
    print('Stats - Total: $totalAgents, Active: $activeAgents, With Email: $agentsWithEmail');

    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Agents', '$totalAgents', '$activeAgents active • ${activePercentage.toStringAsFixed(1)}% active', '+${(activePercentage - 50).abs().toStringAsFixed(1)}%', activePercentage > 50),
        _buildStatCard('Active Agents', '$activeAgents', '${totalAgents - activeAgents} inactive • ${activePercentage.toStringAsFixed(1)}% rate', '+${activePercentage.toStringAsFixed(1)}%', true),
        _buildStatCard('Agents with Email', '$agentsWithEmail', '${totalAgents - agentsWithEmail} missing email', '${((agentsWithEmail / totalAgents) * 100).toStringAsFixed(1)}%', agentsWithEmail == totalAgents),
        _buildStatCard('Data Quality', '${((agentsWithEmail / totalAgents) * 100).toStringAsFixed(1)}%', 'Complete profiles ratio', null, agentsWithEmail == totalAgents),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text('Total Agents: ${_agents.length}', 16, TextType.Bold),
                  SizedBox(height: 8),
                  text('Active Agents: ${_agents.where((agent) => agent.statusId?.toLowerCase().contains('active') == true).length}', 14, TextType.Regular),
                  SizedBox(height: 16),
                  text('Africa Map Visualization', 14, TextType.Regular),
                ],
              ),
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

    List<ChartData> downtimeData = _generateDowntimeData();
    List<ChartData> powerData = _generatePowerConsumptionData();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildDowntimeChart(downtimeData)),
        SizedBox(width: 16),
        Expanded(child: _buildPowerConsumptionChart(powerData)),
      ],
    );
  }

  List<ChartData> _generateDowntimeData() {

    if (_agents.isEmpty) {
      return [
        ChartData('No Data', 0, Colors.grey),
      ];
    }

    int total = _agents.length;
    int active = _agents.where((agent) => agent.statusId?.toLowerCase().contains('active') == true).length;
    int inactive = total - active;

    return [
      ChartData('Active', (active / total * 100), Colors.green),
      ChartData('Inactive', (inactive / total * 100), Colors.orange),
    ];
  }

  List<ChartData> _generatePowerConsumptionData() {

    int basePower = _agents.length * 100;
    return [
      ChartData('Mon', (basePower * 0.8).toDouble(), Colors.blue),
      ChartData('Tue', (basePower * 0.65).toDouble(), Colors.blue),
      ChartData('Wed', (basePower * 0.72).toDouble(), Colors.blue),
      ChartData('Thu', (basePower * 0.58).toDouble(), Colors.blue),
      ChartData('Fri', (basePower * 0.69).toDouble(), Colors.blue),
      ChartData('Sat', (basePower * 0.75).toDouble(), Colors.blue),
      ChartData('Sun', (basePower * 0.82).toDouble(), Colors.blue),
    ];
  }

  Widget _buildDowntimeChart(List<ChartData> data) {
    return _buildChartContainer(
      'Agent Status Distribution',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Percentage')),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: data,
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

  Widget _buildPowerConsumptionChart(List<ChartData> data) {
    return _buildChartContainer(
      'Weekly Activity Trend',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Day')),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Activity Level')),
          series: <CartesianSeries>[
            LineSeries<ChartData, String>(
              dataSource: data,
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

  Widget _buildAgentsSection() {
    // DEBUG: Print agent data for recent agents section
    print('Building agents section with ${_agents.length} total agents');

    List<Agent> displayAgents = _agents.take(4).toList();
    print('Displaying ${displayAgents.length} agents in recent agents section');

    return Container(
      width: double.maxFinite,
      height: 300,
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
            child: text('Recent Agents', 16, TextType.Bold),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: text('Name', 12, TextType.Bold)),
                Expanded(flex: 3, child: text('Email', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Status', 12, TextType.Bold)),
              ],
            ),
          ),
          Expanded(
            child: displayAgents.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  text('No agents found', 14, TextType.Regular),
                ],
              ),
            )
                : ListView(
              children: displayAgents.map((agent) => _buildAgentRow(agent)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentRow(Agent agent) {
    Color statusColor = _getStatusColor(agent.statusId ?? 'inactive');
    String agentName = '${agent.firstname ?? ''} ${agent.lastname ?? ''}'.trim();
    if (agentName.isEmpty) agentName = 'Unknown Agent';

    String agentEmail = agent.email ?? 'No email';
    String agentStatus = agent.statusId ?? 'inactive';

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(flex: 3, child: text(agentName, 12, TextType.Regular)),
          Expanded(flex: 3, child: text(agentEmail, 12, TextType.Regular)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                SizedBox(width: 4),
                text(agentStatus, 12, TextType.Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlerts() {
    int agentCount = _agents.length;
    bool hasLowAgents = agentCount < 5;
    bool hasDataIssues = _agents.any((agent) => agent.email == null || agent.email!.isEmpty);

    List<Map<String, dynamic>> alerts = [];

    if (hasLowAgents) {
      alerts.add({
        'title': 'Low Agent Count',
        'description': 'Only $agentCount agents in system. Consider adding more agents.',
        'location': 'System • Recruitment',
        'time': 'Today',
        'color': Colors.orange
      });
    }

    if (hasDataIssues) {
      int incompleteCount = _agents.where((agent) => agent.email == null || agent.email!.isEmpty).length;
      alerts.add({
        'title': 'Data Quality Issues',
        'description': '$incompleteCount agents missing contact information',
        'location': 'Data • Validation',
        'time': 'Today',
        'color': Colors.red
      });
    }

    if (alerts.isEmpty) {
      alerts.add({
        'title': 'System Normal',
        'description': 'All systems operating within normal parameters',
        'location': 'System • Status',
        'time': 'Today',
        'color': Colors.green
      });
    }

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
          Padding(padding: EdgeInsets.all(16), child: text('System Alerts', 16, TextType.Bold)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: textWithColor(
                '${alerts.length} ${alerts.length == 1 ? 'alert' : 'alerts'} found',
                12,
                TextType.SemiBold,
                alerts.any((alert) => alert['color'] == Colors.red) ? Colors.red :
                alerts.any((alert) => alert['color'] == Colors.orange) ? Colors.orange : Colors.green
            ),
          ),
          SizedBox(height: 16),
          ...alerts.map((alert) => Column(
            children: [
              _buildAlertItem(alert['title'], alert['description'], alert['location'], alert['time'], alert['color']),
              if (alert != alerts.last) SizedBox(height: 12),
            ],
          )),
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
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
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