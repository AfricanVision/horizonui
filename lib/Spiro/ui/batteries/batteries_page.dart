import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BatteriesPage extends StatefulWidget {
  const BatteriesPage({super.key});

  @override
  State<BatteriesPage> createState() => _BatteriesPageState();
}

class _BatteriesPageState extends State<BatteriesPage> {
  // Add battery management controllers
  final TextEditingController _oemController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _batteryTypeIdController = TextEditingController();

  bool _showBatteryForm = false;
  bool _isLoading = false;

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
                  _buildBatteriesHeader(),
                  SizedBox(height: 32),
                  if (_showBatteryForm) _buildBatteryManagementForm(),
                  if (!_showBatteryForm) ...[
                    _buildBatteryStatsGrid(),
                    SizedBox(height: 32),
                    _buildBatteryChartsRow(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBatteriesHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            backButtonWithAction(context, () {
              if (_showBatteryForm) {
                setState(() {
                  _showBatteryForm = false;
                  _clearBatteryForm();
                });
              } else {
                Navigator.pop(context);
              }
            }),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(_showBatteryForm ? 'Add Battery' : 'Battery Analytics', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text(_showBatteryForm ? 'Add new battery to inventory' : 'Battery performance and health metrics', 16, TextType.Regular),
                ],
              ),
            ),
            if (!_showBatteryForm) ...[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showBatteryForm = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    textWithColor('Add Battery', 14, TextType.SemiBold, Colors.white),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildBatteryManagementForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text("Add New Battery", 20, TextType.Bold),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildBatteryFormColumn1(),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildBatteryFormColumn2(),
              ),
            ],
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: roundedCornerButton(
              _isLoading ? "Adding..." : "Add Battery",
              _isLoading ? null : _submitBatteryForm,
            ),
          ),
          if (_isLoading) ...[
            SizedBox(height: 16),
            Center(child: CircularProgressIndicator(color: colorPrimary)),
          ],
        ],
      ),
    );
  }

  Widget _buildBatteryFormColumn1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBatteryFormField(
          label: 'OEM *',
          hintText: 'A7246AX1Axxxxxxxx',
          controller: _oemController,
        ),
        SizedBox(height: 16),
        _buildBatteryFormField(
          label: 'Serial Number *',
          hintText: 'EKON/RW/UNI/07100',
          controller: _serialNumberController,
        ),
      ],
    );
  }

  Widget _buildBatteryFormColumn2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBatteryFormField(
          label: 'Battery Type ID *',
          hintText: 'Enter battery type ID',
          controller: _batteryTypeIdController,
        ),
      ],
    );
  }

  Widget _buildBatteryFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
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

  Widget _buildBatteryStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildBatteryStatCard('Total Batteries', '15,420', 'In circulation', '+2.1%', true),
        _buildBatteryStatCard('Avg Cycle Count', '1,247', 'Per battery', '+3.5%', true),
        _buildBatteryStatCard('Battery Health', '89%', 'Overall condition', '+1.2%', true),
        _buildBatteryStatCard('Replacement Rate', '2.1%', 'Monthly', '-0.9%', false),
      ],
    );
  }

  Widget _buildBatteryStatCard(String title, String mainValue, String subtitle, String trend, bool trendPositive) {
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
          text(mainValue, 20, TextType.Bold),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWithColor(subtitle, 12, TextType.Regular, Colors.grey[600]!),
              SizedBox(height: 4),
              textWithColor(trend, 12, TextType.SemiBold, trendPositive ? Colors.green : Colors.red),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryCyclesChart() {
    return _buildChartContainer(
      'Battery Cycles',
      Container(
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Countries')),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Cycles')),
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

  Widget _buildBatteriesMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 20),
      title: text(title, 14, TextType.Regular),
      onTap: () {
        print('Selected: $title');
        if (title == 'Add Battery') {
          setState(() {
            _showBatteryForm = true;
          });
        }
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

  // Battery form methods
  void _submitBatteryForm() {
    if (_oemController.text.isEmpty || _serialNumberController.text.isEmpty || _batteryTypeIdController.text.isEmpty) {
      _showErrorNotification("Please fill in all required fields");
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      _showSuccessNotification("Battery added successfully!");
      setState(() {
        _showBatteryForm = false;
        _clearBatteryForm();
      });
    });
  }

  void _clearBatteryForm() {
    _oemController.clear();
    _serialNumberController.clear();
    _batteryTypeIdController.clear();
  }

  void _showSuccessNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: text(message, 14, TextType.Regular),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: text(message, 14, TextType.Regular),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _oemController.dispose();
    _serialNumberController.dispose();
    _batteryTypeIdController.dispose();
    super.dispose();
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}