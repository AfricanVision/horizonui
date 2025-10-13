import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';

class DataEntryPage extends StatefulWidget {
  const DataEntryPage({super.key});

  @override
  State<DataEntryPage> createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  bool _showAgentFormsSection = true;
  bool _showAdminForm = false;
  String _selectedAgentForm = '';
  String _selectedAdminForm = '';

  // Controllers for agent forms
  final TextEditingController _incidentTitleController = TextEditingController();
  final TextEditingController _incidentDescriptionController = TextEditingController();
  final TextEditingController _incidentLocationController = TextEditingController();
  final TextEditingController _batterySerialController = TextEditingController();
  final TextEditingController _batteryStatusController = TextEditingController();
  final TextEditingController _powerEventController = TextEditingController();
  final TextEditingController _shiftNotesController = TextEditingController();
  final TextEditingController _customerSearchController = TextEditingController();

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
                  _buildDataEntryHeader(),
                  SizedBox(height: 32),
                  _buildDataEntryPortalCard(),
                  SizedBox(height: 32),
                  _buildAgentFormsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 20),
      title: text(title, 14, TextType.Regular),
      onTap: () {
        print('Selected: $title');
      },
    );
  }

  Widget _buildDataEntryHeader() {
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
                  text('Data Entry', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text('Input operational data', 16, TextType.Regular),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataEntryPortalCard() {
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
          text('Data Entry Portal', 20, TextType.Bold),
          SizedBox(height: 8),
          text('Input and manage operational data', 14, TextType.Regular),
        ],
      ),
    );
  }

  Widget _buildAgentFormsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAgentFormsSection = true;
                        _showAdminForm = false;
                        _selectedAdminForm = '';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _showAgentFormsSection ? colorPrimaryDark : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: textWithColor(
                          'Agent Forms',
                          14,
                          TextType.SemiBold,
                          _showAgentFormsSection ? colorMilkWhite : Colors.grey[700]!,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAgentFormsSection = false;
                        _showAdminForm = true;
                        _selectedAdminForm = '';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _showAdminForm ? colorPrimaryDark : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: textWithColor(
                          'Admin Forms',
                          14,
                          TextType.SemiBold,
                          _showAdminForm ? colorMilkWhite : Colors.grey[700]!,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          if (_showAgentFormsSection) _buildAgentFormContent(),
          if (_showAdminForm) _buildAdminFormContent(),
        ],
      ),
    );
  }

  Widget _buildAgentFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(24),
          child: text('Agent Forms', 18, TextType.Bold),
        ),
        Divider(height: 1),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildFormCategory(
                  'AGENT OPERATIONS',
                  [
                    _buildAgentFormBox('Incident Reports', 'Log operational incidents'),
                    _buildAgentFormBox('Battery History', 'Track battery lifecycle'),
                    _buildAgentFormBox('Power Events', 'Monitor power status'),
                    _buildAgentFormBox('Shift Records', 'Daily shift tracker'),
                    _buildAgentFormBox('Customer Details', 'View customer information'),
                  ],
                ),
              ),
              Container(
                width: 1,
                margin: EdgeInsets.symmetric(vertical: 16),
                color: Colors.grey[300],
              ),
              Expanded(
                flex: 3,
                child: _selectedAgentForm.isNotEmpty
                    ? _buildAgentFormCreationArea()
                    : Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description, size: 48, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      text('Select an agent form to get started', 16, TextType.Regular),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAgentFormCreationArea() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(_selectedAgentForm, 20, TextType.Bold),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedAgentForm = '';
                    _clearAgentFormFields();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          if (_selectedAgentForm == 'Incident Reports') _buildIncidentReportForm(),
          if (_selectedAgentForm == 'Battery History') _buildBatteryHistoryForm(),
          if (_selectedAgentForm == 'Power Events') _buildPowerEventsForm(),
          if (_selectedAgentForm == 'Shift Records') _buildShiftRecordsForm(),
          if (_selectedAgentForm == 'Customer Details') _buildCustomerDetailsForm(),
        ],
      ),
    );
  }

  Widget _buildIncidentReportForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Report an Incident', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Incident Title *',
          hintText: 'e.g., Battery Overheating',
          controller: _incidentTitleController,
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Description *',
          hintText: 'Describe the incident in detail...',
          controller: _incidentDescriptionController,
          maxLines: 3,
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Location *',
          hintText: 'e.g., Station A, Lagos',
          controller: _incidentLocationController,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Submit Incident Report",
                () {
              _submitIncidentReport();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryHistoryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Battery History Tracking', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Battery Serial Number *',
          hintText: 'e.g., BAT-123456',
          controller: _batterySerialController,
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Current Status *',
          hintText: 'e.g., In Service, Maintenance, Retired',
          controller: _batteryStatusController,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Update Battery History",
                () {
              _updateBatteryHistory();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPowerEventsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Power Event Log', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Event Description *',
          hintText: 'e.g., Power Outage, Voltage Spike',
          controller: _powerEventController,
          maxLines: 2,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Log Power Event",
                () {
              _logPowerEvent();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShiftRecordsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Shift Record Entry', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Shift Notes *',
          hintText: 'Enter shift summary and notes...',
          controller: _shiftNotesController,
          maxLines: 4,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Save Shift Record",
                () {
              _saveShiftRecord();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Customer Information', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Search Customer *',
          hintText: 'Enter customer name or ID',
          controller: _customerSearchController,
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Search Customer",
                () {
              _searchCustomer();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAgentFormBox(String title, String description) {
    bool isSelected = _selectedAgentForm == title;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAgentForm = title;
          });
        },
        child: Container(
          width: 280,
          height: 90,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? colorPrimaryLight : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? colorPrimary : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text(title, 16, TextType.SemiBold),
              SizedBox(height: 4),
              textWithColor(description, 14, TextType.Regular, Colors.grey[600]!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(24),
          child: text('Admin Forms', 18, TextType.Bold),
        ),
        Divider(height: 1),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildFormCategory(
                  'ADMIN CONFIGURATION',
                  [
                    _buildAdminFormBox('Country Management', 'Manage country data'),
                    _buildAdminFormBox('Station Management', 'Configure stations'),
                    _buildAdminFormBox('Agent Management', 'Manage agent profiles'),
                    _buildAdminFormBox('Shift Management', 'Configure shift schedules'),
                    _buildAdminFormBox('Customer Management', 'Manage customer information'),
                  ],
                ),
              ),
              Container(
                width: 1,
                margin: EdgeInsets.symmetric(vertical: 16),
                color: Colors.grey[300],
              ),
              Expanded(
                flex: 3,
                child: _selectedAdminForm.isNotEmpty
                    ? _buildAdminFormCreationArea()
                    : Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminFormBox(String title, String description) {
    bool isSelected = _selectedAdminForm == title;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAdminForm = title;
          });
        },
        child: Container(
          width: 280,
          height: 90,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? colorPrimaryLight : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? colorPrimary : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text(title, 16, TextType.SemiBold),
              SizedBox(height: 4),
              textWithColor(description, 14, TextType.Regular, Colors.grey[600]!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminFormCreationArea() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(_selectedAdminForm, 20, TextType.Bold),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedAdminForm = '';
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          if (_selectedAdminForm == 'Country Management') _buildCountryManagementForm(),
          if (_selectedAdminForm == 'Station Management') _buildStationManagementForm(),
          if (_selectedAdminForm == 'Agent Management') _buildAgentManagementFormContent(),
          if (_selectedAdminForm == 'Shift Management') _buildShiftManagementForm(),
          if (_selectedAdminForm == 'Customer Management') _buildCustomerManagementForm(),
        ],
      ),
    );
  }

  Widget _buildCountryManagementForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Add New Country', 18, TextType.Bold),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: 'Country Name *',
                    hintText: 'e.g., Nigeria',
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 16),
                  _buildFormField(
                    label: 'Country Code *',
                    hintText: 'e.g., NG',
                    controller: TextEditingController(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: 'Currency *',
                    hintText: 'e.g., NGN',
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 16),
                  _buildFormField(
                    label: 'Timezone *',
                    hintText: 'e.g., WAT',
                    controller: TextEditingController(),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Add Country",
                () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStationManagementForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Add New Station', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Station Name *',
          hintText: 'e.g., Lagos Main Station',
          controller: TextEditingController(),
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Location *',
          hintText: 'Full address...',
          controller: TextEditingController(),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Add Station",
                () {},
          ),
        ),
      ],
    );
  }

  Widget _buildAgentManagementFormContent() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text('Agent Management', 20, TextType.Bold),
          SizedBox(height: 20),
          text('Agent management functionality would go here', 16, TextType.Regular),
        ],
      ),
    );
  }

  Widget _buildShiftManagementForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Configure Shift', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Shift Name *',
          hintText: 'e.g., Morning Shift',
          controller: TextEditingController(),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Save Shift",
                () {},
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerManagementForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Add Customer', 18, TextType.Bold),
        SizedBox(height: 20),
        _buildFormField(
          label: 'Customer Name *',
          hintText: 'e.g., ABC Corporation',
          controller: TextEditingController(),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: roundedCornerButton(
            "Add Customer",
                () {},
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    int maxLines = 1,
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
            maxLines: maxLines,
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
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFormCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: text(title, 14, TextType.Bold),
        ),
        ...items,
      ],
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

  void _submitIncidentReport() {
    print('Submitting incident report:');
    print('Title: ${_incidentTitleController.text}');
    print('Description: ${_incidentDescriptionController.text}');
    print('Location: ${_incidentLocationController.text}');
    _showSuccessNotification("Incident report submitted successfully!");
    _clearAgentFormFields();
  }

  void _updateBatteryHistory() {
    print('Updating battery history:');
    print('Serial: ${_batterySerialController.text}');
    print('Status: ${_batteryStatusController.text}');
    _showSuccessNotification("Battery history updated!");
    _clearAgentFormFields();
  }

  void _logPowerEvent() {
    print('Logging power event: ${_powerEventController.text}');
    _showSuccessNotification("Power event logged!");
    _clearAgentFormFields();
  }

  void _saveShiftRecord() {
    print('Saving shift record: ${_shiftNotesController.text}');
    _showSuccessNotification("Shift record saved!");
    _clearAgentFormFields();
  }

  void _searchCustomer() {
    print('Searching customer: ${_customerSearchController.text}');
    _showSuccessNotification("Customer search completed!");
    _clearAgentFormFields();
  }

  void _clearAgentFormFields() {
    _incidentTitleController.clear();
    _incidentDescriptionController.clear();
    _incidentLocationController.clear();
    _batterySerialController.clear();
    _batteryStatusController.clear();
    _powerEventController.clear();
    _shiftNotesController.clear();
    _customerSearchController.clear();
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

  @override
  void dispose() {
    _incidentTitleController.dispose();
    _incidentDescriptionController.dispose();
    _incidentLocationController.dispose();
    _batterySerialController.dispose();
    _batteryStatusController.dispose();
    _powerEventController.dispose();
    _shiftNotesController.dispose();
    _customerSearchController.dispose();
    super.dispose();
  }
}