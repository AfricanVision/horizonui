import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../dashboard/dashboard_page.dart';
import '../agents/agents_page.dart';
import '../stations/stations_page.dart';
import '../batteries/batteries_page.dart';
import '../analytics/analytics_page.dart';
import '../incidents/incidents_page.dart';
import '../reports/reports_page.dart';
import '../data_entry/data_entry_page.dart';
import '../../designs/Component.dart';
import '../../designs/Responsive.dart';
import '../../utils/Colors.dart';
import 'ConnectHome.dart';
import 'Home.dart';

class HomeState extends State<Home> {
  String _selectedMenuItem = 'Dashboard';
  Widget _currentPage = DashboardPage();

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
    return Column();
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

}