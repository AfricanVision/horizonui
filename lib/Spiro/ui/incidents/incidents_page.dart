import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';

class IncidentsPage extends StatefulWidget {
  const IncidentsPage({super.key});

  @override
  State<IncidentsPage> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends State<IncidentsPage> {
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
            backButtonWithAction(context, () {}),
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
                text('3 critical alerts require immediate attention', 14, TextType.Regular),
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
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
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
                textWithColor(location, 14, TextType.Regular, Colors.grey[600]!),
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



  Widget _buildIncidentsMenuItem(String title, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
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