import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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
                  _buildReportsHeader(),
                  SizedBox(height: 32),
                  _buildReportsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildReportsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {}),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text('Reports', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text('Analytics and performance reports', 16, TextType.Regular),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildReportCard('Daily Operations', Icons.assessment, Colors.blue),
        _buildReportCard('Agent Performance', Icons.people, Colors.green),
        _buildReportCard('Battery Health', Icons.battery_std, Colors.orange),
        _buildReportCard('Station Metrics', Icons.ev_station, Colors.purple),
        _buildReportCard('Financial Summary', Icons.attach_money, Colors.teal),
        _buildReportCard('Incident Logs', Icons.warning, Colors.red),
      ],
    );
  }

  Widget _buildReportCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          text(title, 16, TextType.SemiBold),
          SizedBox(height: 8),
          textWithColor('Generate Report', 12, TextType.Regular, Colors.blue),
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