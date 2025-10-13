import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
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



  Widget _buildAnalyticsHeader() {
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
                  text('Analytics', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text('Performance insights and metrics', 16, TextType.Regular),
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
        // Main chart - enhanced from AnalyticsScreen
        Container(
          height: 360,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ColumnSeries<ChartData, String>>[
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
                animationDuration: 1200,
                pointColorMapper: (ChartData data, _) => data.color,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildAnalyticsMiniCard('Downtime', '0.8%')),
            SizedBox(width: 12),
            Expanded(child: _buildAnalyticsMiniCard('Power Events', '12')),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
        SizedBox(height: 24),
        // Additional charts from HomeState
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildBatteryCyclesChart()),
            SizedBox(width: 16),
            Expanded(child: _buildPowerConsumptionChart()),
          ],
        ),
        SizedBox(height: 24),
        _buildSwapsTrendSection(),
      ],
    );
  }

  Widget _buildAnalyticsMiniCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWithColor(title, 14, TextType.SemiBold, Colors.grey[700]!),
          SizedBox(height: 8),
          text(value, 20, TextType.Bold),
          Spacer(),
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: Colors.green),
              SizedBox(width: 8),
              text('Since last week', 12, TextType.Regular),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryCyclesChart() {
    return _buildChartContainer(
      'Battery Cycles',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: 'Countries'),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Cycles'),
          ),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: [
                ChartData('Nigeria', 1400, Colors.blue),
                ChartData('Ghana', 1050, Colors.orange),
                ChartData('Kenya', 700, Colors.green),
                ChartData('Tanzania', 350, Colors.purple),
                ChartData('Uganda', 200, Colors.red),
                ChartData('Rwanda', 150, Colors.amber),
              ],
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

  Widget _buildPowerConsumptionChart() {
    return _buildChartContainer(
      'Power Consumption (14-day)',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: 'Date'),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Power (kWh)'),
          ),
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
            )
          ],
        ),
      ),
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
              Expanded(child: _buildBatteryCyclesMiniChart()),
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

  Widget _buildBatteryCyclesMiniChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Battery Health', 14, TextType.SemiBold),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBar(85, Colors.green, 'Nigeria'),
              _buildBar(78, Colors.orange, 'Ghana'),
              _buildBar(92, Colors.green, 'Kenya'),
              _buildBar(65, Colors.red, 'Tanzania'),
              _buildBar(88, Colors.green, 'Uganda'),
              _buildBar(95, Colors.green, 'Rwanda'),
            ],
          ),
        ),
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

  Widget _buildAnalyticsMenuItem(String title, IconData icon) {
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

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}