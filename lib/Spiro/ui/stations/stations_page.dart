import 'package:flutter/material.dart';

import '../../utils/DesignSystem.dart';

class StationsPage extends StatefulWidget {
  const StationsPage({super.key});

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  String _selectedStatusFilter = 'All Statuses';
  bool _isLoading = false;
  bool _showAddForm = false;

  // Form controllers for Add Station
  final TextEditingController _stationNameController = TextEditingController();
  final TextEditingController _attendantController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();
  final TextEditingController _updatedByController = TextEditingController();

  String _selectedCountry = 'Kenya';
  String _selectedStatus = 'Active';

  List<Map<String, dynamic>> _stations = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _stationNameController.dispose();
    _attendantController.dispose();
    _createdByController.dispose();
    _updatedByController.dispose();
    super.dispose();
  }

  void _clearStationForm() {
    _stationNameController.clear();
    _attendantController.clear();
    _createdByController.clear();
    _updatedByController.clear();
    setState(() {
      _selectedCountry = 'Kenya';
      _selectedStatus = 'Active';
    });
  }

  void _addStation() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _stations.add({
          'id':
              'ST${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'name': _stationNameController.text,
          'country': _selectedCountry,
          'attendant': _attendantController.text,
          'status': _selectedStatus,
          'createdBy': _createdByController.text,
          'updatedBy': _updatedByController.text,
          'timestamp': DateTime.now(),
        });
        _showAddForm = false;
      });
      _clearStationForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Station added successfully!'),
          backgroundColor: SpiroDesignSystem.success600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          ),
        ),
      );
    }
  }

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
            _buildFiltersSection(),
            SizedBox(height: SpiroDesignSystem.space6),
            if (_showAddForm) _buildAddStationForm(),
            if (_showAddForm) SizedBox(height: SpiroDesignSystem.space6),
            _buildStationsTable(),
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
                'Station Operations',
                style: SpiroDesignSystem.displayM.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space2),
              Text(
                'Monitor and manage battery swap stations',
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
                  onPressed: () {},
                  icon: Icons.file_download_outlined,
                  label: 'Export Data',
                  isPrimary: false,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Flexible(
                child: _buildHeaderButton(
                  onPressed: () {
                    setState(() {
                      _showAddForm = !_showAddForm;
                    });
                  },
                  icon: Icons.add_circle_outline,
                  label: 'Add Station',
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
                      'Total Stations',
                      '6',
                      'active',
                      SpiroDesignSystem.primaryBlue600,
                      Icons.location_city_outlined,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Open Issues',
                      '2',
                      'pending',
                      SpiroDesignSystem.danger600,
                      Icons.error_outline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SpiroDesignSystem.space4),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'In Progress',
                      '2',
                      'checking',
                      SpiroDesignSystem.warning600,
                      Icons.sync_outlined,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Resolved',
                      '2',
                      'completed',
                      SpiroDesignSystem.success600,
                      Icons.check_circle_outline,
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
                    'Total Stations',
                    '6',
                    'active',
                    SpiroDesignSystem.primaryBlue600,
                    Icons.location_city_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Open Issues',
                    '2',
                    'pending',
                    SpiroDesignSystem.danger600,
                    Icons.error_outline,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'In Progress',
                    '2',
                    'checking',
                    SpiroDesignSystem.warning600,
                    Icons.sync_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Resolved',
                    '2',
                    'completed',
                    SpiroDesignSystem.success600,
                    Icons.check_circle_outline,
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
          Text(
            subtitle,
            style: SpiroDesignSystem.caption.copyWith(
              color: SpiroDesignSystem.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        boxShadow: SpiroDesignSystem.shadowMd,
      ),
      child: Row(
        children: [
          _buildFilterDropdown(
            value: _selectedStatusFilter,
            items: ['All Statuses', 'Open', 'In Progress', 'Resolved'],
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatusFilter = newValue!;
              });
            },
            icon: Icons.filter_list_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SpiroDesignSystem.gray50,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        border: Border.all(
          color: SpiroDesignSystem.gray300.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: SpiroDesignSystem.shadowSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: SpiroDesignSystem.primaryBlue600, size: 18),
          SizedBox(width: SpiroDesignSystem.space2),
          DropdownButton<String>(
            value: value,
            underline: SizedBox(),
            style: TextStyle(
              color: SpiroDesignSystem.gray900,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAddStationForm() {
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
            // Header with gradient like incident form
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
                    Icons.add_location_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: SpiroDesignSystem.space3),
                  Text(
                    'Add New Station',
                    style: SpiroDesignSystem.titleM.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAddForm = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SpiroDesignSystem.space4),

            // Station Name and Country in Row
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Station Name',
                    _buildTextFormField(
                      controller: _stationNameController,
                      hintText: 'Enter station name',
                      icon: Icons.location_city_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Station name is required';
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
                    'Country',
                    _buildFormDropdown(
                      value: _selectedCountry,
                      items: ['Kenya', 'Uganda', 'Rwanda', 'Tanzania'],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountry = newValue!;
                        });
                      },
                      icon: Icons.public,
                    ),
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Attendant and Created By in Row
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Attendant Name',
                    _buildTextFormField(
                      controller: _attendantController,
                      hintText: 'Enter attendant name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Attendant name is required';
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
                    'Status',
                    _buildFormDropdown(
                      value: _selectedStatus,
                      items: ['Active', 'Inactive'],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                      },
                      icon: Icons.power_settings_new_outlined,
                    ),
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Created By and Updated By in Row
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Created By',
                    _buildTextFormField(
                      controller: _createdByController,
                      hintText: 'Enter your name',
                      icon: Icons.create_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Created by is required';
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
                    'Updated By',
                    _buildTextFormField(
                      controller: _updatedByController,
                      hintText: 'Enter updater\'s name',
                      icon: Icons.update_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Updated by is required';
                        }
                        return null;
                      },
                    ),
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: SpiroDesignSystem.space6),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _clearStationForm();
                    setState(() {
                      _showAddForm = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpiroDesignSystem.space5,
                      vertical: SpiroDesignSystem.space3,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: SpiroDesignSystem.bodyL.copyWith(
                      color: SpiroDesignSystem.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space3),
                Container(
                  decoration: BoxDecoration(
                    gradient: SpiroDesignSystem.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                    boxShadow: SpiroDesignSystem.shadowPrimary,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _addStation();
                      },
                      borderRadius: BorderRadius.circular(
                        SpiroDesignSystem.radiusMd,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpiroDesignSystem.space5,
                          vertical: SpiroDesignSystem.space3,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: SpiroDesignSystem.space2),
                            Text(
                              'Add Station',
                              style: SpiroDesignSystem.bodyL.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget field, {bool isRequired = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: SpiroDesignSystem.bodyL.copyWith(
              fontWeight: FontWeight.w600,
              color: SpiroDesignSystem.gray900,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: SpiroDesignSystem.danger600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: SpiroDesignSystem.space2),
        field,
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
        color: SpiroDesignSystem.gray50,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        border: Border.all(
          color: SpiroDesignSystem.gray300.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: SpiroDesignSystem.bodyL.copyWith(
          color: SpiroDesignSystem.gray900,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: SpiroDesignSystem.bodyL.copyWith(
            color: SpiroDesignSystem.gray500,
          ),
          prefixIcon: Icon(
            icon,
            color: SpiroDesignSystem.primaryBlue600,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: SpiroDesignSystem.space4,
            vertical: SpiroDesignSystem.space3,
          ),
        ),
      ),
    );
  }

  Widget _buildFormDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    String? hint,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpiroDesignSystem.space4,
        vertical: SpiroDesignSystem.space2,
      ),
      decoration: BoxDecoration(
        color: SpiroDesignSystem.gray50,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        border: Border.all(
          color: SpiroDesignSystem.gray300.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: SpiroDesignSystem.primaryBlue600, size: 20),
          SizedBox(width: SpiroDesignSystem.space3),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                hint: hint != null
                    ? Text(
                        hint,
                        style: SpiroDesignSystem.bodyL.copyWith(
                          color: SpiroDesignSystem.gray500,
                        ),
                      )
                    : null,
                style: SpiroDesignSystem.bodyL.copyWith(
                  color: SpiroDesignSystem.gray900,
                  fontWeight: FontWeight.w500,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: SpiroDesignSystem.gray600,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        boxShadow: SpiroDesignSystem.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(SpiroDesignSystem.space6),
            child: Row(
              children: [
                Text(
                  'Station Operations',
                  style: SpiroDesignSystem.titleL.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SpiroDesignSystem.gray900,
                  ),
                ),
                Spacer(),
                Text(
                  '${_stations.length} stations',
                  style: SpiroDesignSystem.bodyL.copyWith(
                    color: SpiroDesignSystem.gray600,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(SpiroDesignSystem.space8),
              child: Center(
                child: CircularProgressIndicator(
                  color: SpiroDesignSystem.primaryBlue600,
                ),
              ),
            )
          else ...[
            _buildTableHeader(),
            ..._stations.map((station) {
              return _buildStationRow(
                id: station['id'],
                station: station['name'],
                issueType: 'Battery Mismatch', // Placeholder
                status: station['status'],
                priority: 'High', // Placeholder
                owner: station['attendant'],
                time: station['timestamp'].toString().substring(
                  0,
                  10,
                ), // Placeholder
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      decoration: BoxDecoration(
        color: SpiroDesignSystem.gray50,
        border: Border(
          bottom: BorderSide(color: SpiroDesignSystem.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: _buildHeaderText('ID')),
          Expanded(flex: 2, child: _buildHeaderText('Station')),
          Expanded(flex: 2, child: _buildHeaderText('Issue Type')),
          Expanded(flex: 2, child: _buildHeaderText('Status')),
          Expanded(flex: 2, child: _buildHeaderText('Priority')),
          Expanded(flex: 2, child: _buildHeaderText('Assigned To')),
          Expanded(flex: 2, child: _buildHeaderText('Time')),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: SpiroDesignSystem.bodyL.copyWith(
        fontWeight: FontWeight.w600,
        color: SpiroDesignSystem.gray700,
      ),
    );
  }

  Widget _buildStationRow({
    required String id,
    required String station,
    required String issueType,
    required String status,
    required String priority,
    required String owner,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: SpiroDesignSystem.gray100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              id,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray900,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              station,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              issueType,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray700,
              ),
            ),
          ),
          Expanded(flex: 2, child: _buildStatusBadge(status)),
          Expanded(flex: 2, child: _buildPriorityBadge(priority)),
          Expanded(
            flex: 2,
            child: Text(
              owner,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'active':
        color = SpiroDesignSystem.success600;
        bgColor = SpiroDesignSystem.success50;
        break;
      case 'inactive':
        color = SpiroDesignSystem.gray600;
        bgColor = SpiroDesignSystem.gray50;
        break;
      default:
        color = SpiroDesignSystem.gray600;
        bgColor = SpiroDesignSystem.gray50;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpiroDesignSystem.space3,
        vertical: SpiroDesignSystem.space2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusSm),
      ),
      child: Text(
        status,
        style: SpiroDesignSystem.bodyS.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = SpiroDesignSystem.red600;
        break;
      case 'medium':
        color = SpiroDesignSystem.warning600;
        break;
      case 'low':
        color = SpiroDesignSystem.success600;
        break;
      default:
        color = SpiroDesignSystem.gray600;
    }

    return Text(
      priority,
      style: SpiroDesignSystem.bodyL.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
