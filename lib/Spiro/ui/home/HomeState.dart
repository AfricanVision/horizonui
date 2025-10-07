import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../data/internal/application/NavigatorType.dart';
import '../../data/internal/application/NotificationType.dart';
import '../../data/internal/application/TextType.dart';
import '../../data/internal/application/UserRegistration.dart';
import '../../data/internal/application/BatteryRequest.dart';
import '../../configs/Navigator.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import '../../utils/InputValidator.dart';
import '../../utils/Validators.dart';
import 'ConnectHome.dart';
import 'Home.dart';
import 'ViewHome.dart';

class HomeState extends State<Home> implements ConnectHome{

  ViewHome? _model;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _identificationController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _oemController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _batteryTypeIdController = TextEditingController();

  bool _isLoading = false;
  bool _showAgentForm = false;
  bool _showBatteryForm = false;
  bool _showDashboard = true;
  bool _showDataEntryView = false;
  String _selectedMenuItem = 'Agents';
  bool _showAgentFormsSection = true;
  bool _showAdminForm = false;
  String _selectedAdminForm = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewHome>.reactive(
        viewModelBuilder: () => ViewHome(context, this),
        onViewModelReady: (viewModel) => {
          _model = viewModel,
          _initialiseView()
        },
        builder: (context, viewModel, child) => WillPopScope(
            child: _mainBody(),
            onWillPop: () async {
              if (_model?.loadingEntry == null && _model?.errorEntry == null) {
                _closeApp();
              }
              return false;
            }
        ));
  }

  _initialiseView() async {
  }

  Widget _mainBody(){
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _showDashboard ? AppBar(
        backgroundColor: colorPrimaryDark,
        title: text("Spiro App", 18, TextType.Bold),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.add, color: colorMilkWhite),
            onSelected: (value) {
              setState(() {
                _showAgentForm = value == 'agent';
                _showBatteryForm = value == 'battery';
                _showDashboard = false;
                _showDataEntryView = false;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'agent',
                child: Row(
                  children: [
                    Icon(Icons.person_add, color: colorPrimary),
                    SizedBox(width: 8),
                    Text('Add Agent'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'battery',
                child: Row(
                  children: [
                    Icon(Icons.battery_std, color: colorPrimary),
                    SizedBox(width: 8),
                    Text('Add Battery'),
                  ],
                ),
              ),
            ],
          )
        ],
      ) : null,
      drawer: _showDashboard ? _buildSidebar() : null,
      body: _getCurrentView(),
    );
  }

  Widget _getCurrentView() {
    if (_showDataEntryView) return _buildDataEntryView();
    if (_showAgentForm) return _buildAgentManagementForm();
    if (_showBatteryForm) return _buildBatteryManagementForm();
    if (_showDashboard) return _buildDashboard();
    return _buildHomeContent();
  }

  Widget _buildSidebar() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: colorPrimaryDark,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                  SizedBox(height: 4),
                  textWithColor('Control Tower', 14, TextType.Regular, colorMilkWhite),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuSection('MAIN MENU', [
                    _buildMenuItem('Agents', Icons.people),
                    _buildMenuItem('Stations', Icons.ev_station),
                    _buildMenuItem('Batteries', Icons.battery_std),
                    _buildMenuItem('Analytics', Icons.analytics),
                    _buildMenuItem('Incidents', Icons.warning),
                    _buildMenuItem('Reports', Icons.assessment),
                    _buildMenuItem('Data Entry', Icons.data_usage),
                  ]),
                  Divider(height: 32),
                  _buildMenuSection('SYSTEM', [
                    _buildMenuItem('Settings', Icons.settings),
                  ]),
                ],
              ),
            ),
            Container(
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
            ),
          ],
        ),
      ),
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

  Widget _buildMenuItem(String title, IconData icon) {
    bool isSelected = _selectedMenuItem == title;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorPrimary : Colors.grey[700],
        size: 20,
      ),
      title: textWithColor(
          title,
          14,
          isSelected ? TextType.Bold : TextType.Regular,
          isSelected ? colorPrimary : Colors.grey[700]!
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedMenuItem = title;
          if (title == 'Data Entry') {
            _showDataEntryView = true;
            _showDashboard = false;
            _showAgentForm = false;
            _showBatteryForm = false;
          } else {
            _showDataEntryView = false;
            _showDashboard = true;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildHomeContent() {
    return Container(
      color: colorPrimaryLight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          text("Welcome to Spiro", 24, TextType.Bold),
          SizedBox(height: 20),
          text("Your all-in-one business solution", 16, TextType.Regular),
          SizedBox(height: 40),
          roundedCornerButton(
              "Go to Dashboard",
                  () => setState(() => _showDashboard = true)
          ),
        ],
      ),
    );
  }

  Widget _buildAgentManagementForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              backButtonWithAction(context, () {
                setState(() {
                  _showAgentForm = false;
                  _showDashboard = true;
                  _clearAgentForm();
                });
              }),
              SizedBox(width: 16),
              text("Agent Management", 20, TextType.Bold),
            ],
          ),
          SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Agents...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: roundedCornerButton(
              "+ Add Agent",
                  () {},
            ),
          ),
          SizedBox(height: 24),

          _buildAgentFormSection(),
        ],
      ),
    );
  }

  Widget _buildAgentFormSection() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text("Add New Agent", 20, TextType.Bold),
          SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'First Name *',
                      hintText: 'e.g., John',
                      controller: _firstnameController,
                    ),
                    SizedBox(height: 16),

                    _buildFormField(
                      label: 'Phone Number *',
                      hintText: 'e.g., +234-801-234-5678',
                      controller: _phonenumberController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),

                    _buildFormField(
                      label: 'National ID *',
                      hintText: 'e.g., NIN-12345678901',
                      controller: _identificationController,
                    ),
                    SizedBox(height: 16),

                    _buildTimestampField(),
                    SizedBox(height: 16),

                    _buildFormField(
                      label: 'Address *',
                      hintText: 'Full residential address...',
                      controller: _nationalityController,
                      maxLines: 3,
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
                      label: 'Last Name *',
                      hintText: 'e.g., Doe',
                      controller: _lastnameController,
                    ),
                    SizedBox(height: 16),

                    _buildFormField(
                      label: 'Email Address *',
                      hintText: 'e.g., john.doe@spiro.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),

                    _buildAgentIdDropdown(),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: roundedCornerButton(
              _isLoading ? "Registering..." : "Register Agent",
              _isLoading ? null : _submitAgentForm,
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

  Widget _buildTimestampField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Timestamp *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
          ),
        ),
        SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            setState(() {
              _dobController.text = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: textWithColor(
                      _dobController.text.isEmpty ? '07/10/2025 09:12' : _dobController.text,
                      14,
                      TextType.Regular,
                      _dobController.text.isEmpty ? Colors.grey[600]! : Colors.black87
                  ),
                ),
                Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgentIdDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Agent ID *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
          ),
        ),
        SizedBox(height: 6),
        GestureDetector(
          onTap: _showAgentIdSelection,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: textWithColor(
                      'Select agent ID',
                      14,
                      TextType.Regular,
                      Colors.grey[600]!
                  ),
                ),
                Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAgentIdSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: text("Select Agent ID", 16, TextType.Bold),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: text("A&T-90${index + 1}", 14, TextType.Regular),
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: isRequired ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))] : [],
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
            keyboardType: keyboardType,
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
      ],
    );
  }

  Widget _buildDataEntryView() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          _buildDataEntrySidebar(),
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

  Widget _buildDataEntrySidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: colorPrimaryDark,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithColor('Spiro App', 20, TextType.Bold, colorMilkWhite),
                SizedBox(height: 4),
                textWithColor('Control Tower', 14, TextType.Regular, colorMilkWhite),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuSection('AGENTS', [
                  _buildMenuItem('Stations', Icons.ev_station),
                  _buildMenuItem('Batteries', Icons.battery_std),
                  _buildMenuItem('Analytics', Icons.analytics),
                  _buildMenuItem('Incidents', Icons.warning),
                  _buildMenuItem('Reports', Icons.assessment),
                  _buildMenuItem('Data Entry', Icons.data_usage),
                ]),
                Divider(height: 32),
                _buildMenuSection('SETTINGS', [
                  _buildMenuItem('Settings', Icons.settings),
                ]),
              ],
            ),
          ),
          Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildDataEntryHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Data Entry', 28, TextType.Bold),
        SizedBox(height: 8),
        text('Input operational data', 16, TextType.Regular),
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

          if (_selectedAdminForm.isNotEmpty) _buildAdminFormCreationArea(),
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
        _buildFormCategory(
          'AGENT MANAGEMENT',
          [
            _buildFormItem('Incident Reports', 'Log Operational incident'),
            _buildFormItem('Battery History', 'Track Battery Lifecycle'),
            _buildFormItem('Power Events', 'Monitor power status'),
            _buildFormItem('Shift Records', 'Daily Shift Tracker'),
            _buildFormItem('Customer Details', 'View Customer Information'),
          ],
        ),
      ],
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

              // Right side - Content area
              Expanded(
                flex: 3,
                child: _selectedAdminForm.isNotEmpty
                    ? _buildAdminFormCreationArea()
                    : Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

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

  Widget _buildAgentManagementFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search agents...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            roundedCornerButton(
              "+ Add Agent",
                  () {},
            ),
          ],
        ),
        SizedBox(height: 24),

        Column(
          children: [
            _buildAgentListItem(
              name: 'John Doe',
              agentId: 'ACT-001',
              status: 'Active',
              phone: '+234-801-234-5678',
              nin: '12345678901',
              email: 'John.doe@spiro.com',
              station: 'Lagoa Central Hub',
              address: '15 Itoyi Street, Lagoa Island, Lagoa State',
              joined: '2024-01-15',
              updated: '2024-09-15 10:00:00',
            ),
            SizedBox(height: 16),
            _buildAgentListItem(
              name: 'Sarah Kim',
              agentId: 'ACT-002',
              status: 'Active',
              phone: '+234-802-345-6789',
              nin: '23456789012',
              email: 'Sarah.kim@spiro.com',
              station: 'Neja Business District',
              address: '23 Allen Avenue, Neja, Lagoa State',
              joined: '2024-02-01',
              updated: '2024-09-20 14:30:00',
            ),
            SizedBox(height: 16),
            _buildAgentListItem(
              name: 'Mike Johnson',
              agentId: 'ACT-003',
              status: 'On Leave',
              phone: '+234-803-456-7890',
              nin: '34567890123',
              email: 'Mike.johnson@spiro.com',
              station: 'Victoria Island Station',
              address: '78 Victoria Island, Lagoa State',
              joined: '2024-01-20',
              updated: '2024-09-25 09:15:00',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgentListItem({
    required String name,
    required String agentId,
    required String status,
    required String phone,
    required String nin,
    required String email,
    required String station,
    required String address,
    required String joined,
    required String updated,
  }) {
    Color statusColor = status == 'Active' ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        text(name, 16, TextType.Bold),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: statusColor),
                          ),
                          child: textWithColor(status, 12, TextType.SemiBold, statusColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    text(agentId, 14, TextType.Regular),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(phone, 14, TextType.Regular),
                SizedBox(height: 4),
                text('NIN: $nin', 14, TextType.Regular),
                SizedBox(height: 8),
                text(email, 14, TextType.Regular),
                SizedBox(height: 4),
                text(station, 14, TextType.Regular),
                SizedBox(height: 8),
                text('Address: $address', 14, TextType.Regular),
                SizedBox(height: 8),
                Row(
                  children: [
                    text('Joined: $joined', 12, TextType.Regular),
                    SizedBox(width: 16),
                    text('Updated: $updated', 12, TextType.Regular),
                  ],
                ),
              ],
            ),
          ),
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

  Widget _buildFormItem(String title, String description) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(title, 16, TextType.SemiBold),
          SizedBox(height: 4),
          textWithColor(description, 14, TextType.Regular, Colors.grey[600]!),
        ],
      ),
    );
  }

  Widget _buildBatteryManagementForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              backButtonWithAction(context, () {
                setState(() {
                  _showBatteryForm = false;
                  _showDashboard = true;
                  _clearBatteryForm();
                });
              }),
              SizedBox(width: 16),
              text("Battery Management", 20, TextType.Bold),
            ],
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search batteries...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          SizedBox(height: 24),
          _buildBatteryFormSection(),
        ],
      ),
    );
  }

  Widget _buildBatteryFormSection() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text("Add New Battery", 20, TextType.Bold),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildBatteryLeftColumn(),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildBatteryRightColumn(),
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

  Widget _buildBatteryLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          label: 'OEM *',
          hintText: 'A7246AX1Axxxxxxxx',
          controller: _oemController,
        ),
        SizedBox(height: 16),
        _buildFormField(
          label: 'Serial Number *',
          hintText: 'EKON/RW/UNI/07100',
          controller: _serialNumberController,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildBatteryRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          label: 'Battery Type ID *',
          hintText: '',
          controller: _batteryTypeIdController,
        ),
      ],
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleAndDescription('Dashboard', 'Control tower overview'),
          SizedBox(height: 24),
          _buildStatsGrid(),
          SizedBox(height: 24),
          _buildAfricaMapSection(),
          SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildMainContentColumn()),
              SizedBox(width: 16),
              Expanded(flex: 1, child: _buildSideContentColumn()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentColumn() {
    return Column(
      children: [
        _buildChartsRow(),
        SizedBox(height: 24),
        _buildSwapsTrendSection(),
      ],
    );
  }

  Widget _buildSideContentColumn() {
    return Column(
      children: [
        _buildAgentsSection(),
        SizedBox(height: 24),
        _buildActiveAlerts(),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard('Active Agents', '1229', '19 total • +12% vs last week', '+12%', true),
        _buildStatCard('Swaps Today', '999', '99,999 total • Target: 100,000', '+69%', true),
        _buildStatCard('Active Issues', '20', 'Across all stations critical', null, false),
        _buildStatCard('Downtime %', '2.1%', '97.9% uptime good', null, true),
        _buildStatCard('Power Usage', '12.4 MW', '14-day avg: 11.8 MW', '+3.2%', true),
      ],
    );
  }

  Widget _buildStatCard(String title, String mainValue, String subtitle, String? trend, bool? trendPositive) {
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
          text(mainValue, 24, TextType.Bold),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWithColor(subtitle, 12, TextType.Regular, Colors.grey[600]!),
              if (trend != null) ...[
                SizedBox(height: 4),
                textWithColor(trend, 12, TextType.SemiBold, trendPositive == true ? Colors.green : Colors.red),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAfricaMapSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(value: true, onChanged: (v) {}),
              SizedBox(width: 8),
              text('Africa Operations Map', 16, TextType.Bold),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 48, color: Colors.blue[300]),
                      SizedBox(height: 8),
                      textWithColor('Africa Operations Map', 16, TextType.Bold, Colors.blue[600]!),
                      SizedBox(height: 8),
                      textWithColor('1920px+ Desktop View', 12, TextType.Regular, Colors.grey[600]!),
                    ],
                  ),
                ),
                Positioned(
                  top: 16, left: 16,
                  child: _buildMapInfoPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapInfoPanel() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text('Africa Overview', 14, TextType.Bold),
          SizedBox(height: 8),
          text('Countries: 8', 12, TextType.Regular),
          text('Total Agents: 4972', 12, TextType.Regular),
          text('Total Swaps: 92,231', 12, TextType.Regular),
          SizedBox(height: 8),
          text('Status', 12, TextType.Regular),
          Row(
            children: [
              _buildStatusIndicator(Colors.green, 'Active'),
              SizedBox(width: 12),
              _buildStatusIndicator(Colors.blueAccent, 'Warning'),
              SizedBox(width: 12),
              _buildStatusIndicator(Colors.blue, 'Maintenance'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, color: color, margin: EdgeInsets.only(right: 4)),
        text(label, 12, TextType.Regular),
      ],
    );
  }

  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildDowntimeChart()),
        SizedBox(width: 16),
        Expanded(child: _buildPowerConsumptionChart()),
      ],
    );
  }

  Widget _buildDowntimeChart() {
    return _buildChartContainer(
      'Downtime %',
      Container(
        height: 200,
        child: Column(
          children: [
            Row(children: [Container(width: 40, child: text('100', 10, TextType.Regular)), Expanded(child: SizedBox())]),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        text('75', 10, TextType.Regular),
                        text('50', 10, TextType.Regular),
                        text('25', 10, TextType.Regular),
                        text('0', 10, TextType.Regular),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildChartBar(60, Colors.blue, 'Station A'),
                        _buildChartBar(85, Colors.orange, 'Station B'),
                        _buildChartBar(45, Colors.red, 'Station D'),
                        _buildChartBar(70, Colors.blue, 'Station E'),
                        _buildChartBar(55, Colors.orange, 'Station F'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                text('A', 10, TextType.Regular),
                text('B', 10, TextType.Regular),
                text('D', 10, TextType.Regular),
                text('E', 10, TextType.Regular),
                text('F', 10, TextType.Regular),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Planned'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.orange, 'Unplanned'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Uptime %'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerConsumptionChart() {
    return _buildChartContainer(
      'Power Consumption (14-day)',
      Container(
        height: 200,
        child: Column(
          children: [
            Row(children: [Container(width: 40, child: text('1000', 10, TextType.Regular)), Expanded(child: SizedBox())]),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        text('750', 10, TextType.Regular),
                        text('500', 10, TextType.Regular),
                        text('250', 10, TextType.Regular),
                        text('0', 10, TextType.Regular),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLineChartPoint(800),
                          _buildLineChartPoint(650),
                          _buildLineChartPoint(720),
                          _buildLineChartPoint(580),
                          _buildLineChartPoint(690),
                          _buildLineChartPoint(750),
                          _buildLineChartPoint(820),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                text('Sep 25', 10, TextType.Regular),
                text('Sep 27', 10, TextType.Regular),
                text('Sep 29', 10, TextType.Regular),
                text('Oct 1', 10, TextType.Regular),
                text('Oct 3', 10, TextType.Regular),
                text('Oct 5', 10, TextType.Regular),
                text('Oct 7', 10, TextType.Regular),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'WiFi Uptime %'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.orange, 'kWh'),
              ],
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

  Widget _buildChartBar(double height, Color color, String label) {
    return Column(
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }

  Widget _buildLineChartPoint(double height) {
    return Column(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
        Container(width: 2, height: height / 4, color: Colors.blue),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        SizedBox(width: 4),
        textWithColor(text, 12, TextType.Regular, colorPrimaryDark),
      ],
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
              Expanded(child: _buildBatteryCyclesChart()),
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

  Widget _buildBatteryCyclesChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Battery Cycles', 14, TextType.SemiBold),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBar(1400, Colors.blue, 'Nigeria'),
              _buildBar(1050, Colors.orange, 'Ghana'),
              _buildBar(700, Colors.orange, 'Kenya'),
              _buildBar(350, Colors.orange, 'Tanzania'),
              _buildBar(200, Colors.orange, 'Uganda'),
              _buildBar(150, Colors.orange, 'Rwanda'),
            ],
          ),
        ),
        SizedBox(height: 8),
        textWithColor('Cycle Count vs Health %', 12, TextType.Regular, Colors.grey[600]!),
      ],
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

  Widget _buildAgentsSection() {
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
          Padding(
            padding: EdgeInsets.all(16),
            child: text('On-Shift Agents', 16, TextType.Bold),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: text('ID', 12, TextType.Bold)),
                Expanded(flex: 3, child: text('Name', 12, TextType.Bold)),
                Expanded(flex: 3, child: text('Station', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Status', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Shift', 12, TextType.Bold)),
              ],
            ),
          ),
          _buildAgentRow('AGQ01', 'John Doe', 'Accra Central', 'online', 'Morning'),
          _buildAgentRow('AGQ02', 'Sarah Wilson', 'Lagos Island', 'busy', 'Morning'),
          _buildAgentRow('AGQ03', 'Michael Chen', 'Nairobi CBD', 'online', 'Morning'),
          _buildAgentRow('AGQ04', 'Emma Johnson', 'Kumasi Hub', 'break', 'Morning'),
          _buildAgentRow('AGQ05', 'David Brown', 'Abuja Central', 'busy', 'Afternoon'),
          _buildAgentRow('AGQ06', 'Lisa Zhang', 'Mombasa Port', 'online', 'Afternoon'),
          _buildAgentRow('AGQ07', 'James Miller', 'Tamale Station', 'offline', 'Morning'),
          _buildAgentRow('AGQ08', 'Anna Davis', 'Cape Coast', 'online', 'Evening'),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[300]!))),
            child: textWithAlignAndColor(
                'Do not sell or share my personal info',
                10,
                TextType.Regular,
                TextAlign.center,
                Colors.grey[600]!
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentRow(String id, String name, String station, String status, String shift) {
    Color statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(flex: 2, child: text(id, 12, TextType.Regular)),
          Expanded(flex: 3, child: text(name, 12, TextType.Regular)),
          Expanded(flex: 3, child: text(station, 12, TextType.Regular)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                SizedBox(width: 4),
                text(status, 12, TextType.Regular),
              ],
            ),
          ),
          Expanded(flex: 2, child: text(shift, 12, TextType.Regular)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online': return Colors.green;
      case 'busy': return Colors.orange;
      case 'break': return Colors.blue;
      case 'offline': return Colors.grey;
      default: return Colors.grey;
    }
  }

  Widget _buildActiveAlerts() {
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
          Padding(padding: EdgeInsets.all(16), child: text('Active Alerts', 16, TextType.Bold)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: textWithColor(
                '3 critical alerts require immediate attention',
                12,
                TextType.SemiBold,
                Colors.red
            ),
          ),
          SizedBox(height: 16),
          _buildAlertItem('Power Consumption High', 'Station power usage exceeds normal parameters', 'Power - Kumasi Hub • Ghana', '45 minutes ago', Colors.red),
          SizedBox(height: 12),
          _buildAlertItem('Connectivity Issues', 'Intermittent WiFi connectivity reported', 'Connectivity - Tamale Station • Ghana', '1 hour ago', Colors.orange),
          SizedBox(height: 12),
          _buildAlertItem('System Maintenance Required', 'Scheduled maintenance overdue by 3 days', 'System - Abuja Central • Nigeria', '2 hours ago', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String description, String location, String time, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: textWithColor(title, 12, TextType.Bold, color)),
              Icon(Icons.help_outline, size: 16, color: color),
            ],
          ),
          SizedBox(height: 4),
          text(description, 11, TextType.Regular),
          SizedBox(height: 4),
          textWithColor(location, 10, TextType.Regular, Colors.grey[600]!),
          SizedBox(height: 4),
          textWithColor(time, 10, TextType.Regular, Colors.grey[600]!),
        ],
      ),
    );
  }

  Future<void> _submitAgentForm() async {
    if (_firstnameController.text.isEmpty || _lastnameController.text.isEmpty || _identificationController.text.isEmpty || _phonenumberController.text.isEmpty || _emailController.text.isEmpty) {
      _showErrorNotification("Please fill in all required fields");
      return;
    }

    if (emailRegex(_emailController.text)) {
      _showErrorNotification("Please enter a valid email address");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userData = UserRegistration(
        firstname: _firstnameController.text,
        middlename: _middlenameController.text,
        lastname: _lastnameController.text,
        dob: _dobController.text,
        nationality: _nationalityController.text,
        identification: _identificationController.text,
        phonenumber: _phonenumberController.text,
        email: _emailController.text,
        statusId: "b8641bcd-07d5-4919-b459-5a081dee449b",
        createdBy: "admin",
      );

      final success = await _model!.sendUserRegistration(userData);
      if (success) {
        _showSuccessNotification("Agent registered successfully!");
      } else {
        throw Exception('Failed to register agent');
      }
    } catch (error) {
      _showErrorNotification("Failed to register agent: $error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitBatteryForm() async {
    if (_oemController.text.isEmpty || _serialNumberController.text.isEmpty || _batteryTypeIdController.text.isEmpty) {
      _showErrorNotification("Please fill in all required fields");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final batteryData = BatteryRequest(
        id: "status-id-here",
        oem: _oemController.text,
        serialNumber: _serialNumberController.text,
        batteryTypeId: _batteryTypeIdController.text,
        createdBy: "admin",
      );

      final success = await _model!.createBattery(batteryData);
      if (success) {
        _showSuccessNotification("Battery added successfully!");
      } else {
        throw Exception('Failed to add battery');
      }
    } catch (error) {
      _showErrorNotification("Failed to add battery: $error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearAgentForm() {
    _firstnameController.clear();
    _middlenameController.clear();
    _lastnameController.clear();
    _dobController.clear();
    _nationalityController.clear();
    _identificationController.clear();
    _phonenumberController.clear();
    _emailController.clear();
  }

  void _clearBatteryForm() {
    _oemController.clear();
    _serialNumberController.clear();
    _batteryTypeIdController.clear();
  }

  void _showSuccessNotification(String message) {
    _model!.showApplicationNotification(
      NotificationType.success,
      "Success",
      message,
      true,
      true,
      null,
          () {
        setState(() {
          _showAgentForm = false;
          _showBatteryForm = false;
          _showDashboard = true;
          _clearAgentForm();
          _clearBatteryForm();
        });
      },
    );
  }

  void _showErrorNotification(String message) {
    _model!.showApplicationNotification(
      NotificationType.error,
      "Error",
      message,
      true,
      true,
      null,
          () {},
    );
  }

  void _closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _identificationController.dispose();
    _phonenumberController.dispose();
    _emailController.dispose();
    _oemController.dispose();
    _serialNumberController.dispose();
    _batteryTypeIdController.dispose();
    super.dispose();
  }
}