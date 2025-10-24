import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../designs/Component.dart';
import '../../utils/DesignSystem.dart';

class BatteriesPage extends StatefulWidget {
  const BatteriesPage({super.key});

  @override
  State<BatteriesPage> createState() => _BatteriesPageState();
}

class _BatteriesPageState extends State<BatteriesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oemController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _batteryTypeIdController =
      TextEditingController();

  bool _showBatteryForm = false;

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
            if (_showBatteryForm) ...[
              _buildBatteryManagementForm(),
              SizedBox(height: SpiroDesignSystem.space6),
            ],
            if (!_showBatteryForm) ...[
              _buildBatteryStatsGrid(),
              SizedBox(height: SpiroDesignSystem.space6),
              _buildBatteryChartsRow(),
            ],
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
                'Battery Analytics',
                style: SpiroDesignSystem.displayM.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space2),
              Text(
                'Battery performance and health metrics',
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
                  onPressed: () {
                    _showSuccessMessage('Report exported successfully');
                  },
                  icon: Icons.file_download_outlined,
                  label: 'Export Report',
                  isPrimary: false,
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

  Widget _buildBatteryManagementForm() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        boxShadow: SpiroDesignSystem.shadowXl,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(SpiroDesignSystem.space4),
              decoration: BoxDecoration(
                gradient: SpiroDesignSystem.primaryGradient,
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
                boxShadow: SpiroDesignSystem.shadowPrimary,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.battery_charging_full_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: SpiroDesignSystem.space3),
                  Text(
                    'Add New Battery',
                    style: SpiroDesignSystem.titleM.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SpiroDesignSystem.space4),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'OEM',
                    _buildTextFormField(
                      controller: _oemController,
                      hintText: 'A7246AX1Axxxxxxxx',
                      icon: Icons.qr_code_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'OEM is required';
                        }
                        return null;
                      },
                    ),
                    isRequired: true,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                Expanded(
                  child: _buildFormField(
                    'Serial Number',
                    _buildTextFormField(
                      controller: _serialNumberController,
                      hintText: 'EKON/RW/UNI/07100',
                      icon: Icons.tag_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Serial number is required';
                        }
                        return null;
                      },
                    ),
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: SpiroDesignSystem.space3),
            _buildFormField(
              'Battery Type ID',
              _buildTextFormField(
                controller: _batteryTypeIdController,
                hintText: 'Enter battery type ID',
                icon: Icons.category_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Battery type ID is required';
                  }
                  return null;
                },
              ),
              isRequired: true,
            ),
            SizedBox(height: SpiroDesignSystem.space4),
            Row(
              children: [
                Expanded(
                  child: _outlinedButton(() {
                    setState(() {
                      _showBatteryForm = false;
                      _clearBatteryForm();
                    });
                  }, 'Cancel'),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                Expanded(
                  child: raisedButton('Add Battery', () {
                    if (_formKey.currentState!.validate()) {
                      _submitBatteryForm();
                    } else {
                      _showErrorMessage('Please fix the errors above');
                    }
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    String label,
    Widget child, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: SpiroDesignSystem.gray900,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: SpiroDesignSystem.red600,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: SpiroDesignSystem.space2),
        child,
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        boxShadow: SpiroDesignSystem.shadowSm,
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: SpiroDesignSystem.gray900, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: SpiroDesignSystem.gray500, fontSize: 14),
          prefixIcon: Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space3),
            child: Icon(
              icon,
              color: SpiroDesignSystem.primaryBlue600,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: SpiroDesignSystem.gray50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            borderSide: BorderSide(color: SpiroDesignSystem.gray300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            borderSide: BorderSide(color: SpiroDesignSystem.gray300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            borderSide: BorderSide(
              color: SpiroDesignSystem.primaryBlue600,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            borderSide: BorderSide(color: SpiroDesignSystem.red600, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
            borderSide: BorderSide(color: SpiroDesignSystem.red600, width: 2),
          ),
          contentPadding: EdgeInsets.all(16),
          errorStyle: TextStyle(color: SpiroDesignSystem.red600, fontSize: 12),
        ),
        validator: validator,
      ),
    );
  }

  Widget _outlinedButton(VoidCallback onPressed, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SpiroDesignSystem.space3,
        horizontal: SpiroDesignSystem.space6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        border: Border.all(color: SpiroDesignSystem.gray300, width: 1),
        boxShadow: SpiroDesignSystem.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          child: Center(
            child: Text(
              text,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.primaryBlue600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          // Stack cards vertically on smaller screens
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Batteries',
                      '15,420',
                      'In circulation',
                      '+2.1%',
                      true,
                      SpiroDesignSystem.primaryBlue600,
                      Icons.battery_full_outlined,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Avg Cycle Count',
                      '1,247',
                      'Per battery',
                      '+3.5%',
                      true,
                      SpiroDesignSystem.info600,
                      Icons.sync_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SpiroDesignSystem.space4),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Battery Health',
                      '89%',
                      'Overall condition',
                      '+1.2%',
                      true,
                      SpiroDesignSystem.success600,
                      Icons.favorite_outlined,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Replacement Rate',
                      '2.1%',
                      'Monthly',
                      '-0.9%',
                      false,
                      SpiroDesignSystem.warning600,
                      Icons.warning_outlined,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Horizontal scrollable layout for larger screens
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Total Batteries',
                    '15,420',
                    'In circulation',
                    '+2.1%',
                    true,
                    SpiroDesignSystem.primaryBlue600,
                    Icons.battery_full_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Avg Cycle Count',
                    '1,247',
                    'Per battery',
                    '+3.5%',
                    true,
                    SpiroDesignSystem.info600,
                    Icons.sync_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Battery Health',
                    '89%',
                    'Overall condition',
                    '+1.2%',
                    true,
                    SpiroDesignSystem.success600,
                    Icons.favorite_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Replacement Rate',
                    '2.1%',
                    'Monthly',
                    '-0.9%',
                    false,
                    SpiroDesignSystem.warning600,
                    Icons.warning_outlined,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    String subtitle,
    String trend,
    bool trendPositive,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        boxShadow: SpiroDesignSystem.shadowMd,
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space2),
          Text(
            title,
            style: SpiroDesignSystem.bodyL.copyWith(
              color: SpiroDesignSystem.gray700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space1),
          Text(
            count,
            style: SpiroDesignSystem.displayS.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space1),
          Row(
            children: [
              Text(
                subtitle,
                style: SpiroDesignSystem.caption.copyWith(
                  color: SpiroDesignSystem.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space2),
              Text(
                trend,
                style: SpiroDesignSystem.caption.copyWith(
                  color: trendPositive
                      ? SpiroDesignSystem.success600
                      : SpiroDesignSystem.danger600,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
        SizedBox(width: SpiroDesignSystem.space4),
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
                ChartData('Mon', 800, SpiroDesignSystem.primaryBlue600),
                ChartData('Tue', 600, SpiroDesignSystem.info600),
                ChartData('Wed', 400, SpiroDesignSystem.success600),
                ChartData('Thu', 550, SpiroDesignSystem.warning600),
                ChartData('Fri', 300, SpiroDesignSystem.danger600),
                ChartData('Sat', 200, SpiroDesignSystem.primaryBlue400),
                ChartData('Sun', 450, SpiroDesignSystem.info400),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
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
                ChartData('Nigeria', 1400, SpiroDesignSystem.primaryBlue600),
                ChartData('Ghana', 1050, SpiroDesignSystem.info600),
                ChartData('Kenya', 700, SpiroDesignSystem.success600),
                ChartData('Tanzania', 350, SpiroDesignSystem.warning600),
                ChartData('Uganda', 200, SpiroDesignSystem.danger600),
                ChartData('Rwanda', 150, SpiroDesignSystem.primaryBlue400),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        boxShadow: SpiroDesignSystem.shadowMd,
      ),
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: SpiroDesignSystem.titleL.copyWith(
              fontWeight: FontWeight.w700,
              color: SpiroDesignSystem.gray900,
            ),
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          chart,
        ],
      ),
    );
  }

  void _submitBatteryForm() {
    // Show success message after a short delay to simulate API call
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        _showSuccessMessage("Battery added successfully!");
        setState(() {
          _showBatteryForm = false;
          _clearBatteryForm();
        });
      }
    });
  }

  void _clearBatteryForm() {
    _oemController.clear();
    _serialNumberController.clear();
    _batteryTypeIdController.clear();
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: SpiroDesignSystem.success600,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: SpiroDesignSystem.red600,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
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
