import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/DesignSystem.dart';

class IncidentsPage extends StatefulWidget {
  const IncidentsPage({super.key});

  @override
  State<IncidentsPage> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends State<IncidentsPage> {
  String _selectedStatusFilter = 'All Statuses';
  bool _showNewIncidentForm = false;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  String _selectedIncidentType = 'Power Outage';
  String _selectedPriority = 'Critical';
  String _selectedStatus = 'Pending';
  String? _selectedStation;
  final _assignedToController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _vehicleIdController = TextEditingController();
  final _batteryIdController = TextEditingController();
  final _detailedDescriptionController = TextEditingController();
  final _reporterContactController = TextEditingController();
  final _timestampController = TextEditingController();
  final _reportedByController = TextEditingController();

  // Photo management
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Mock data will be removed - will come from backend
  List<String> _availableStations = [];
  List<Map<String, dynamic>> _incidents = [];
  bool _isLoadingStations = false;
  bool _isLoadingIncidents = false;

  @override
  void initState() {
    super.initState();
    _loadStations();
    _loadIncidents();
    // Initialize timestamp with current date/time
    _timestampController.text = _formatDateTime(DateTime.now());
    // Initialize reported by with current user
    _reportedByController.text = 'Current User';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _assignedToController.dispose();
    _customerNameController.dispose();
    _vehicleIdController.dispose();
    _batteryIdController.dispose();
    _detailedDescriptionController.dispose();
    _reporterContactController.dispose();
    _timestampController.dispose();
    _reportedByController.dispose();
    super.dispose();
  }

  Future<void> _loadStations() async {
    setState(() {
      _isLoadingStations = true;
    });

    try {
      // Simulate API call - will be replaced with actual backend call
      await Future.delayed(Duration(milliseconds: 500));

      // Mock data for testing - remove when backend is ready
      if (mounted) {
        setState(() {
          _availableStations = [
            'Accra Central',
            'Lagos Island',
            'Nairobi CBD',
            'Kumasi Hub',
            'Tamale Station',
          ];
          _isLoadingStations = false;
        });
      }
    } catch (e) {
      // Use debugPrint instead of print for development debugging
      debugPrint('Error loading stations: $e');
      if (mounted) {
        setState(() {
          _availableStations = [];
          _isLoadingStations = false;
        });
      }
    }
  }

  Future<void> _loadIncidents() async {
    setState(() {
      _isLoadingIncidents = true;
    });

    try {
      // Simulate API call - will be replaced with actual backend call
      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _incidents = [];
          _isLoadingIncidents = false;
        });
      }
    } catch (e) {
      // Use debugPrint instead of print for development debugging
      debugPrint('Error loading incidents: $e');
      if (mounted) {
        setState(() {
          _incidents = [];
          _isLoadingIncidents = false;
        });
      }
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
            if (_showNewIncidentForm) ...[
              _buildNewIncidentForm(),
              SizedBox(height: SpiroDesignSystem.space6),
            ],
            _buildIncidentsTable(),
          ],
        ),
      ),
    );
  }

  // Get statistics from data
  int get _totalIncidents => _incidents.length;
  int get _openIncidents =>
      _incidents.where((i) => i['status'] == 'Pending').length;
  int get _inProgressIncidents =>
      _incidents.where((i) => i['status'] == 'In Progress').length;
  int get _criticalIncidents =>
      _incidents.where((i) => i['priority'] == 'Critical').length;
  int get _resolvedIncidents =>
      _incidents.where((i) => i['status'] == 'Resolved').length;

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Incident Management',
                style: SpiroDesignSystem.displayM.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space2),
              Text(
                'Monitor and manage system incidents',
                style: SpiroDesignSystem.bodyL.copyWith(
                  color: SpiroDesignSystem.gray600,
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          // Action buttons in a separate row to prevent overflow
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: _buildHeaderButton(
                  onPressed: () {},
                  icon: Icons.file_download_outlined,
                  label: 'Export',
                  isPrimary: false,
                ),
              ),
              SizedBox(width: SpiroDesignSystem.space3),
              Flexible(
                child: _buildHeaderButton(
                  onPressed: () {
                    setState(() {
                      _showNewIncidentForm = !_showNewIncidentForm;
                    });
                  },
                  icon: Icons.add_circle_outline,
                  label: 'New Incident',
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
                      'Total',
                      '$_totalIncidents',
                      'incidents',
                      SpiroDesignSystem.primaryBlue600,
                      Icons.analytics_outlined,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Open',
                      '$_openIncidents',
                      'incidents',
                      SpiroDesignSystem.danger600,
                      Icons.folder_open_outlined,
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
                      '$_inProgressIncidents',
                      'incidents',
                      SpiroDesignSystem.warning600,
                      Icons.sync_outlined,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Critical',
                      '$_criticalIncidents',
                      'incidents',
                      SpiroDesignSystem.red600,
                      Icons.warning_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SpiroDesignSystem.space4),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Resolved',
                      '$_resolvedIncidents',
                      'incidents',
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
                  constraints: BoxConstraints(minWidth: 180, maxWidth: 220),
                  child: _buildStatCard(
                    'Total',
                    '$_totalIncidents',
                    'incidents',
                    SpiroDesignSystem.primaryBlue600,
                    Icons.analytics_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 180, maxWidth: 220),
                  child: _buildStatCard(
                    'Open',
                    '$_openIncidents',
                    'incidents',
                    SpiroDesignSystem.danger600,
                    Icons.folder_open_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 180, maxWidth: 220),
                  child: _buildStatCard(
                    'In Progress',
                    '$_inProgressIncidents',
                    'incidents',
                    SpiroDesignSystem.warning600,
                    Icons.sync_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 180, maxWidth: 220),
                  child: _buildStatCard(
                    'Critical',
                    '$_criticalIncidents',
                    'incidents',
                    SpiroDesignSystem.red600,
                    Icons.warning_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 180, maxWidth: 220),
                  child: _buildStatCard(
                    'Resolved',
                    '$_resolvedIncidents',
                    'incidents',
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
            items: ['All Statuses', 'Pending', 'In Progress', 'Resolved'],
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

  Widget _buildNewIncidentForm() {
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
                gradient: SpiroDesignSystem.dangerGradient,
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
                boxShadow: SpiroDesignSystem.shadowCritical,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.report_problem_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: SpiroDesignSystem.space3),
                  Text(
                    'Report New Incident',
                    style: SpiroDesignSystem.titleM.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showNewIncidentForm = false;
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

            // Priority Level and Incident Type
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Priority Level',
                    _buildFormDropdown(
                      value: _selectedPriority,
                      items: ['Critical', 'High', 'Medium', 'Low'],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPriority = newValue!;
                        });
                      },
                      icon: Icons.priority_high_outlined,
                    ),
                    isRequired: true,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                Expanded(
                  child: _buildFormField(
                    'Incident Type',
                    _buildFormDropdown(
                      value: _selectedIncidentType,
                      items: [
                        'Power Outage',
                        'Battery Fault',
                        'Equipment Malfunction',
                        'Network Issue',
                        'Safety Incident',
                        'Other',
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedIncidentType = newValue!;
                        });
                      },
                      icon: Icons.report_outlined,
                    ),
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Station and Status
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Station',
                    _buildFormDropdown(
                      value: _selectedStation,
                      items: _availableStations,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStation = newValue;
                        });
                      },
                      icon: Icons.location_on_outlined,
                      hint: _isLoadingStations
                          ? 'Loading stations...'
                          : 'Select station',
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
                      items: ['Pending', 'In Progress', 'Resolved'],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                      },
                      icon: Icons.info_outline,
                    ),
                    isRequired: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Assign To (removed "Optional")
            _buildFormField(
              'Assign To',
              _buildTextFormField(
                controller: _assignedToController,
                hintText: 'Assign to agent',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please assign this incident to an agent';
                  }
                  return null;
                },
              ),
              isRequired: true,
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Customer Name
            _buildFormField(
              'Customer Name',
              _buildTextFormField(
                controller: _customerNameController,
                hintText: 'Enter customer name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Customer name is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              isRequired: true,
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Vehicle ID and Battery ID
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Vehicle ID',
                    _buildTextFormField(
                      controller: _vehicleIdController,
                      hintText: 'Enter vehicle ID',
                      icon: Icons.directions_car_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vehicle ID is required';
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
                    'Battery ID',
                    _buildTextFormField(
                      controller: _batteryIdController,
                      hintText: 'Enter battery ID',
                      icon: Icons.battery_charging_full_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Battery ID is required';
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

            // Timestamp and Reported By - with interactive date/time picker
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    'Timestamp',
                    GestureDetector(
                      onTap: _selectDateTime,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SpiroDesignSystem.radiusMd,
                          ),
                          boxShadow: SpiroDesignSystem.shadowSm,
                        ),
                        child: TextFormField(
                          controller: _timestampController,
                          enabled: false,
                          style: TextStyle(
                            color: SpiroDesignSystem.gray900,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Select date and time',
                            hintStyle: TextStyle(
                              color: SpiroDesignSystem.gray500,
                              fontSize: 14,
                            ),
                            prefixIcon: Container(
                              padding: EdgeInsets.all(SpiroDesignSystem.space3),
                              child: Icon(
                                Icons.access_time,
                                color: SpiroDesignSystem.primaryBlue600,
                                size: 20,
                              ),
                            ),
                            suffixIcon: Container(
                              padding: EdgeInsets.all(SpiroDesignSystem.space3),
                              child: Icon(
                                Icons.calendar_today,
                                color: SpiroDesignSystem.primaryBlue600,
                                size: 20,
                              ),
                            ),
                            filled: true,
                            fillColor: SpiroDesignSystem.gray50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                SpiroDesignSystem.radiusMd,
                              ),
                              borderSide: BorderSide(
                                color: SpiroDesignSystem.gray300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                SpiroDesignSystem.radiusMd,
                              ),
                              borderSide: BorderSide(
                                color: SpiroDesignSystem.gray300,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                SpiroDesignSystem.radiusMd,
                              ),
                              borderSide: BorderSide(
                                color: SpiroDesignSystem.primaryBlue300,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                Expanded(
                  child: _buildFormField(
                    'Reported By',
                    _buildTextFormField(
                      controller: _reportedByController,
                      hintText: 'Enter reporter name',
                      icon: Icons.person,
                      enabled: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Reporter name is required';
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

            // Detailed Description
            _buildFormField(
              'Detailed Description',
              _buildTextFormField(
                controller: _detailedDescriptionController,
                hintText:
                    'Provide a detailed description of the incident including:\n• What happened\n• When it occurred\n• Impact on operations\n• Any immediate actions taken',
                icon: Icons.description_outlined,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Detailed description is required';
                  }
                  if (value.trim().length < 20) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
              ),
              isRequired: true,
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Photo Upload Section
            _buildFormField(
              'Attachments (Photos/Documents)',
              _buildPhotoUploadSection(),
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Reporter Contact
            _buildFormField(
              'Reporter Contact',
              _buildTextFormField(
                controller: _reporterContactController,
                hintText: 'Phone or email for follow-up',
                icon: Icons.contact_phone_outlined,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value) &&
                        !RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value)) {
                      return 'Enter a valid email or phone number';
                    }
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: SpiroDesignSystem.space3),

            // Form buttons
            Row(
              children: [
                Expanded(
                  child: outlinedButton(() {
                    setState(() {
                      _showNewIncidentForm = false;
                    });
                  }, 'Cancel'),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                Expanded(
                  child: raisedButton('Report Incident', () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedStation == null) {
                        _showErrorMessage('Please select a station');
                        return;
                      }

                      setState(() {
                        _showNewIncidentForm = false;
                      });

                      _showSuccessMessage('Incident reported successfully!');
                      _clearForm();
                      _loadIncidents();
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
    int maxLines = 1,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        boxShadow: SpiroDesignSystem.shadowSm,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        style: TextStyle(color: SpiroDesignSystem.gray900, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: SpiroDesignSystem.gray500, fontSize: 14),
          prefixIcon: Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space3),
            child: Icon(
              icon,
              color: enabled
                  ? SpiroDesignSystem.primaryBlue600
                  : SpiroDesignSystem.gray400,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: enabled
              ? SpiroDesignSystem.gray50
              : SpiroDesignSystem.gray100,
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

  Widget _buildFormDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        boxShadow: SpiroDesignSystem.shadowSm,
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        style: TextStyle(color: SpiroDesignSystem.gray900, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
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
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget raisedButton(String text, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SpiroDesignSystem.space3,
        horizontal: SpiroDesignSystem.space6,
      ),
      decoration: BoxDecoration(
        gradient: SpiroDesignSystem.primaryGradient,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        boxShadow: SpiroDesignSystem.shadowPrimary,
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
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget outlinedButton(VoidCallback onPressed, String text) {
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

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: SpiroDesignSystem.gray300),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickImageFromGallery,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: SpiroDesignSystem.primaryBlue600,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Upload Files',
                            style: TextStyle(
                              color: SpiroDesignSystem.primaryBlue600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: SpiroDesignSystem.gray300),
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickImageFromCamera,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: SpiroDesignSystem.primaryBlue600,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Take Photo',
                            style: TextStyle(
                              color: SpiroDesignSystem.primaryBlue600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_selectedImages.isNotEmpty) ...[
          SizedBox(height: 16),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: SpiroDesignSystem.red600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((image) => File(image.path)));
        });
      }
    } catch (e) {
      _showErrorMessage('Failed to pick images from gallery');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      _showErrorMessage('Failed to take photo');
    }
  }

  Widget _buildIncidentsTable() {
    List<Map<String, dynamic>> filteredIncidents = _getFilteredIncidents();

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
                text('Incident History', 20, TextType.Bold),
                Spacer(),
                text(
                  '${filteredIncidents.length} incidents',
                  14,
                  TextType.Regular,
                ),
              ],
            ),
          ),
          if (_isLoadingIncidents)
            Padding(
              padding: EdgeInsets.all(SpiroDesignSystem.space8),
              child: Center(
                child: CircularProgressIndicator(
                  color: SpiroDesignSystem.primaryBlue600,
                ),
              ),
            )
          else if (filteredIncidents.isEmpty)
            Padding(
              padding: EdgeInsets.all(SpiroDesignSystem.space8),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: SpiroDesignSystem.gray400,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    text('No incidents found', 16, TextType.Bold),
                    SizedBox(height: SpiroDesignSystem.space2),
                    text(
                      'Incident data will be loaded from the backend.',
                      14,
                      TextType.Regular,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredIncidents() {
    return _incidents.where((incident) {
      bool matchesStatus =
          _selectedStatusFilter == 'All Statuses' ||
          incident['status'] == _selectedStatusFilter;

      return matchesStatus;
    }).toList();
  }

  void _clearForm() {
    _assignedToController.clear();
    _customerNameController.clear();
    _vehicleIdController.clear();
    _batteryIdController.clear();
    _detailedDescriptionController.clear();
    _reporterContactController.clear();
    _timestampController.clear();
    _reportedByController.clear();
    setState(() {
      _selectedIncidentType = 'Power Outage';
      _selectedPriority = 'Critical';
      _selectedStatus = 'Pending';
      _selectedStation = null;
      _selectedImages.clear();
    });
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

  Future<void> _selectDateTime() async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: SpiroDesignSystem.primaryBlue600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: SpiroDesignSystem.gray900,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: SpiroDesignSystem.primaryBlue600,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: SpiroDesignSystem.gray900,
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _timestampController.text = _formatDateTime(selectedDateTime);
        });
      }
    }
  }
}
