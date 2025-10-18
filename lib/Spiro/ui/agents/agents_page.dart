import 'package:flutter/material.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../../utils/Colors.dart';
import 'package:horizonui/Spiro/data/internal/application/Agents.dart';

class AgentsPage extends StatefulWidget {
  const AgentsPage({super.key});

  @override
  State<AgentsPage> createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {
  // Controllers for agent management
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _identificationController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Edit form controllers
  String _currentEditingAgentId = '';
  final TextEditingController _editFirstnameController = TextEditingController();
  final TextEditingController _editMiddlenameController = TextEditingController();
  final TextEditingController _editLastnameController = TextEditingController();
  final TextEditingController _editDobController = TextEditingController();
  final TextEditingController _editIdentificationController = TextEditingController();
  final TextEditingController _editPhonenumberController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();

  bool _isLoading = false;
  bool _showAddForm = false;
  bool _showEditForm = false;
  List<Agent> _agents = [];
  List<Agent> _filteredAgents = [];
  final TextEditingController _searchController = TextEditingController();

  // Nationality dropdown values
  String _selectedNationality = 'Kenya';
  String _editSelectedNationality = 'Kenya';

  // Status values - hardcoded to ACTIVE and INACTIVE
  String _selectedStatus = 'ACTIVE';
  String _editSelectedStatus = 'ACTIVE';

  final List<String> _eastAfricaCountries = [
    'Kenya', 'Uganda', 'Tanzania', 'Rwanda', 'Burundi',
    'Ethiopia', 'Somalia', 'South Sudan', 'Sudan', 'Eritrea',
    'Djibouti'
  ];

  final List<String> _westAfricaCountries = [
    'Nigeria', 'Ghana', 'Ivory Coast', 'Senegal', 'Mali',
    'Burkina Faso', 'Guinea', 'Benin', 'Niger', 'Togo',
    'Sierra Leone', 'Liberia', 'Mauritania', 'Gambia',
    'Guinea-Bissau', 'Cape Verde'
  ];

  // final AgentService _agentService = AgentService();

  @override
  void initState() {
    super.initState();
    _loadAgents();
    _searchController.addListener(_filterAgents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    _dobController.dispose();
    _identificationController.dispose();
    _phonenumberController.dispose();
    _emailController.dispose();
    _editFirstnameController.dispose();
    _editMiddlenameController.dispose();
    _editLastnameController.dispose();
    _editDobController.dispose();
    _editIdentificationController.dispose();
    _editPhonenumberController.dispose();
    _editEmailController.dispose();
    super.dispose();
  }

  Future<void> _loadAgents() async {
    setState(() => _isLoading = true);
    try {
      // final agents = await _agentService.getAgents();
      setState(() {
        // _agents = agents;
        // _filteredAgents = agents;
      });
    } catch (e) {
      _showErrorNotification('Failed to load agents: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterAgents() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredAgents = _agents);
    } else {
      setState(() {
        _filteredAgents = _agents.where((agent) =>
        _getAgentFullName(agent).toLowerCase().contains(query) ||
            agent.identification.toLowerCase().contains(query) ||
            agent.email.toLowerCase().contains(query) ||
            agent.phonenumber.toLowerCase().contains(query) ||
            agent.nationality.toLowerCase().contains(query)
        ).toList();
      });
    }
  }

  String _getAgentFullName(Agent agent) {
    return '${agent.firstname} ${agent.middlename.isNotEmpty ? '${agent.middlename} ' : ''}${agent.lastname}';
  }

  String _getAgentDisplayId(Agent agent) {
    return 'A${agent.identification.substring(agent.identification.length - 6)}';
  }

  String _getAgentDisplayStatus(Agent agent) {
    // Convert status ID to display name
    if (agent.statusId == 'b8641bcd-07d5-4919-b459-5a081dee449b') {
      return 'ACTIVE';
    } else {
      return 'INACTIVE';
    }
  }

  Future<void> _selectDate(BuildContext context, bool isEditForm) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: shawnblue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      if (isEditForm) {
        setState(() {
          _editDobController.text = formattedDate;
        });
      } else {
        setState(() {
          _dobController.text = formattedDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAgentsHeader(),
            SizedBox(height: 16),
            _buildSearchAndAddSection(),
            SizedBox(height: 16),
            if (_showAddForm) _buildAddAgentForm(),
            if (_showEditForm) _buildEditAgentForm(),
            SizedBox(height: 16),
            if (_isLoading) _buildLoadingIndicator(),
            if (!_isLoading) _buildAgentsTable(),
            SizedBox(height: 24),
            _buildAgentsPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(color: colorPrimary),
      ),
    );
  }

  Widget _buildAgentsHeader() {
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
                  text('Agents', 28, TextType.Bold),
                  SizedBox(height: 8),
                  text('Workforce management', 16, TextType.Regular),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Divider(height: 1, color: Colors.grey[300]),
        SizedBox(height: 16),
        text('All Agents (${_filteredAgents.length})', 20, TextType.Bold),
      ],
    );
  }

  Widget _buildSearchAndAddSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Agents by name, ID, email, or phone...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showAddForm = true;
              _showEditForm = false;
              _currentEditingAgentId = '';
              _clearAgentForm();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[600],
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white, size: 20),
              SizedBox(width: 8),
              textWithColor('Add Agent', 14, TextType.SemiBold, Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddAgentForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text("Add New Agent", 16, TextType.Bold),
                  text("Fill in the agent details below", 12, TextType.Regular),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _showAddForm = false;
                    _clearAgentForm();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'First Name *',
                      hintText: 'e.g., Cynthia',
                      controller: _firstnameController,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Middle Name',
                      hintText: 'e.g., Situma',
                      controller: _middlenameController,
                      isRequired: false,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Phone Number *',
                      hintText: 'e.g., 0712345678',
                      controller: _phonenumberController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'National ID *',
                      hintText: 'e.g., ID123456',
                      controller: _identificationController,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'Last Name *',
                      hintText: 'e.g., Fake',
                      controller: _lastnameController,
                    ),
                    SizedBox(height: 12),
                    _buildDatePickerField(
                      label: 'Date of Birth *',
                      controller: _dobController,
                      isEditForm: false,
                    ),
                    SizedBox(height: 12),
                    _buildNationalityDropdown(
                      label: 'Nationality *',
                      selectedValue: _selectedNationality,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedNationality = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    _buildFormField(
                      label: 'Email Address *',
                      hintText: 'e.g., CFake@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12),
                    _buildStatusRadioButtons(
                      label: 'Status *',
                      selectedValue: _selectedStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAddForm = false;
                    _clearAgentForm();
                  });
                },
                child: textWithColor('Cancel', 14, TextType.Regular, Colors.grey[600]!),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: _submitAgentForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                ),
                child: textWithColor(
                  _isLoading ? "Registering..." : "Register Agent",
                  14,
                  TextType.SemiBold,
                  Colors.white,
                ),
              ),
            ],
          ),
          if (_isLoading) ...[
            SizedBox(height: 16),
            Center(child: CircularProgressIndicator(color: colorPrimary)),
          ],
        ],
      ),
    );
  }

  Widget _buildEditAgentForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text("Edit Agent Details", 16, TextType.Bold),
                  if (_currentEditingAgentId.isNotEmpty)
                    text("Editing Agent ID: $_currentEditingAgentId", 12, TextType.Regular),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _showEditForm = false;
                    _currentEditingAgentId = '';
                    _clearEditForm();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEditFormField(
                      label: 'First Name',
                      hintText: 'Enter first name',
                      controller: _editFirstnameController,
                    ),
                    SizedBox(height: 12),
                    _buildEditFormField(
                      label: 'Middle Name',
                      hintText: 'Enter middle name',
                      controller: _editMiddlenameController,
                    ),
                    SizedBox(height: 12),
                    _buildEditFormField(
                      label: 'Phone Number',
                      hintText: 'Enter phone number',
                      controller: _editPhonenumberController,
                    ),
                    SizedBox(height: 12),
                    _buildEditFormField(
                      label: 'National ID',
                      hintText: 'Enter national ID',
                      controller: _editIdentificationController,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEditFormField(
                      label: 'Last Name',
                      hintText: 'Enter last name',
                      controller: _editLastnameController,
                    ),
                    SizedBox(height: 12),
                    _buildDatePickerField(
                      label: 'Date of Birth',
                      controller: _editDobController,
                      isEditForm: true,
                    ),
                    SizedBox(height: 12),
                    _buildNationalityDropdown(
                      label: 'Nationality',
                      selectedValue: _editSelectedNationality,
                      onChanged: (String? newValue) {
                        setState(() {
                          _editSelectedNationality = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    _buildEditFormField(
                      label: 'Email',
                      hintText: 'Enter email address',
                      controller: _editEmailController,
                    ),
                    SizedBox(height: 12),
                    _buildStatusRadioButtons(
                      label: 'Status',
                      selectedValue: _editSelectedStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          _editSelectedStatus = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showEditForm = false;
                    _currentEditingAgentId = '';
                    _clearEditForm();
                  });
                },
                child: textWithColor('Cancel', 14, TextType.Regular, Colors.grey[600]!),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: _saveAgentEdits,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                ),
                child: textWithColor('Save Changes', 14, TextType.SemiBold, Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgentsTable() {
    if (_filteredAgents.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            text('No agents found', 16, TextType.Bold),
            SizedBox(height: 8),
            text('Add your first agent to get started', 14, TextType.Regular),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: text('Agent ID', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Full Name', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Phone', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Email', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Nationality', 12, TextType.Bold)),
                Expanded(flex: 2, child: text('Status', 12, TextType.Bold)),
                Expanded(flex: 1, child: text('Actions', 12, TextType.Bold)),
              ],
            ),
          ),
          ..._filteredAgents.map((agent) => _buildAgentTableRow(agent)).toList(),
        ],
      ),
    );
  }

  Widget _buildAgentTableRow(Agent agent) {
    Color statusColor = _getStatusColor(_getAgentDisplayStatus(agent));
    String statusIcon = _getAgentStatusIcon(_getAgentDisplayStatus(agent));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: text(_getAgentDisplayId(agent), 12, TextType.Regular)),
          Expanded(flex: 2, child: text(_getAgentFullName(agent), 12, TextType.Regular)),
          Expanded(flex: 2, child: text(agent.phonenumber, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(agent.email, 12, TextType.Regular)),
          Expanded(flex: 2, child: text(agent.nationality, 12, TextType.Regular)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                text(statusIcon, 12, TextType.Regular),
                SizedBox(width: 4),
                textWithColor(_getAgentDisplayStatus(agent), 12, TextType.Regular, statusColor),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _buildCardIconButton(Icons.edit, 'Edit', Colors.blue, () {
                  _editAgent(agent);
                }),
                SizedBox(width: 8),
                _buildCardIconButton(Icons.delete, 'Delete', Colors.red, () {
                  _showDeleteConfirmation(_getAgentFullName(agent), _getAgentDisplayId(agent));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentsPagination() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text('Showing ${_filteredAgents.length} of ${_agents.length} agents', 12, TextType.Regular),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: textWithColor('Previous', 12, TextType.Regular, Colors.blue),
              ),
              SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: textWithColor('Next', 12, TextType.Regular, Colors.blue),
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildEditFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(label, 14, TextType.SemiBold),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[600]),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: InputBorder.none,
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required TextEditingController controller,
    required bool isEditForm,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(label, 14, TextType.SemiBold),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'YYYY-MM-DD',
              hintStyle: TextStyle(color: Colors.grey[600]),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: InputBorder.none,
              isDense: true,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                onPressed: () => _selectDate(context, isEditForm),
              ),
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildNationalityDropdown({
    required String label,
    required String selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(label, 14, TextType.SemiBold),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: '',
                  enabled: false,
                  child: text('Select Nationality', 14, TextType.Regular),
                ),
                // East Africa Countries
                DropdownMenuItem(
                  value: 'EAST_AFRICA_HEADER',
                  enabled: false,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: text('East Africa', 14, TextType.Bold),
                  ),
                ),
                ..._eastAfricaCountries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: text(country, 14, TextType.Regular),
                    ),
                  );
                }).toList(),
                // West Africa Countries
                DropdownMenuItem(
                  value: 'WEST_AFRICA_HEADER',
                  enabled: false,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: text('West Africa', 14, TextType.Bold),
                  ),
                ),
                ..._westAfricaCountries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: text(country, 14, TextType.Regular),
                    ),
                  );
                }).toList(),
              ],
              onChanged: (String? newValue) {
                if (newValue != null &&
                    newValue != 'EAST_AFRICA_HEADER' &&
                    newValue != 'WEST_AFRICA_HEADER') {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRadioButtons({
    required String label,
    required String selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text(label, 14, TextType.SemiBold),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: 'ACTIVE',
                    groupValue: selectedValue,
                    onChanged: onChanged,
                    activeColor: shawnblue,
                  ),
                  text('ACTIVE', 14, TextType.Regular),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: 'INACTIVE',
                    groupValue: selectedValue,
                    onChanged: onChanged,
                    activeColor: shawnblue,
                  ),
                  text('INACTIVE', 14, TextType.Regular),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardIconButton(IconData icon, String tooltip, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.all(4),
        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  // Agent management methods
  void _editAgent(Agent agent) {
    setState(() {
      _showAddForm = false;
      _showEditForm = true;
      _currentEditingAgentId = agent.id!;
      _editSelectedNationality = agent.nationality;
      _editSelectedStatus = _getAgentDisplayStatus(agent);
      _populateEditFormWithAgentData(agent);
    });
  }

  void _populateEditFormWithAgentData(Agent agent) {
    _editFirstnameController.text = agent.firstname;
    _editMiddlenameController.text = agent.middlename;
    _editLastnameController.text = agent.lastname;
    _editDobController.text = agent.dob;
    _editIdentificationController.text = agent.identification;
    _editPhonenumberController.text = agent.phonenumber;
    _editEmailController.text = agent.email;
  }

  Future<void> _saveAgentEdits() async {
    setState(() => _isLoading = true);
    try {
      // Convert status name back to ID for API
      String statusId = _editSelectedStatus == 'ACTIVE'
          ? 'b8641bcd-07d5-4919-b459-5a081dee449b'
          : 'INACTIVE'; // You'll need to replace 'INACTIVE' with actual inactive status ID

      final updatedAgent = Agent(
        id: _currentEditingAgentId,
        firstname: _editFirstnameController.text,
        middlename: _editMiddlenameController.text,
        lastname: _editLastnameController.text,
        dob: _editDobController.text,
        nationality: _editSelectedNationality,
        identification: _editIdentificationController.text,
        phonenumber: _editPhonenumberController.text,
        email: _editEmailController.text,
        statusId: statusId,
        createdBy: 'admin',
      );

      // await _agentService.updateAgent(_currentEditingAgentId, updatedAgent);
      // _showSuccessNotification("Agent details updated successfully!");
      // await _loadAgents();

      setState(() {
        _showEditForm = false;
        _currentEditingAgentId = '';
        _clearEditForm();
      });
    } catch (e) {
      _showErrorNotification("Failed to update agent: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitAgentForm() async {
    if (_firstnameController.text.isEmpty ||
        _lastnameController.text.isEmpty ||
        _identificationController.text.isEmpty ||
        _phonenumberController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _dobController.text.isEmpty) {
      _showErrorNotification("Please fill in all required fields");
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Convert status name to ID for API
      String statusId = _selectedStatus == 'ACTIVE'
          ? 'b8641bcd-07d5-4919-b459-5a081dee449b'
          : 'INACTIVE'; // You'll need to replace 'INACTIVE' with actual inactive status ID

      final newAgent = Agent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstname: _firstnameController.text,
        middlename: _middlenameController.text,
        lastname: _lastnameController.text,
        dob: _dobController.text,
        nationality: _selectedNationality,
        identification: _identificationController.text,
        phonenumber: _phonenumberController.text,
        email: _emailController.text,
        statusId: statusId,
        createdBy: 'admin',
      );

      // await _agentService.addAgent(newAgent);
      // _showSuccessNotification("Agent registered successfully!");
      // await _loadAgents();

      setState(() {
        _showAddForm = false;
        _clearAgentForm();
      });
    } catch (e) {
      _showErrorNotification("Failed to register agent: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDeleteConfirmation(String name, String agentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: text("Delete Agent", 16, TextType.Bold),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text("Are you sure you want to delete this agent?", 14, TextType.Regular),
              SizedBox(height: 8),
              text("Name: $name", 14, TextType.SemiBold),
              text("Agent ID: $agentId", 14, TextType.Regular),
              SizedBox(height: 8),
              text("This action cannot be undone.", 14, TextType.Regular),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: textWithColor('Cancel', 14, TextType.Regular, Colors.grey[600]!),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add delete functionality here
              },
              child: textWithColor('Delete', 14, TextType.SemiBold, Colors.red),
            ),
          ],
        );
      },
    );
  }

  void _clearAgentForm() {
    _firstnameController.clear();
    _middlenameController.clear();
    _lastnameController.clear();
    _dobController.clear();
    _identificationController.clear();
    _phonenumberController.clear();
    _emailController.clear();
    _selectedNationality = 'Kenya';
    _selectedStatus = 'ACTIVE';
  }

  void _clearEditForm() {
    _editFirstnameController.clear();
    _editMiddlenameController.clear();
    _editLastnameController.clear();
    _editDobController.clear();
    _editIdentificationController.clear();
    _editPhonenumberController.clear();
    _editEmailController.clear();
    _editSelectedNationality = 'Kenya';
    _editSelectedStatus = 'ACTIVE';
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE': return Colors.green;
      case 'INACTIVE': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getAgentStatusIcon(String status) {
    switch (status) {
      case 'ACTIVE': return '●';
      case 'INACTIVE': return '○';
      default: return '○';
    }
  }
}