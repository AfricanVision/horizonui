import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/ui/analytics/ConnectAnalytics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/DesignSystem.dart';
import 'Analytics.dart';

class AnalyticsPageState extends State<AnalyticsPage>
    implements ConnectAnalytics {
  String _selectedPeriod = 'Last 7 Days';

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
            _buildStatisticsCards(),
            SizedBox(height: SpiroDesignSystem.space6),
            _buildChartsRow(),
            SizedBox(height: SpiroDesignSystem.space6),
            _buildSwapsTrendSection(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics Dashboard',
                style: SpiroDesignSystem.displayM.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space2),
              Text(
                'Performance insights and metrics analysis',
                style: SpiroDesignSystem.bodyL.copyWith(
                  color: SpiroDesignSystem.gray600,
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: _buildHeaderButton(
                  onPressed: () => _showPeriodSelector(),
                  icon: Icons.date_range_outlined,
                  label: _selectedPeriod,
                  isPrimary: false,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Flexible(
                child: _buildHeaderButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Exporting analytics report...'),
                        backgroundColor: SpiroDesignSystem.success600,
                      ),
                    );
                  },
                  icon: Icons.file_download_outlined,
                  label: 'Export Report',
                  isPrimary: true,
                ),
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

  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Swaps',
            '3,500',
            'last 7 days',
            SpiroDesignSystem.primaryBlue600,
            Icons.swap_horiz_outlined,
            '+12%',
            true,
          ),
        ),
        SizedBox(width: SpiroDesignSystem.space4),
        Expanded(
          child: _buildStatCard(
            'Downtime',
            '0.8%',
            '99.2% uptime',
            SpiroDesignSystem.warning600,
            Icons.timeline_outlined,
            null,
            true,
          ),
        ),
        SizedBox(width: SpiroDesignSystem.space4),
        Expanded(
          child: _buildStatCard(
            'Power Events',
            '12',
            'this week',
            SpiroDesignSystem.danger600,
            Icons.electric_bolt_outlined,
            null,
            false,
          ),
        ),
        SizedBox(width: SpiroDesignSystem.space4),
        Expanded(
          child: _buildStatCard(
            'Avg Efficiency',
            '92%',
            'all stations',
            SpiroDesignSystem.success600,
            Icons.check_circle_outline,
            '+3%',
            true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    String subtitle,
    Color color,
    IconData icon,
    String? trend,
    bool? trendPositive,
  ) {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space5),
      decoration: SpiroDesignSystem.cardDecoration.copyWith(
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
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
          SizedBox(height: SpiroDesignSystem.space3),
          Text(
            count,
            style: SpiroDesignSystem.displayM.copyWith(
              fontWeight: FontWeight.w700,
              color: SpiroDesignSystem.gray900,
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space1),
          Row(
            children: [
              Text(
                subtitle,
                style: SpiroDesignSystem.bodyS.copyWith(
                  color: SpiroDesignSystem.gray600,
                ),
              ),
              if (trend != null) ...[
                SizedBox(width: SpiroDesignSystem.space2),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendPositive == true
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 12,
                        color: trendPositive == true
                            ? SpiroDesignSystem.success700
                            : SpiroDesignSystem.danger700,
                      ),
                      SizedBox(width: SpiroDesignSystem.space0_5),
                      Text(
                        trend,
                        style: SpiroDesignSystem.caption.copyWith(
                          color: trendPositive == true
                              ? SpiroDesignSystem.success700
                              : SpiroDesignSystem.danger700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildBatteryCyclesChart()),
        SizedBox(width: SpiroDesignSystem.space4),
        Expanded(child: _buildPowerConsumptionChart()),
      ],
    );
  }

  Widget _buildBatteryCyclesChart() {
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
                  color: SpiroDesignSystem.primaryBlue600.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                  border: Border.all(
                    color: SpiroDesignSystem.primaryBlue600.withValues(
                      alpha: 0.2,
                    ),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.battery_charging_full_outlined,
                  color: SpiroDesignSystem.primaryBlue600,
                  size: 18,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Battery Cycles by Country',
                      style: SpiroDesignSystem.titleM.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    Text(
                      'Total cycles per region',
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
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: SpiroDesignSystem.bodyS.copyWith(
                  color: SpiroDesignSystem.gray600,
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Cycles',
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
                    ChartData(
                      'Nigeria',
                      1400,
                      SpiroDesignSystem.primaryBlue500,
                    ),
                    ChartData('Ghana', 1050, SpiroDesignSystem.success500),
                    ChartData('Kenya', 700, SpiroDesignSystem.info500),
                    ChartData('Tanzania', 350, SpiroDesignSystem.warning500),
                    ChartData('Uganda', 200, SpiroDesignSystem.danger500),
                    ChartData('Rwanda', 150, SpiroDesignSystem.primaryBlue300),
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
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusXs,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerConsumptionChart() {
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
                  color: SpiroDesignSystem.warning600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                  border: Border.all(
                    color: SpiroDesignSystem.warning600.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.electric_bolt,
                  color: SpiroDesignSystem.warning600,
                  size: 18,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Power Consumption Trend',
                      style: SpiroDesignSystem.titleM.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    Text(
                      '14-day power usage',
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
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
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
        ],
      ),
    );
  }

  Widget _buildSwapsTrendSection() {
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
                      'Weekly Performance Analysis',
                      style: SpiroDesignSystem.titleM.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    Text(
                      'Daily swaps and battery health metrics',
                      style: SpiroDesignSystem.bodyS.copyWith(
                        color: SpiroDesignSystem.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDailySwapsChart()),
              SizedBox(width: SpiroDesignSystem.space4),
              Expanded(child: _buildBatteryHealthChart()),
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
        Container(
          padding: EdgeInsets.all(SpiroDesignSystem.space3),
          decoration: BoxDecoration(
            color: SpiroDesignSystem.primaryBlue50,
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            border: Border.all(
              color: SpiroDesignSystem.primaryBlue200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.swap_horiz,
                color: SpiroDesignSystem.primaryBlue600,
                size: 16,
              ),
              SizedBox(width: SpiroDesignSystem.space2),
              Text(
                'Daily Swaps',
                style: SpiroDesignSystem.bodyL.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SpiroDesignSystem.primaryBlue700,
                ),
              ),
            ],
          ),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBar(800, SpiroDesignSystem.primaryBlue500, 'Mon'),
              _buildBar(600, SpiroDesignSystem.warning500, 'Tue'),
              _buildBar(400, SpiroDesignSystem.warning500, 'Wed'),
              _buildBar(550, SpiroDesignSystem.success500, 'Thu'),
              _buildBar(300, SpiroDesignSystem.warning500, 'Fri'),
              _buildBar(200, SpiroDesignSystem.danger500, 'Sat'),
              _buildBar(450, SpiroDesignSystem.primaryBlue500, 'Sun'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryHealthChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(SpiroDesignSystem.space3),
          decoration: BoxDecoration(
            color: SpiroDesignSystem.success50,
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            border: Border.all(color: SpiroDesignSystem.success200, width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.battery_charging_full,
                color: SpiroDesignSystem.success600,
                size: 16,
              ),
              SizedBox(width: SpiroDesignSystem.space2),
              Text(
                'Battery Health',
                style: SpiroDesignSystem.bodyL.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SpiroDesignSystem.success700,
                ),
              ),
            ],
          ),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBar(85, SpiroDesignSystem.success500, 'NG'),
              _buildBar(78, SpiroDesignSystem.warning500, 'GH'),
              _buildBar(92, SpiroDesignSystem.success500, 'KE'),
              _buildBar(65, SpiroDesignSystem.danger500, 'TZ'),
              _buildBar(88, SpiroDesignSystem.success500, 'UG'),
              _buildBar(95, SpiroDesignSystem.success500, 'RW'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(double height, Color color, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: height / 6,
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

  void _showPeriodSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Period',
            style: SpiroDesignSystem.titleM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPeriodOption('Last 7 Days'),
              _buildPeriodOption('Last 30 Days'),
              _buildPeriodOption('Last 3 Months'),
              _buildPeriodOption('Last Year'),
              _buildPeriodOption('Custom Range'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodOption(String period) {
    bool isSelected = _selectedPeriod == period;
    return ListTile(
      title: Text(
        period,
        style: SpiroDesignSystem.bodyL.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected
              ? SpiroDesignSystem.primaryBlue600
              : SpiroDesignSystem.gray800,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: SpiroDesignSystem.primaryBlue600)
          : null,
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Period changed to: $period'),
            backgroundColor: SpiroDesignSystem.success600,
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}
