import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizonui/Spiro/ui/home/ConnectHome.dart';
import 'package:stacked/stacked.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Responsive.dart';
import '../dashboard/dashboard_page.dart';
import '../agents/agents_page.dart';
import '../stations/stations_page.dart';
import '../batteries/batteries_page.dart';
import '../analytics/analytics_page.dart';
import '../incidents/incidents_page.dart';
import '../reports/reports_page.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import 'Home.dart';
import 'ViewHome.dart';

class HomeState extends State<Home> implements ConnectHome{
  String _selectedMenuItem = 'Dashboard';
  Widget _currentPage = DashboardPage();

  ViewHome? _model;

 /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: _selectedMenuItem == 'Dashboard' ? _buildSidebar() : null,
      body: _currentPage,
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewHome>.reactive(
        viewModelBuilder: () => ViewHome(context, this),
        onViewModelReady: (viewModel) => {
          _model = viewModel,
          _initialiseView()
        },
        builder: (context, viewModel, child) => PopScope(canPop: false, // Prevents auto pop
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              if (_model?.loadingEntry == null && _model?.errorEntry == null) {
                _closeApp();
              }
            }
          },child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints viewportConstraints) {
                    return Responsive(mobile: _mobileView(viewportConstraints),desktop: _desktopView(viewportConstraints),tablet: _desktopView(viewportConstraints),);})),));
  }

  _initialiseView() async {
    //_model?.setUserDetails();
  }

  _mobileView(BoxConstraints viewportConstraints){
    return Column();
  }

  _desktopView(BoxConstraints viewportConstraints){
    return _currentPage;
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
                  textWithColor('Control Tower', 14, TextType.Regular, colorMilkWhite),
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
            _buildUserSection(),
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
          isSelected ? colorPrimary : Colors.grey[700]!
      ),
      selected: isSelected,
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

  Widget _buildUserSection() {
    return Container(
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
    );
  }

  void _closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }


}