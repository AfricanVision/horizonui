import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../data/internal/application/NavigatorType.dart';
import '../../data/internal/application/NotificationType.dart';
import '../../data/internal/application/TextType.dart';
import '../../data/internal/application/UserRegistration.dart';
import '../../data/internal/application/BatteryRequest.dart';
import '../../configs/Navigator.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import '../../utils/InputValidator.dart';
import '../../utils/Validators.dart';
import 'ConnectHome.dart';
import 'Home.dart';
import 'ViewHome.dart';

class HomeState extends State<Home> implements ConnectHome{

  ViewHome? _model;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _identificationController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _oemController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _batteryTypeIdController = TextEditingController();

  bool _isLoading = false;
  bool _showAttendantForm = false;
  bool _showBatteryForm = false;
  bool _showDashboard = true;
  String _selectedMenuItem = 'Agents';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewHome>.reactive(
        viewModelBuilder: () => ViewHome(context, this),
        onViewModelReady: (viewModel) => {
          _model = viewModel,
          _initialiseView()
        },
        builder: (context, viewModel, child) => WillPopScope(
            child: _mainBody(),
            onWillPop: () async {
              if (_model?.loadingEntry == null && _model?.errorEntry == null) {
                _closeApp();
              }
              return false;
            }
        ));
  }

  _initialiseView() async {
    // Initialization logic here
  }

  Widget _mainBody(){
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _showDashboard ? AppBar(
        backgroundColor: colorPrimaryDark,
        title: text("Spiro App", 18, TextType.Bold),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.add, color: colorMilkWhite),
            onSelected: (value) {
              setState(() {
                _showAttendantForm = value == 'agent';
                _showBatteryForm = value == 'battery';
                _showDashboard = false;
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
          )
        ],
      ) : null,
      drawer: _showDashboard ? _buildSidebar() : null,
      body: _getCurrentView(),
    );
  }

  Widget _getCurrentView() {
    if (_showAttendantForm) return _buildAttendantManagementForm();
    if (_showBatteryForm) return _buildBatteryManagementForm();
    if (_showDashboard) return _buildDashboard();
    return _buildHomeContent();
  }

  Widget _buildSidebar() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
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
                  textWithColor('Control Tower', 14, TextType.Regular, colorMilkWhite.withOpacity(0.7)),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuSection('MAIN MENU', [
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

            // Footer
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
                        textWithColor('Global Admin', 12, TextType.Regular, Colors.grey[600]!),
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
          isSelected ? colorPrimary : Colors.grey[700]!
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedMenuItem = title;
        });
        Navigator.pop(context);
      },
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
          text("Welcome to Spiro", 24, TextType.Bold),
          SizedBox(height: 20),
          text("Your all-in-one business solution", 16, TextType.Regular),
          SizedBox(height: 40),
          roundedCornerButton(
              "Go to Dashboard",
                  () => setState(() => _showDashboard = true)
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleAndDescription('Dashboard', 'Control tower overview'),
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
      crossAxisCount: 5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
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
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 48, color: Colors.blue[300]),
                      SizedBox(height: 8),
                      textWithColor('Africa Operations Map', 16, TextType.Bold, Colors.blue[600]!),
                      SizedBox(height: 8),
                      textWithColor('1920px+ Desktop View', 12, TextType.Regular, Colors.grey[600]!),
                    ],
                  ),
                ),
                Positioned(
                  top: 16, left: 16,
                  child: _buildMapInfoPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapInfoPanel() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text('Africa Overview', 14, TextType.Bold),
          SizedBox(height: 8),
          text('Countries: 8', 12, TextType.Regular),
          text('Total Agents: 4972', 12, TextType.Regular),
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
          )
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, color: color, margin: EdgeInsets.only(right: 4)),
        text(label, 12, TextType.Regular),
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
        height: 200,
        child: Column(
          children: [
            Row(children: [Container(width: 40, child: text('100', 10, TextType.Regular)), Expanded(child: SizedBox())]),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['75', '50', '25', '0'].map<Widget>((label) => text(label, 10, TextType.Regular)).toList(),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildChartBar(60, Colors.blue, 'Station A'),
                        _buildChartBar(85, Colors.orange, 'Station B'),
                        _buildChartBar(45, Colors.red, 'Station D'),
                        _buildChartBar(70, Colors.blue, 'Station E'),
                        _buildChartBar(55, Colors.orange, 'Station F'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['A', 'B', 'D', 'E', 'F'].map<Widget>((label) => text(label, 10, TextType.Regular)).toList(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Planned'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.orange, 'Unplanned'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Uptime %'),
              ],
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
        height: 200,
        child: Column(
          children: [
            Row(children: [Container(width: 40, child: text('1000', 10, TextType.Regular)), Expanded(child: SizedBox())]),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      'Sep 25', 'Sep 27', 'Sep 29', 'Oct 1', 'Oct 3', 'Oct 5', 'Oct 7'
                    ].map<Widget>((label) => text(label, 10, TextType.Regular)).toList(),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLineChartPoint(800),
                          _buildLineChartPoint(650),
                          _buildLineChartPoint(720),
                          _buildLineChartPoint(580),
                          _buildLineChartPoint(690),
                          _buildLineChartPoint(750),
                          _buildLineChartPoint(820),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                text('Sep 25', 10, TextType.Regular),
                text('Sep 27', 10, TextType.Regular),
                text('Sep 29', 10, TextType.Regular),
                text('Oct 1', 10, TextType.Regular),
                text('Oct 3', 10, TextType.Regular),
                text('Oct 5', 10, TextType.Regular),
                text('Oct 7', 10, TextType.Regular),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'WiFi Uptime %'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.orange, 'kWh'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        SizedBox(width: 4),
        textWithColor(text, 12, TextType.Regular, colorPrimaryDark),
      ],
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
        Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
        Container(width: 2, height: height / 4, color: Colors.blue),
      ],
    );
  }

  Widget _buildSwapsTrendSection() {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Battery Cycles', 14, TextType.SemiBold),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBar(1400, Colors.blue, 'Nigeria'),
              _buildBar(1050, Colors.orange, 'Ghana'),
              _buildBar(700, Colors.orange, 'Kenya'),
              _buildBar(350, Colors.orange, 'Tanzania'),
              _buildBar(200, Colors.orange, 'Uganda'),
              _buildBar(150, Colors.orange, 'Rwanda'),
            ],
          ),
        ),
        SizedBox(height: 8),
        textWithColor('Cycle Count vs Health %', 12, TextType.Regular, Colors.grey[600]!),
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: text('On-Shift Agents', 16, TextType.Bold),
          ),

          // Table Header
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

          // Agent Rows
          _buildAgentRow('AGQ01', 'John Doe', 'Accra Central', 'online', 'Morning'),
          _buildAgentRow('AGQ02', 'Sarah Wilson', 'Lagos Island', 'busy', 'Morning'),
          _buildAgentRow('AGQ03', 'Michael Chen', 'Nairobi CBD', 'online', 'Morning'),
          _buildAgentRow('AGQ04', 'Emma Johnson', 'Kumasi Hub', 'break', 'Morning'),
          _buildAgentRow('AGQ05', 'David Brown', 'Abuja Central', 'busy', 'Afternoon'),
          _buildAgentRow('AGQ06', 'Lisa Zhang', 'Mombasa Port', 'online', 'Afternoon'),
          _buildAgentRow('AGQ07', 'James Miller', 'Tamale Station', 'offline', 'Morning'),
          _buildAgentRow('AGQ08', 'Anna Davis', 'Cape Coast', 'online', 'Evening'),

          // Footer
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[300]!))),
            child: textWithAlignAndColor(
                'Do not sell or share my personal info',
                10,
                TextType.Regular,
                TextAlign.center,
                Colors.grey[600]!
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online': return Colors.green;
      case 'busy': return Colors.orange;
      case 'break': return Colors.blue;
      case 'offline': return Colors.grey;
      default: return Colors.grey;
    }
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
          SizedBox(height: 12),
          _buildAlertItem('System Maintenance Required', 'Scheduled maintenance overdue by 3 days', 'System - Abuja Central • Nigeria', '2 hours ago', Colors.blue),
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

  Widget _buildAttendantManagementForm() {
    return _buildManagementForm(
        title: "Agent Management",
        searchHint: "Search agents...",
        formSection: _buildAttendantFormSection(),
        onBack: () {
          setState(() {
            _showAttendantForm = false;
            _showDashboard = true;
            _clearAgentForm();
          });
        }
    );
  }

  Widget _buildBatteryManagementForm() {
    return _buildManagementForm(
        title: "Battery Management",
        searchHint: "Search batteries...",
        formSection: _buildBatteryFormSection(),
        onBack: () {
          setState(() {
            _showBatteryForm = false;
            _showDashboard = true;
            _clearBatteryForm();
          });
        }
    );
  }

  Widget _buildManagementForm({required String title, required String searchHint, required Widget formSection, required VoidCallback onBack}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [backButtonWithAction(context, onBack), SizedBox(width: 16), text(title, 20, TextType.Bold)]),
          SizedBox(height: 16),
          searchFieldMain((value) => null, true, TextEditingController(), () {}),
          SizedBox(height: 24),
          formSection,
        ],
      ),
    );
  }

  Widget _buildAttendantFormSection() {
    return _buildFormSection(
      title: "Add New Agent",
      leftColumn: _buildAgentLeftColumn(),
      rightColumn: _buildAgentRightColumn(),
      buttonText: _isLoading ? "Registering..." : "Register Agent",
      onPressed: _isLoading ? null : _submitAgentForm,
    );
  }

  Widget _buildBatteryFormSection() {
    return _buildFormSection(
      title: "Add New Battery",
      leftColumn: _buildBatteryLeftColumn(),
      rightColumn: _buildBatteryRightColumn(),
      buttonText: _isLoading ? "Adding..." : "Add Battery",
      onPressed: _isLoading ? null : _submitBatteryForm,
    );
  }

  Widget _buildFormSection({required String title, required Widget leftColumn, required Widget rightColumn, required String buttonText, VoidCallback? onPressed}) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(title, 20, TextType.Bold),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: leftColumn),
              SizedBox(width: 20),
              Expanded(child: rightColumn),
            ],
          ),
          SizedBox(height: 30),
          SizedBox(width: double.infinity, child: roundedCornerButton(buttonText, onPressed)),
          if (_isLoading) ...[
            SizedBox(height: 16),
            Center(child: CircularProgressIndicator(color: colorPrimary)),
          ],
        ],
      ),
    );
  }

  Widget _buildAgentLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(label: 'First Name *', hintText: 'e.g., Cynthia', controller: _firstnameController),
        SizedBox(height: 16),
        _buildFormField(label: 'Phone Number *', hintText: 'e.g., 0712345678', controller: _phonenumberController, keyboardType: TextInputType.phone, inputFormatters: [numbersInputFormatter()]),
        SizedBox(height: 16),
        _buildFormField(label: 'Identification Number *', hintText: 'e.g., ID123456', controller: _identificationController),
        SizedBox(height: 16),
        _buildDatePickerField(),
        SizedBox(height: 16),
        _buildFormField(label: 'Nationality *', hintText: 'e.g., Kenyan', controller: _nationalityController),
        SizedBox(height: 20),
        Container(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildAgentRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(label: 'Last Name *', hintText: 'e.g., Fake', controller: _lastnameController),
        SizedBox(height: 16),
        _buildFormField(label: 'Email Address *', hintText: 'e.g., CSituma@example.com', controller: _emailController, keyboardType: TextInputType.emailAddress),
        SizedBox(height: 16),
        _buildFormField(label: 'Middle Name', hintText: 'e.g., Situma', controller: _middlenameController),
      ],
    );
  }

  Widget _buildBatteryLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(label: 'OEM *', hintText: 'A7246AX1Axxxxxxxx', controller: _oemController),
        SizedBox(height: 16),
        _buildFormField(label: 'Serial Number *', hintText: 'EKON/RW/UNI/07100', controller: _serialNumberController, keyboardType: TextInputType.text),
      ],
    );
  }

  Widget _buildBatteryRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(label: 'Battery Type ID *', hintText: '', controller: _batteryTypeIdController),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: isRequired ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))] : [],
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(6)),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[600]),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Date of Birth *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
          ),
        ),
        SizedBox(height: 6),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(6)),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(child: textWithColor(_dobController.text.isEmpty ? 'Select date of birth' : _dobController.text, 14, TextType.Regular, _dobController.text.isEmpty ? Colors.grey[600]! : Colors.black87)),
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitAgentForm() async {
    if (_firstnameController.text.isEmpty || _lastnameController.text.isEmpty || _dobController.text.isEmpty || _nationalityController.text.isEmpty || _identificationController.text.isEmpty || _phonenumberController.text.isEmpty || _emailController.text.isEmpty) {
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
    if (_oemController.text.isEmpty || _serialNumberController.text.isEmpty || _batteryTypeIdController.text.isEmpty) {
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
          _showAttendantForm = false;
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
    _oemController.dispose();
    _serialNumberController.dispose();
    _batteryTypeIdController.dispose();
    super.dispose();
  }


}