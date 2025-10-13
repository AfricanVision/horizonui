import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';

class StationsPage extends StatefulWidget {
  const StationsPage({super.key});

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  String _selectedMenuItem = 'All Stations';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [

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
                  SizedBox(height: 24),
                  _buildBackToDashboardButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToDashboardButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _returnToDashboard();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: shawnblue,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, color: Colors.white, size: 20),
            SizedBox(width: 8),
            textWithColor('Back to Dashboard', 16, TextType.SemiBold, Colors.white),
          ],
        ),
      ),
    );
  }

  void _returnToDashboard() {
    Navigator.pop(context);
    // If you need to navigate to a specific dashboard page:
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => DashboardPage()),
    //   (route) => false,
    // );
  }



  void _handleStationNavigation(String pageName) {
    print('Navigating to: $pageName');
  }

  Widget _buildStationsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {
              Navigator.pop(context);
            }),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text('Station Operations', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text('Active station issues and management', 16, TextType.Regular),
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
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
                Expanded(flex: 2, child: text('Assigned Owner', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Time', 12, TextType.Bold)),
              ],
            ),
          ),
          _buildStationTableRow(
            id: '1550801',
            station: 'Accra Central',
            issueType: 'Battery Mismatch',
            status: 'open',
            priority: 'High',
            owner: 'John Oke',
            time: '10:45 AM',
          ),
          _buildStationTableRow(
            id: '1550802',
            station: 'Lagos Island',
            issueType: 'Network Drop',
            status: 'check',
            priority: 'Medium',
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
            priority: 'Low',
            owner: 'Emma Johnson',
            time: '10:25 AM',
          ),
          _buildStationTableRow(
            id: '1550805',
            station: 'Abuja Central',
            issueType: 'Power Failure',
            status: 'retained',
            priority: 'High',
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

  Widget _buildStationsPagination() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text('Showing 6 of 6 operations', 12, TextType.Regular),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: textWithColor('Previous', 12, TextType.Regular, Colors.blue),
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
        ],
      ),
    );
  }

  String _getStationStatusIcon(String status) {
    switch (status) {
      case 'open': return '✔';
      case 'check': return '○';
      case 'retained': return '✔';
      default: return '✔';
    }
  }

  Color _getStationStatusColor(String status) {
    switch (status) {
      case 'open': return Colors.blue;
      case 'check': return Colors.orange;
      case 'retained': return Colors.green;
      default: return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
  }
}