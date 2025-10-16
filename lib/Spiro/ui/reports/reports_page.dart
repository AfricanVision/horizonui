import 'package:flutter/material.dart';

import '../../utils/DesignSystem.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpiroDesignSystem.gray50,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SpiroDesignSystem.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: SpiroDesignSystem.space8),
            _buildReportsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports',
            style: SpiroDesignSystem.displayM.copyWith(
              fontWeight: FontWeight.w700,
              color: SpiroDesignSystem.gray900,
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space2),
          Text(
            'Analytics and performance reports',
            style: SpiroDesignSystem.bodyL.copyWith(
              color: SpiroDesignSystem.gray600,
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildHeaderButton(
                onPressed: () {},
                icon: Icons.date_range_outlined,
                label: 'Select Period',
                isPrimary: false,
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              _buildHeaderButton(
                onPressed: () {},
                icon: Icons.file_download_outlined,
                label: 'Export All',
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary ? SpiroDesignSystem.primaryGradient : null,
        color: isPrimary ? null : Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        boxShadow: isPrimary
            ? SpiroDesignSystem.shadowPrimary
            : SpiroDesignSystem.shadowSm,
        border: isPrimary
            ? null
            : Border.all(color: SpiroDesignSystem.gray300, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SpiroDesignSystem.space4,
              vertical: SpiroDesignSystem.space3,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isPrimary
                      ? Colors.white
                      : SpiroDesignSystem.primaryBlue600,
                  size: 18,
                ),
                SizedBox(width: SpiroDesignSystem.space2),
                Text(
                  label,
                  style: SpiroDesignSystem.bodyL.copyWith(
                    color: isPrimary
                        ? Colors.white
                        : SpiroDesignSystem.primaryBlue600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: SpiroDesignSystem.space4,
      mainAxisSpacing: SpiroDesignSystem.space4,
      childAspectRatio: 1.2,
      children: [
        _buildReportCard(
          'Daily Operations',
          Icons.assessment_outlined,
          SpiroDesignSystem.primaryBlue600,
          'Track daily activities',
        ),
        _buildReportCard(
          'Agent Performance',
          Icons.people_outline,
          SpiroDesignSystem.success600,
          'View agent metrics',
        ),
        _buildReportCard(
          'Battery Health',
          Icons.battery_std_outlined,
          SpiroDesignSystem.warning600,
          'Monitor battery status',
        ),
        _buildReportCard(
          'Station Metrics',
          Icons.ev_station_outlined,
          SpiroDesignSystem.info600,
          'Station performance data',
        ),
        _buildReportCard(
          'Financial Summary',
          Icons.attach_money_outlined,
          SpiroDesignSystem.success600,
          'Revenue and costs',
        ),
        _buildReportCard(
          'Incident Logs',
          Icons.warning_outlined,
          SpiroDesignSystem.danger600,
          'Incident history',
        ),
      ],
    );
  }

  Widget _buildReportCard(
    String title,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        boxShadow: SpiroDesignSystem.shadowMd,
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showReportMessage(title);
          },
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
          child: Padding(
            padding: EdgeInsets.all(SpiroDesignSystem.space5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                SizedBox(height: SpiroDesignSystem.space3),
                Text(
                  title,
                  style: SpiroDesignSystem.titleM.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SpiroDesignSystem.gray900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SpiroDesignSystem.space2),
                Text(
                  subtitle,
                  style: SpiroDesignSystem.bodyS.copyWith(
                    color: SpiroDesignSystem.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SpiroDesignSystem.space3),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SpiroDesignSystem.space3,
                    vertical: SpiroDesignSystem.space2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusSm,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_outlined, color: color, size: 16),
                      SizedBox(width: SpiroDesignSystem.space1),
                      Text(
                        'Generate',
                        style: SpiroDesignSystem.bodyS.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReportMessage(String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Generating $reportName report...'),
          ],
        ),
        backgroundColor: SpiroDesignSystem.primaryBlue600,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
