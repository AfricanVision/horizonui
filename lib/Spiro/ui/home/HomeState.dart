import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/internal/application/BatteryRequest.dart';
import '../../data/internal/application/NotificationType.dart';
import '../../data/internal/application/TextType.dart';
import '../../data/internal/application/UserRegistration.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import '../../utils/Validators.dart';
import 'ConnectHome.dart';
import 'Home.dart';
import 'ViewHome.dart';

class HomeState extends State<Home> implements ConnectHome {
  ViewHome? _model;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _currentEditingAgent = '';
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editAgentIdController = TextEditingController();
  final TextEditingController _editPhoneController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();
  final TextEditingController _editStationController = TextEditingController();
  final TextEditingController _editAddressController = TextEditingController();

  final TextEditingController _oemController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _batteryTypeIdController =
      TextEditingController();

  String _selectedAgentForm = '';
  final TextEditingController _incidentTitleController =
      TextEditingController();
  final TextEditingController _incidentDescriptionController =
      TextEditingController();
  final TextEditingController _incidentLocationController =
      TextEditingController();
  final TextEditingController _batterySerialController =
      TextEditingController();
  final TextEditingController _batteryStatusController =
      TextEditingController();
  final TextEditingController _powerEventController = TextEditingController();
  final TextEditingController _shiftNotesController = TextEditingController();
  final TextEditingController _customerSearchController =
      TextEditingController();

  bool _isLoading = false;
  bool _showAddForm = true;
  bool _showAgentForm = false;
  bool _showBatteryForm = false;
  bool _showDashboard = true;
  bool _showDataEntryView = false;
  String _selectedMenuItem = 'Dashboard';
  bool _showAgentFormsSection = true;
  bool _showAdminForm = false;
  bool _showEditForm = false;
  bool _showReportsView = false;
  bool _showIncidentsView = false;
  bool _showStationsView = false;
  bool _showBatteriesView = false;
  bool _showAnalyticsView = false;

  String _selectedAdminForm = '';

  // Global Admin Country Selector
  String?
  _selectedCountry; // null = "All Countries", or "Kenya", "Rwanda", "Uganda"
  String _currentUserRole = 'global'; // 'global', 'local', 'agent'
  String _currentUserCountry = 'Kenya'; // Default country for local admin/agent

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewHome>.reactive(
      viewModelBuilder: () => ViewHome(context, this),
      onViewModelReady: (viewModel) => {_model = viewModel, _initialiseView()},
      builder: (context, viewModel, child) => WillPopScope(
        child: _mainBody(),
        onWillPop: () async {
          if (_model?.loadingEntry == null && _model?.errorEntry == null) {
            _closeApp();
          }
          return false;
        },
      ),
    );
  }

  _initialiseView() async {}

  Widget _mainBody() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _showDashboard
          ? AppBar(
              backgroundColor: colorPrimaryDark,
              title: text("Spiro App", 18, TextType.Bold),
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.add, color: colorMilkWhite),
                  onSelected: (value) {
                    setState(() {
                      _showAgentForm = value == 'agent';
                      _showBatteryForm = value == 'battery';
                      _showDashboard = false;
                      _showDataEntryView = false;
                    });
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'agent',
                      child: Row(
                        children: [
                          Icon(Icons.person_add, color: colorPrimary),
                          SizedBox(width: 8),
                          Text('Add Agent'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'battery',
                      child: Row(
                        children: [
                          Icon(Icons.battery_std, color: colorPrimary),
                          SizedBox(width: 8),
                          Text('Add Battery'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : null,
      drawer: _showDashboard ? _buildSidebar() : null,
      body: _getCurrentView(),
    );
  }

  Widget _getCurrentView() {
    if (_showDataEntryView) return _buildDataEntryView();
    if (_showAgentForm) return _buildAgentManagementForm();
    if (_showBatteryForm) return _buildBatteryManagementForm();
    if (_showReportsView) return _buildReportsView();
    if (_showIncidentsView) return _buildIncidentsView();
    if (_showStationsView) return _buildStationsView();
    if (_showBatteriesView) return _buildBatteriesView();
    if (_showAnalyticsView) return _buildAnalyticsView();
    if (_showDashboard) return _buildDashboard();
    return _buildHomeContent();
  }

  Widget _buildStationsView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildStationsSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStationsHeader(),
                  SizedBox(height: 32),
                  _buildStationsTable(),
                  SizedBox(height: 24),
                  _buildStationsPagination(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationsSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: colorPrimaryDark,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                SizedBox(height: 4),
                textWithColor(
                  'Control Tower',
                  14,
                  TextType.Regular,
                  colorMilkWhite,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuSection('STATIONS', [
                  _buildStationsMenuItem('All Stations', Icons.ev_station),
                  _buildStationsMenuItem('Station Status', Icons.assessment),
                  _buildStationsMenuItem('Maintenance', Icons.build),
                  _buildStationsMenuItem('Performance', Icons.analytics),
                ]),
                Divider(height: 32),
                _buildMenuSection('ACTIONS', [
                  _buildStationsMenuItem('Add Station', Icons.add),
                  _buildStationsMenuItem('Station Reports', Icons.download),
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
                  backgroundColor: colorPrimary,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                  radius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text('Shawn Matunda', 14, TextType.Bold),
                      textWithColor(
                        'Global Admin',
                        12,
                        TextType.Regular,
                        Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationsMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 20),
      title: text(title, 14, TextType.Regular),
      onTap: () {
        print('Selected: $title');
      },
    );
  }

  Widget _buildStationsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {
              setState(() {
                _showStationsView = false;
                _showDashboard = true;
              });
            }),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text('Station Operations', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text(
                    'Active station issues and management',
                    16,
                    TextType.Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(height: 1, color: Colors.grey[300]),
        SizedBox(height: 16),
        text('Active Issues', 20, TextType.Bold),
      ],
    );
  }

  Widget _buildStationsTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: text('ID', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Station', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Issue Type', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Status', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Priority', 12, TextType.Bold)),
                Expanded(
                  flex: 2,
                  child: text('Assigned Owner', 12, TextType.Bold),
                ),
                Expanded(flex: 2, child: text('Time', 12, TextType.Bold)),
              ],
            ),
          ),
          _buildStationTableRow(
            id: '1550801',
            station: 'Accra Central',
            issueType: 'Battery Mismatch',
            status: 'open',
            priority: 'Open',
            owner: 'John Oke',
            time: '10:45 AM',
          ),
          _buildStationTableRow(
            id: '1550802',
            station: 'Lagos Island',
            issueType: 'Network Drop',
            status: 'check',
            priority: 'Check',
            owner: 'Sarah Wilson',
            time: '10:30 AM',
          ),
          _buildStationTableRow(
            id: '1550803',
            station: 'Nairobi CBD',
            issueType: 'Low Stock',
            status: 'retained',
            priority: 'Medium',
            owner: 'Michael Chen',
            time: '10:28 AM',
          ),
          _buildStationTableRow(
            id: '1550804',
            station: 'Kumasi Hub',
            issueType: 'Door Jam',
            status: 'open',
            priority: 'Clean',
            owner: 'Emma Johnson',
            time: '10:25 AM',
          ),
          _buildStationTableRow(
            id: '1550805',
            station: 'Abuja Central',
            issueType: 'Power Failure',
            status: 'retained',
            priority: 'Check',
            owner: 'David Brown',
            time: '10:20 AM',
          ),
          _buildStationTableRow(
            id: '1550806',
            station: 'Mombasa Port',
            issueType: 'Sensor Error',
            status: 'retained',
            priority: 'Medium',
            owner: 'Lisa Zhang',
            time: '10:15 AM',
          ),
        ],
      ),
    );
  }

  Widget _buildStationTableRow({
    required String id,
    required String station,
    required String issueType,
    required String status,
    required String priority,
    required String owner,
    required String time,
  }) {
    Color statusColor = _getStationStatusColor(status);
    Color priorityColor = _getPriorityColor(priority);
    String statusIcon = _getStationStatusIcon(status);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: text(id, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(station, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(issueType, 12, TextType.Regular)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                text(statusIcon, 12, TextType.Regular),
                SizedBox(width: 4),
                textWithColor(status, 12, TextType.Regular, statusColor),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: textWithColor(priority, 12, TextType.Regular, priorityColor),
          ),
          Expanded(flex: 2, child: text(owner, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(time, 12, TextType.Regular)),
        ],
      ),
    );
  }

  String _getStationStatusIcon(String status) {
    switch (status) {
      case 'open':
        return '✔';
      case 'check':
        return '○';
      case 'retained':
        return '✔';
      default:
        return '✔';
    }
  }

  Color _getStationStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.blue;
      case 'check':
        return Colors.orange;
      case 'retained':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStationsPagination() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text('Showing 6 of 6 operations', 12, TextType.Regular),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: textWithColor(
                  'Previous',
                  12,
                  TextType.Regular,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: textWithColor('Next', 12, TextType.Regular, Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteriesView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildBatteriesSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBatteriesHeader(),
                  SizedBox(height: 32),
                  _buildBatteryStatsGrid(),
                  SizedBox(height: 32),
                  _buildBatteryChartsRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteriesSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: colorPrimaryDark,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                SizedBox(height: 4),
                textWithColor(
                  'Control Tower',
                  14,
                  TextType.Regular,
                  colorMilkWhite,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuSection('BATTERIES', [
                  _buildBatteriesMenuItem('Battery Health', Icons.battery_std),
                  _buildBatteriesMenuItem('Cycle Analysis', Icons.analytics),
                  _buildBatteriesMenuItem('Replacement', Icons.autorenew),
                  _buildBatteriesMenuItem('Inventory', Icons.inventory),
                ]),
                Divider(height: 32),
                _buildMenuSection('REPORTS', [
                  _buildBatteriesMenuItem('Battery Reports', Icons.assessment),
                  _buildBatteriesMenuItem('Export Data', Icons.download),
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
                  backgroundColor: colorPrimary,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                  radius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text('Shawn Matunda', 14, TextType.Bold),
                      textWithColor(
                        'Global Admin',
                        12,
                        TextType.Regular,
                        Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteriesMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 20),
      title: text(title, 14, TextType.Regular),
      onTap: () {
        print('Selected: $title');
      },
    );
  }

  Widget _buildBatteriesHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {
              setState(() {
                _showBatteriesView = false;
                _showDashboard = true;
              });
            }),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text('Battery Analytics', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text(
                    'Battery performance and health metrics',
                    16,
                    TextType.Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBatteryStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildBatteryStatCard(
          'Text Extends',
          '15,420',
          'In circulation',
          '+2.1%',
          true,
        ),
        _buildBatteryStatCard(
          'Avg Cycle Count',
          '1,247',
          'Per battery',
          '+3.5%',
          true,
        ),
        _buildBatteryStatCard(
          'Battery Health',
          '89%',
          'Overall condition',
          '+1.2%',
          true,
        ),
        _buildBatteryStatCard(
          'Replacement Rate',
          '2.1%',
          'Monthly',
          '-0.9%',
          false,
        ),
      ],
    );
  }

  Widget _buildBatteryStatCard(
    String title,
    String mainValue,
    String subtitle,
    String trend,
    bool trendPositive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
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
              SizedBox(height: 4),
              textWithColor(
                trend,
                12,
                TextType.SemiBold,
                trendPositive ? Colors.green : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSwapsTrendChart()),
        SizedBox(width: 16),
        Expanded(child: _buildBatteryCyclesChart()),
      ],
    );
  }

  Widget _buildSwapsTrendChart() {
    return _buildChartContainer(
      'Swaps Trend',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Days')),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Swaps')),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: [
                ChartData('Mon', 800, Colors.blue),
                ChartData('Tue', 600, Colors.orange),
                ChartData('Wed', 400, Colors.green),
                ChartData('Thu', 550, Colors.purple),
                ChartData('Fri', 300, Colors.red),
                ChartData('Sat', 200, Colors.amber),
                ChartData('Sun', 450, Colors.cyan),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildAnalyticsSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnalyticsHeader(),
                  SizedBox(height: 32),
                  _buildAnalyticsChartsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: colorPrimaryDark,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                SizedBox(height: 4),
                textWithColor(
                  'Control Tower',
                  14,
                  TextType.Regular,
                  colorMilkWhite,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuSection('ANALYTICS', [
                  _buildAnalyticsMenuItem('Performance', Icons.analytics),
                  _buildAnalyticsMenuItem('Swaps Trend', Icons.trending_up),
                  _buildAnalyticsMenuItem('Battery Health', Icons.battery_std),
                  _buildAnalyticsMenuItem('Station Metrics', Icons.assessment),
                ]),
                Divider(height: 32),
                _buildMenuSection('EXPORT', [
                  _buildAnalyticsMenuItem('Export Reports', Icons.download),
                  _buildAnalyticsMenuItem('Custom Analytics', Icons.settings),
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
                  backgroundColor: colorPrimary,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                  radius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text('Shawn Matunda', 14, TextType.Bold),
                      textWithColor(
                        'Global Admin',
                        12,
                        TextType.Regular,
                        Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 20),
      title: text(title, 14, TextType.Regular),
      onTap: () {
        print('Selected: $title');
      },
    );
  }

  Widget _buildAnalyticsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {
              setState(() {
                _showAnalyticsView = false;
                _showDashboard = true;
              });
            }),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text('Analytics', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text(
                    'Performance insights and metrics',
                    16,
                    TextType.Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsChartsGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildSwapsTrendChart()),
            SizedBox(width: 16),
            Expanded(child: _buildBatteryCyclesChart()),
          ],
        ),
        SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDowntimeChart()),
            SizedBox(width: 16),
            Expanded(child: _buildPowerConsumptionChart()),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildReportsSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportsHeader(),
                  SizedBox(height: 32),
                  _buildAgentsTable(),
                  SizedBox(height: 24),
                  _buildAgentsPagination(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentsTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: text('ID', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Name', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Station', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Status', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Shift', 12, TextType.Bold)),
                Expanded(
                  flex: 2,
                  child: text('Swaps Progress', 12, TextType.Bold),
                ),
                Expanded(
                  flex: 2,
                  child: text('Last Activity', 12, TextType.Bold),
                ),
              ],
            ),
          ),
          _buildAgentTableRow(
            id: 'A6081',
            name: 'John Doe',
            station: 'Accra Central',
            status: 'online',
            shift: 'Morning',
            swapsProgress: '23/30',
            lastActivity: '2 min ago',
          ),
          _buildAgentTableRow(
            id: 'A6082',
            name: 'Sarah Wilson',
            station: 'Lagos Island',
            status: 'busy',
            shift: 'Morning',
            swapsProgress: '31/35',
            lastActivity: 'Active now',
          ),
          _buildAgentTableRow(
            id: 'A6083',
            name: 'Michael Chen',
            station: 'Nairobi CBD',
            status: 'online',
            shift: 'Morning',
            swapsProgress: '18/25',
            lastActivity: '5 min ago',
          ),
          _buildAgentTableRow(
            id: 'A6084',
            name: 'Emma Johnson',
            station: 'Kumasi Hub',
            status: 'break',
            shift: 'Morning',
            swapsProgress: '15/28',
            lastActivity: '12 min ago',
          ),
          _buildAgentTableRow(
            id: 'A6085',
            name: 'David Brown',
            station: 'Abuja Central',
            status: 'busy',
            shift: 'Afternoon',
            swapsProgress: '27/32',
            lastActivity: 'Active now',
          ),
          _buildAgentTableRow(
            id: 'A6086',
            name: 'Lisa Zhang',
            station: 'Mombasa Port',
            status: 'online',
            shift: 'Afternoon',
            swapsProgress: '21/26',
            lastActivity: '1 min ago',
          ),
          _buildAgentTableRow(
            id: 'A6087',
            name: 'James Miller',
            station: 'Tamale Station',
            status: 'offline',
            shift: 'Morning',
            swapsProgress: '0/20',
            lastActivity: '45 min ago',
          ),
          _buildAgentTableRow(
            id: 'A6088',
            name: 'Anna Davis',
            station: 'Cape Coast',
            status: 'online',
            shift: 'Evening',
            swapsProgress: '19/24',
            lastActivity: '3 min ago',
          ),
        ],
      ),
    );
  }

  Widget _buildAgentTableRow({
    required String id,
    required String name,
    required String station,
    required String status,
    required String shift,
    required String swapsProgress,
    required String lastActivity,
  }) {
    Color statusColor = _getStatusColor(status);
    String statusIcon = _getAgentStatusIcon(status);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: text(id, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(name, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(station, 12, TextType.Regular)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                text(statusIcon, 12, TextType.Regular),
                SizedBox(width: 4),
                textWithColor(status, 12, TextType.Regular, statusColor),
              ],
            ),
          ),
          Expanded(flex: 2, child: text(shift, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(swapsProgress, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(lastActivity, 12, TextType.Regular)),
        ],
      ),
    );
  }

  String _getAgentStatusIcon(String status) {
    switch (status) {
      case 'online':
        return '●';
      case 'busy':
        return '●';
      case 'break':
        return '○';
      case 'offline':
        return '○';
      default:
        return '○';
    }
  }

  Widget _buildAgentsPagination() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text('Showing 8 of 8 operations', 12, TextType.Regular),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: textWithColor(
                  'Previous',
                  12,
                  TextType.Regular,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: textWithColor('Next', 12, TextType.Regular, Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: colorPrimaryDark,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                  SizedBox(height: 4),
                  textWithColor(
                    'Control Tower',
                    14,
                    TextType.Regular,
                    colorMilkWhite,
                  ),
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
                    _buildMenuItem('Data Entry', Icons.data_usage),
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
                    backgroundColor: colorPrimary,
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                    radius: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text('Shawn Matunda', 14, TextType.Bold),
                        textWithColor(
                          'Global Admin',
                          12,
                          TextType.Regular,
                          Colors.grey[600]!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    bool isSelected = _selectedMenuItem == title;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorPrimary : Colors.grey[700],
        size: 20,
      ),
      title: textWithColor(
        title,
        14,
        isSelected ? TextType.Bold : TextType.Regular,
        isSelected ? colorPrimary : Colors.grey[700]!,
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedMenuItem = title;
          if (title == 'Data Entry') {
            _showDataEntryView = true;
            _showDashboard = false;
            _showAgentForm = false;
            _showBatteryForm = false;
            _showReportsView = false;
            _showIncidentsView = false;
            _showStationsView = false;
            _showBatteriesView = false;
            _showAnalyticsView = false;
          } else if (title == 'Reports') {
            _showReportsView = true;
            _showDataEntryView = false;
            _showDashboard = false;
            _showAgentForm = false;
            _showBatteryForm = false;
            _showIncidentsView = false;
            _showStationsView = false;
            _showBatteriesView = false;
            _showAnalyticsView = false;
          } else if (title == 'Incidents') {
            _showIncidentsView = true;
            _showDataEntryView = false;
            _showDashboard = false;
            _showAgentForm = false;
            _showBatteryForm = false;
            _showReportsView = false;
            _showStationsView = false;
            _showBatteriesView = false;
            _showAnalyticsView = false;
          } else if (title == 'Stations') {
            _showStationsView = true;
            _showDataEntryView = false;
            _showDashboard = false;
            _showAgentForm = false;
            _showBatteryForm = false;
            _showReportsView = false;
            _showIncidentsView = false;
            _showBatteriesView = false;
            _showAnalyticsView = false;
          } else if (title == 'Batteries') {
            _showBatteriesView = true;
            _showDataEntryView = false;
            _showDashboard = false;
            _showAgentForm = false;
            _showBatteryForm = false;
            _showReportsView = false;
            _showIncidentsView = false;
            _showStationsView = false;
            _showAnalyticsView = false;
          } else if (title == 'Analytics') {
            _showAnalyticsView = true;
            _showDataEntryView = false;
            _showDashboard = false;
            _showAgentForm = false;
            _showBatteryForm = false;
            _showReportsView = false;
            _showIncidentsView = false;
            _showStationsView = false;
            _showBatteriesView = false;
          } else if (title == 'Dashboard') {
            _showDataEntryView = false;
            _showDashboard = true;
            _showReportsView = false;
            _showIncidentsView = false;
            _showStationsView = false;
            _showBatteriesView = false;
            _showAnalyticsView = false;
          } else {
            _showDataEntryView = false;
            _showDashboard = true;
            _showReportsView = false;
            _showIncidentsView = false;
            _showStationsView = false;
            _showBatteriesView = false;
            _showAnalyticsView = false;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildReportsSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: colorPrimaryDark,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                SizedBox(height: 4),
                textWithColor(
                  'Control Tower',
                  14,
                  TextType.Regular,
                  colorMilkWhite,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuSection('REPORTS', [
                  _buildReportsMenuItem(
                    'Operational Reports',
                    Icons.assessment,
                  ),
                  _buildReportsMenuItem(
                    'Performance Analytics',
                    Icons.analytics,
                  ),
                  _buildReportsMenuItem('Incident Reports', Icons.warning),
                  _buildReportsMenuItem('Agent Performance', Icons.people),
                  _buildReportsMenuItem('Battery Reports', Icons.battery_std),
                  _buildReportsMenuItem('Station Reports', Icons.ev_station),
                ]),
                Divider(height: 32),
                _buildMenuSection('EXPORT', [
                  _buildReportsMenuItem('Export Data', Icons.download),
                  _buildReportsMenuItem('Scheduled Reports', Icons.schedule),
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
                  backgroundColor: colorPrimary,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                  radius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text('Shawn Matunda', 14, TextType.Bold),
                      textWithColor(
                        'Global Admin',
                        12,
                        TextType.Regular,
                        Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 20),
      title: text(title, 14, TextType.Regular),
      onTap: () {
        print('Selected: $title');
      },
    );
  }

  Widget _buildReportsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {
              setState(() {
                _showReportsView = false;
                _showDashboard = true;
              });
            }),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text('Agents', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text('Workforce management', 16, TextType.Regular),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(height: 1, color: Colors.grey[300]),
        SizedBox(height: 16),
        text('On-Shift Agents', 20, TextType.Bold),
      ],
    );
  }

  Widget _buildIncidentsView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildIncidentsSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIncidentsHeader(),
                  SizedBox(height: 32),
                  _buildCriticalAlertsSection(),
                  SizedBox(height: 24),
                  _buildIncidentCardsSection(),
                  SizedBox(height: 24),
                  _buildIncidentsFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {
              setState(() {
                _showIncidentsView = false;
                _showDashboard = true;
              });
            }),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text('Incidents', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text('Critical events', 16, TextType.Regular),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCriticalAlertsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange[800], size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text('Active Alerts', 16, TextType.Bold),
                SizedBox(height: 4),
                text(
                  '3 critical alerts require immediate attention',
                  14,
                  TextType.Regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentCardsSection() {
    return Column(
      children: [
        _buildIncidentCard(
          title: 'Battery Mismatch Detected',
          description: 'Incompatible battery type detected in swap station',
          location: 'Battery • Lagos Island • Nigeria',
          color: Colors.red,
          icon: Icons.battery_alert,
        ),
        SizedBox(height: 16),
        _buildIncidentCard(
          title: 'Low Battery Inventory',
          description: 'Battery count below threshold (< 5 units)',
          location: 'Battery • Accra Central • Ghana',
          color: Colors.orange,
          icon: Icons.inventory_2,
        ),
        SizedBox(height: 16),
        _buildIncidentCard(
          title: 'Agent Offline',
          description: 'Agent has been offline for over 30 minutes',
          location: 'Agent • Nairobi CBD • Kenya',
          color: Colors.blue,
          icon: Icons.person_off,
        ),
      ],
    );
  }

  Widget _buildIncidentCard({
    required String title,
    required String description,
    required String location,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(title, 16, TextType.Bold),
                SizedBox(height: 8),
                text(description, 14, TextType.Regular),
                SizedBox(height: 8),
                textWithColor(
                  location,
                  14,
                  TextType.Regular,
                  Colors.grey[600]!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentsFooter() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text('Demo Mode', 14, TextType.Bold),
              SizedBox(height: 8),
              text('1500px+ Desktop View', 12, TextType.Regular),
            ],
          ),
        ),
        SizedBox(height: 16),
        _buildTimeSection('Ask', '2 minutes ago'),
        SizedBox(height: 12),
        _buildTimeSection('Ask', '15 minutes ago'),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text('Showing 0 of 8 alerts', 12, TextType.Regular),
              ElevatedButton(
                onPressed: () {
                  print('View All Alerts clicked');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: textWithColor(
                  'View All Alerts',
                  12,
                  TextType.SemiBold,
                  Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection(String title, String time) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text(title, 14, TextType.SemiBold),
          textWithColor(time, 12, TextType.Regular, Colors.grey[600]!),
        ],
      ),
    );
  }

  Widget _buildIncidentsSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: colorPrimaryDark,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                SizedBox(height: 4),
                textWithColor(
                  'Control Tower',
                  14,
                  TextType.Regular,
                  colorMilkWhite,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuSection('INCIDENTS', [
                  _buildIncidentsMenuItem(
                    'Active Alerts',
                    Icons.warning,
                    Colors.orange,
                  ),
                  _buildIncidentsMenuItem(
                    'Battery Issues',
                    Icons.battery_alert,
                    Colors.red,
                  ),
                  _buildIncidentsMenuItem(
                    'Network Issues',
                    Icons.wifi_off,
                    Colors.blue,
                  ),
                  _buildIncidentsMenuItem(
                    'Power Events',
                    Icons.power_off,
                    Colors.amber,
                  ),
                  _buildIncidentsMenuItem(
                    'Agent Status',
                    Icons.person_off,
                    Colors.purple,
                  ),
                ]),
                Divider(height: 32),
                _buildMenuSection('ACTIONS', [
                  _buildIncidentsMenuItem(
                    'Create Incident',
                    Icons.add_alert,
                    Colors.green,
                  ),
                  _buildIncidentsMenuItem(
                    'Incident History',
                    Icons.history,
                    Colors.grey,
                  ),
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
                  backgroundColor: colorPrimary,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                  radius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text('Shawn Matunda', 14, TextType.Bold),
                      textWithColor(
                        'Global Admin',
                        12,
                        TextType.Regular,
                        Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentsMenuItem(String title, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: text(title, 14, TextType.Regular),
      onTap: () {
        print('Selected: $title');
      },
    );
  }

  Widget _buildIncidentReportForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Report an Incident', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Incident Title *',
          hintText: 'e.g., Battery Overheating',
          controller: _incidentTitleController,
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Description *',
          hintText: 'Describe the incident in detail...',
          controller: _incidentDescriptionController,
          maxLines: 3,
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Location *',
          hintText: 'e.g., Station A, Lagos',
          controller: _incidentLocationController,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton("Submit Incident Report", () {
            _submitIncidentReport();
          }),
        ),
      ],
    );
  }

  Widget _buildBatteryHistoryForm() {
    return Column(
        ],
      ),
        text('Battery History Tracking', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Battery Serial Number *',
          hintText: 'e.g., BAT-123456',
          controller: _batterySerialController,
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Current Status *',
          hintText: 'e.g., In Service, Maintenance, Retired',
          controller: _batteryStatusController,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton("Update Battery History", () {
            _updateBatteryHistory();
          }),
        ),
      ],
    );
  }

  Widget _buildPowerEventsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Power Event Log', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Event Description *',
          hintText: 'e.g., Power Outage, Voltage Spike',
          controller: _powerEventController,
          maxLines: 2,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton("Log Power Event", () {
            _logPowerEvent();
          }),
        ),
      ],
    );
  }

  Widget _buildShiftRecordsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Shift Record Entry', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Shift Notes *',
          hintText: 'Enter shift summary and notes...',
          controller: _shiftNotesController,
          maxLines: 4,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton("Save Shift Record", () {
            _saveShiftRecord();
          }),
        ),
      ],
    );
  }

  Widget _buildCustomerDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Customer Information', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Search Customer *',
          hintText: 'Enter customer name or ID',
          controller: _customerSearchController,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton("Search Customer", () {
            _searchCustomer();
          }),
        ),
      ],
    );
  }

  Widget _buildAgentFormBox(String title, String description) {
    bool isSelected = _selectedAgentForm == title;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAgentForm = title;
          });
        },
        child: Container(
          width: 280,
          height: 90,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? colorPrimaryLight : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? colorPrimary : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text(title, 16, TextType.SemiBold),
              SizedBox(height: 4),
              textWithColor(
                description,
                14,
                TextType.Regular,
                Colors.grey[600]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitIncidentReport() {
    print('Submitting incident report:');
    print('Title: ${_incidentTitleController.text}');
    print('Description: ${_incidentDescriptionController.text}');
    print('Location: ${_incidentLocationController.text}');
    _showSuccessNotification("Incident report submitted successfully!");
    _clearAgentFormFields();
  }

  void _updateBatteryHistory() {
    print('Updating battery history:');
    print('Serial: ${_batterySerialController.text}');
    print('Status: ${_batteryStatusController.text}');
    _showSuccessNotification("Battery history updated!");
    _clearAgentFormFields();
  }

  void _logPowerEvent() {
    print('Logging power event: ${_powerEventController.text}');
    _showSuccessNotification("Power event logged!");
    _clearAgentFormFields();
  }

  void _saveShiftRecord() {
    print('Saving shift record: ${_shiftNotesController.text}');
    _showSuccessNotification("Shift record saved!");
    _clearAgentFormFields();
  }

  void _searchCustomer() {
    print('Searching customer: ${_customerSearchController.text}');
    _showSuccessNotification("Customer search completed!");
    _clearAgentFormFields();
  }

  void _clearAgentFormFields() {
    _incidentTitleController.clear();
    _incidentDescriptionController.clear();
    _incidentLocationController.clear();
    _batterySerialController.clear();
    _batteryStatusController.clear();
    _powerEventController.clear();
    _shiftNotesController.clear();
    _customerSearchController.clear();
  }

  Widget _buildAddAgentForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text("Add New Agent", 16, TextType.Bold),
                  text("Fill in the agent details below", 12, TextType.Regular),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _showAddForm = false;
                    _clearAgentForm();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'First Name *',
                      hintText: 'e.g., Cynthia',
                      controller: _firstnameController,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Middle Name',
                      hintText: 'e.g., Situma',
                      controller: _middlenameController,
                      isRequired: false,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Phone Number *',
                      hintText: 'e.g., 0712345678',
                      controller: _phonenumberController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'National ID *',
                      hintText: 'e.g., ID123456',
                      controller: _identificationController,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'Last Name *',
                      hintText: 'e.g., Fake',
                      controller: _lastnameController,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Date of Birth *',
                      hintText: 'e.g., 1990-05-15',
                      controller: _dobController,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Nationality *',
                      hintText: 'e.g., Kenyan',
                      controller: _nationalityController,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Email Address *',
                      hintText: 'e.g., CFake@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAddForm = false;
                    _clearAgentForm();
                  });
                },
                child: textWithColor(
                  'Cancel',
                  14,
                  TextType.Regular,
                  Colors.grey[600]!,
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: _submitAgentForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                ),
                child: textWithColor(
                  _isLoading ? "Registering..." : "Register Agent",
                  14,
                  TextType.SemiBold,
                  Colors.white,
                ),
              ),
            ],
          ),
          if (_isLoading) ...[
            SizedBox(height: 16),
            Center(child: CircularProgressIndicator(color: colorPrimary)),
          ],
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[600]),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: InputBorder.none,
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeContent() {
    return Container(
      color: colorPrimaryLight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          roundedCornerButton(
            "Go to Dashboard",
            () => setState(() => _showDashboard = true),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentManagementForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              backButtonWithAction(context, () {
                setState(() {
                  _showAgentForm = false;
                  _showDashboard = true;
                  _clearAgentForm();
                  _showAddForm = false;
                });
              }),
              SizedBox(width: 16),
              text("Agent Management", 20, TextType.Bold),
            ],
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search agents...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAddForm = true;
                  _showEditForm = false;
                  _currentEditingAgent = '';
                  _clearAgentForm();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  textWithColor(
                    'Add Agent',
                    14,
                    TextType.SemiBold,
                    Colors.white,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          if (_showAddForm) _buildAddAgentForm(),
          if (_showEditForm) _buildEditAgentForm(),
          text("Agents (4)", 20, TextType.Bold),
          SizedBox(height: 16),
          Column(
            children: [
              _buildAgentCard(
                name: 'John Doe',
                agentId: 'AGT-001',
                status: 'Active',
                phone: '+234-801-234-5678',
                email: 'john.doe@spiro.com',
                station: 'Lagos Central Hub',
                address: '15 Ikoyi Street, Lagos Island, Lagos State',
                joined: '2024-01-15',
                updated: '2024-09-15 10:00:00',
              ),
              SizedBox(height: 16),
              _buildAgentCard(
                name: 'Sarah Kim',
                agentId: 'AGT-002',
                status: 'Active',
                phone: '+234-802-345-6789',
                email: 'sarah.kim@spiro.com',
                station: 'Ikeja Business District',
                address: '23 Allen Avenue, Ikeja, Lagos State',
                joined: '2024-02-01',
                updated: '2024-09-20 14:30:00',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataEntryView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildDataEntrySidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataEntryHeader(),
                  SizedBox(height: 32),
                  _buildDataEntryPortalCard(),
                  SizedBox(height: 32),
                  _buildAgentFormsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataEntrySidebar() {
    return Container();
  }

  Widget _buildDataEntryHeader() {
    return Container();
  }

  Widget _buildDataEntryPortalCard() {
    return Container();
  }

  Widget _buildAgentFormsSection() {
    return Container();
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: titleAndDescription(
                  'Dashboard',
                  'Control tower overview',
                ),
              ),
              IconButton(
                icon: Icon(Icons.home, color: colorPrimary),
                onPressed: () {
                  setState(() {
                    _showDashboard = true;
                    _showDataEntryView = false;
                    _showAgentForm = false;
                    _showBatteryForm = false;
                    _showReportsView = false;
                  });
                },
                tooltip: 'Return to Home',
              ),
            ],
          ),
          SizedBox(height: 24),
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

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard('Active Agents', '356', Icons.people, Colors.blue),
        _buildStatCard('Total Swaps', '7,379', Icons.swap_horiz, Colors.green),
        _buildStatCard('Power Stations', '19', Icons.ev_station, Colors.orange),
        _buildStatCard('Batteries', '1,234', Icons.battery_std, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String mainValue,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWithColor(title, 14, TextType.SemiBold, Colors.grey[700]!),
              Icon(icon, color: color, size: 28),
            ],
          ),
          text(mainValue, 24, TextType.Bold),
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
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
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
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/africa_map.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.blue[50],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 48,
                                color: Colors.blue[300],
                              ),
                              SizedBox(height: 8),
                              textWithColor(
                                'Africa Operations Map',
                                16,
                                TextType.Bold,
                                Colors.blue[600]!,
                              ),
                              SizedBox(height: 8),
                              textWithColor(
                                'Add africa_map.png to assets',
                                12,
                                TextType.Regular,
                                Colors.grey[600]!,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 80,
                  left: 150,
                  child: _buildCountryMarker(
                    'Nigeria',
                    Colors.green,
                    '4972 agents',
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 120,
                  child: _buildCountryMarker(
                    'Ghana',
                    Colors.blue,
                    '2891 agents',
                  ),
                ),
                Positioned(
                  top: 180,
                  left: 200,
                  child: _buildCountryMarker(
                    'Kenya',
                    Colors.orange,
                    '1567 agents',
                  ),
                ),
                Positioned(
                  top: 220,
                  left: 210,
                  child: _buildCountryMarker(
                    'Tanzania',
                    Colors.purple,
                    '892 agents',
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 190,
                  child: _buildCountryMarker(
                    'Uganda',
                    Colors.red,
                    '745 agents',
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 195,
                  child: _buildCountryMarker(
                    'Rwanda',
                    Colors.amber,
                    '423 agents',
                  ),
                ),

                Positioned(top: 16, left: 16, child: _buildMapInfoPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryMarker(String country, Color color, String info) {
    return GestureDetector(
      onTap: () {
        _showCountryDetails(country, info);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4),
            textWithColor(country, 10, TextType.SemiBold, Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildMapInfoPanel() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text('Africa Overview', 14, TextType.Bold),
          SizedBox(height: 8),
          text('Countries: 8', 12, TextType.Regular),
          text('Total Agents: 12,490', 12, TextType.Regular),
          text('Total Swaps: 92,231', 12, TextType.Regular),
          SizedBox(height: 8),
          text('Status', 12, TextType.Regular),
          Row(
            children: [
              _buildStatusIndicator(Colors.green, 'Active'),
              SizedBox(width: 12),
              _buildStatusIndicator(Colors.orange, 'Warning'),
              SizedBox(width: 12),
              _buildStatusIndicator(Colors.blue, 'Maintenance'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, color: color),
        SizedBox(width: 4),
        text(label, 10, TextType.Regular),
      ],
    );
  }

  void _showCountryDetails(String country, String info) {
    print('Selected: $country - $info');

    // Example: Show a snackbar with country info
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: text('$country: $info', 14, TextType.Regular),
        duration: Duration(seconds: 2),
      ),
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
            ),
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
            ),
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
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [text(title, 16, TextType.Bold), SizedBox(height: 16), chart],
      ),
    );
  }

  Widget _buildChartBar(double height, Color color, String label) {
    return Column(
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }

  Widget _buildLineChartPoint(double height) {
    return Column(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        ),
        Container(width: 2, height: height / 4, color: Colors.blue),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 4),
        textWithColor(text, 12, TextType.Regular, colorPrimaryDark),
      ],
    );
  }

  Widget _buildSwapsTrendSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text('Swaps Trend', 16, TextType.Bold),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _buildDailySwapsChart()),
              SizedBox(width: 16),
              Expanded(child: _buildBatteryCyclesChart()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailySwapsChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Daily Swaps', 14, TextType.SemiBold),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBar(800, Colors.blue, 'Mon'),
              _buildBar(600, Colors.orange, 'Tue'),
              _buildBar(400, Colors.orange, 'Wed'),
              _buildBar(550, Colors.blue, 'Thu'),
              _buildBar(300, Colors.orange, 'Fri'),
              _buildBar(200, Colors.orange, 'Sat'),
              _buildBar(450, Colors.orange, 'Sun'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryCyclesChart() {
    final List<BarChartGroupData> barGroups = [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 1400, color: Colors.blue, width: 20)],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 1050, color: Colors.orange, width: 20)],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 700, color: Colors.green, width: 20)],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: 350, color: Colors.purple, width: 20)],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [BarChartRodData(toY: 200, color: Colors.red, width: 20)],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [BarChartRodData(toY: 150, color: Colors.amber, width: 20)],
        showingTooltipIndicators: [0],
      ),
    ];

    return _buildChartContainer(
      'Battery Cycles',
      Container(
        height: 250,
        padding: EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 1500,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final titles = [
                      'Nigeria',
                      'Ghana',
                      'Kenya',
                      'Tanzania',
                      'Uganda',
                      'Rwanda',
                    ];
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        titles[value.toInt()],
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false),
            borderData: FlBorderData(show: false),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleBar(double height, Color color, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height:
              height / 8, // Adjust division factor based on your max data value
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
          child: Center(
            child: Text(
              height.toInt().toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBar(double height, Color color, String label) {
    return Column(
      children: [
        Container(
          width: 20,
          height: height / 8,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
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
          _buildAgentRow(
            'AGQ01',
            'John Doe',
            'Accra Central',
            'online',
            'Morning',
          ),
          _buildAgentRow(
            'AGQ02',
            'Sarah Wilson',
            'Lagos Island',
            'busy',
            'Morning',
          ),
          _buildAgentRow(
            'AGQ03',
            'Michael Chen',
            'Nairobi CBD',
            'online',
            'Morning',
          ),
          _buildAgentRow(
            'AGQ04',
            'Emma Johnson',
            'Kumasi Hub',
            'break',
            'Morning',
          ),
          _buildAgentRow(
            'AGQ05',
            'David Brown',
            'Abuja Central',
            'busy',
            'Afternoon',
          ),
          _buildAgentRow(
            'AGQ06',
            'Lisa Zhang',
            'Mombasa Port',
            'online',
            'Afternoon',
          ),
          _buildAgentRow(
            'AGQ07',
            'James Miller',
            'Tamale Station',
            'offline',
            'Morning',
          ),
          _buildAgentRow(
            'AGQ08',
            'Anna Davis',
            'Cape Coast',
            'online',
            'Evening',
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: textWithAlignAndColor(
              'Do not sell or share my personal info',
              10,
              TextType.Regular,
              TextAlign.center,
              Colors.grey[600]!,
            ),
          ),
        ],
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
    Color statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: text(id, 12, TextType.Regular)),
          Expanded(flex: 3, child: text(name, 12, TextType.Regular)),
          Expanded(flex: 3, child: text(station, 12, TextType.Regular)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
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
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: text('Active Alerts', 16, TextType.Bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: textWithColor(
              '3 critical alerts require immediate attention',
              12,
              TextType.SemiBold,
              Colors.red,
            ),
          ),
          SizedBox(height: 16),
          _buildAlertItem(
            'Power Consumption High',
            'Station power usage exceeds normal parameters',
            'Power - Kumasi Hub • Ghana',
            '45 minutes ago',
            Colors.red,
          ),
          SizedBox(height: 12),
          _buildAlertItem(
            'Connectivity Issues',
            'Intermittent WiFi connectivity reported',
            'Connectivity - Tamale Station • Ghana',
            '1 hour ago',
            Colors.orange,
          ),
          SizedBox(height: 12),
          _buildAlertItem(
            'System Maintenance Required',
            'Scheduled maintenance overdue by 3 days',
            'System - Abuja Central • Nigeria',
            '2 hours ago',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    String title,
    String description,
    String location,
    String time,
    Color color,
  ) {
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

  Future<void> _submitAgentForm() async {
    if (_firstnameController.text.isEmpty ||
        _lastnameController.text.isEmpty ||
        _identificationController.text.isEmpty ||
        _phonenumberController.text.isEmpty ||
        _emailController.text.isEmpty) {
      _showErrorNotification("Please fill in all required fields");
      return;
    }

    if (emailRegex(_emailController.text)) {
      _showErrorNotification("Please enter a valid email address");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userData = UserRegistration(
        firstname: _firstnameController.text,
        middlename: _middlenameController.text,
        lastname: _lastnameController.text,
        dob: _dobController.text,
        nationality: _nationalityController.text,
        identification: _identificationController.text,
        phonenumber: _phonenumberController.text,
        email: _emailController.text,
        statusId: "b8641bcd-07d5-4919-b459-5a081dee449b",
        createdBy: "admin",
      );

      final success = await _model!.sendUserRegistration(userData);
      if (success) {
        _showSuccessNotification("Agent registered successfully!");
        setState(() {
          _showAddForm = false;
          _clearAgentForm();
        });
      } else {
        throw Exception('Failed to register agent');
      }
    } catch (error) {
      _showErrorNotification("Failed to register agent: $error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitBatteryForm() async {
    if (_oemController.text.isEmpty ||
        _serialNumberController.text.isEmpty ||
        _batteryTypeIdController.text.isEmpty) {
      _showErrorNotification("Please fill in all required fields");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final batteryData = BatteryRequest(
        id: "status-id-here",
        oem: _oemController.text,
        serialNumber: _serialNumberController.text,
        batteryTypeId: _batteryTypeIdController.text,
        createdBy: "admin",
      );

      final success = await _model!.createBattery(batteryData);
      if (success) {
        _showSuccessNotification("Battery added successfully!");
      } else {
        throw Exception('Failed to add battery');
      }
    } catch (error) {
      _showErrorNotification("Failed to add battery: $error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearAgentForm() {
    _firstnameController.clear();
    _middlenameController.clear();
    _lastnameController.clear();
    _dobController.clear();
    _nationalityController.clear();
    _identificationController.clear();
    _phonenumberController.clear();
    _emailController.clear();
  }

  void _clearBatteryForm() {
    _oemController.clear();
    _serialNumberController.clear();
    _batteryTypeIdController.clear();
  }

  void _showSuccessNotification(String message) {
    _model!.showApplicationNotification(
      NotificationType.success,
      "Success",
      message,
      true,
      true,
      null,
      () {
        setState(() {
          _showAgentForm = false;
          _showBatteryForm = false;
          _showDashboard = true;
          _clearAgentForm();
          _clearBatteryForm();
        });
      },
    );
  }

  void _showErrorNotification(String message) {
    _model!.showApplicationNotification(
      NotificationType.error,
      "Error",
      message,
      true,
      true,
      null,
      () {},
    );
  }

  void _closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'break':
        return Colors.blue;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _identificationController.dispose();
    _phonenumberController.dispose();
    _emailController.dispose();
    _editNameController.dispose();
    _editAgentIdController.dispose();
    _editPhoneController.dispose();
    _editEmailController.dispose();
    _editStationController.dispose();
    _editAddressController.dispose();
    _oemController.dispose();
    _serialNumberController.dispose();
    _batteryTypeIdController.dispose();
    _incidentTitleController.dispose();
    _incidentDescriptionController.dispose();
    _incidentLocationController.dispose();
    _batterySerialController.dispose();
    _batteryStatusController.dispose();
    _powerEventController.dispose();
    _shiftNotesController.dispose();
    _customerSearchController.dispose();
    super.dispose();
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}
