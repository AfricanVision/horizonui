import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/data/internal/application/Agents.dart';
import 'package:horizonui/Spiro/ui/agents/agent_service.dart';
import 'package:intl/intl.dart';

import '../../utils/DesignSystem.dart';

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
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Edit form controllers
  String _currentEditingAgentId = '';
  final TextEditingController _editFirstnameController =
      TextEditingController();
  final TextEditingController _editMiddlenameController =
      TextEditingController();
  final TextEditingController _editLastnameController = TextEditingController();
  final TextEditingController _editDobController = TextEditingController();
  final TextEditingController _editNationalityController =
      TextEditingController();
  final TextEditingController _editIdentificationController =
      TextEditingController();
  final TextEditingController _editPhonenumberController =
      TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();

  bool _isLoading = false;
  bool _showAddForm = false;
  bool _showEditForm = false;
  List<Agent> _agents = [];
  List<Agent> _filteredAgents = [];
  final TextEditingController _searchController = TextEditingController();

  final AgentService _agentService = AgentService();

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
    _nationalityController.dispose();
    _identificationController.dispose();
    _phonenumberController.dispose();
    _emailController.dispose();
    _editFirstnameController.dispose();
    _editMiddlenameController.dispose();
    _editLastnameController.dispose();
    _editDobController.dispose();
    _editNationalityController.dispose();
    _editIdentificationController.dispose();
    _editPhonenumberController.dispose();
    _editEmailController.dispose();
    super.dispose();
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

  void _clearEditForm() {
    _editFirstnameController.clear();
    _editMiddlenameController.clear();
    _editLastnameController.clear();
    _editDobController.clear();
    _editNationalityController.clear();
    _editIdentificationController.clear();
    _editPhonenumberController.clear();
    _editEmailController.clear();
  }

  Future<void> _loadAgents() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final agents = await _agentService.getAgents();
      if (!mounted) return;
      setState(() {
        _agents = agents;
        _filteredAgents = agents;
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorNotification('Failed to load agents: $e');
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _filterAgents() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredAgents = _agents);
    } else {
      setState(() {
        _filteredAgents = _agents
            .where(
              (agent) =>
                  _getAgentFullName(agent).toLowerCase().contains(query) ||
                  agent.identification.toLowerCase().contains(query) ||
                  agent.email.toLowerCase().contains(query) ||
                  agent.phonenumber.toLowerCase().contains(query) ||
                  agent.nationality.toLowerCase().contains(query),
            )
            .toList();
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
    switch (agent.statusId) {
      case 'b8641bcd-07d5-4919-b459-5a081dee449b':
        return 'online';
      // Add more status IDs as needed
      default:
        return 'offline';
    }
  }

  Future<void> _selectDate(
    TextEditingController controller, {
    bool isEdit = false,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        Duration(days: 365 * 25),
      ), // Default to 25 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: SpiroDesignSystem.primaryBlue600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: SpiroDesignSystem.gray900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
      setState(() {});
    }
  }

  Widget _buildDateFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool isRequired = true,
    bool isEdit = false,
  }) {
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: SpiroDesignSystem.gray300),
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _selectDate(controller, isEdit: isEdit),
              borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SpiroDesignSystem.space3,
                  vertical: SpiroDesignSystem.space3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.text.isEmpty ? hintText : controller.text,
                        style: SpiroDesignSystem.bodyL.copyWith(
                          color: controller.text.isEmpty
                              ? SpiroDesignSystem.gray500
                              : SpiroDesignSystem.gray900,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: SpiroDesignSystem.primaryBlue600,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
            _buildAgentsHeader(),
            SizedBox(height: SpiroDesignSystem.space8),
            _buildStatisticsCards(),
            SizedBox(height: SpiroDesignSystem.space6),
            _buildSearchAndFilterSection(),
            SizedBox(height: SpiroDesignSystem.space6),
            if (_showAddForm) _buildAddAgentForm(),
            if (_showEditForm) _buildEditAgentForm(),
            if (_isLoading) _buildLoadingIndicator(),
            if (!_isLoading && !_showAddForm && !_showEditForm)
              _buildAgentsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SpiroDesignSystem.space8),
        child: CircularProgressIndicator(
          color: SpiroDesignSystem.primaryBlue600,
        ),
      ),
    );
  }

  Widget _buildAgentsHeader() {
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
                'Agent Management',
                style: SpiroDesignSystem.displayM.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SpiroDesignSystem.gray900,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space2),
              Text(
                'Manage your workforce and field agents',
                style: SpiroDesignSystem.bodyL.copyWith(
                  color: SpiroDesignSystem.gray600,
                ),
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space4),
          // FIXED: Match incidents pattern with Row and Flexible
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
                      _showAddForm = true;
                      _showEditForm = false;
                      _currentEditingAgentId = '';
                      _clearAgentForm();
                    });
                  },
                  icon: Icons.add_circle_outline,
                  label: 'Add Agent',
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
    int totalAgents = _agents.length;
    int onlineAgents = _agents
        .where((a) => _getAgentDisplayStatus(a) == 'online')
        .length;
    int offlineAgents = _agents
        .where((a) => _getAgentDisplayStatus(a) == 'offline')
        .length;
    int activeAgents = onlineAgents;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use different layouts based on screen width
        if (constraints.maxWidth < 800) {
          // Stack cards vertically on smaller screens
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Agents',
                      totalAgents.toString(),
                      'registered',
                      SpiroDesignSystem.primaryBlue600,
                      Icons.people_outline,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Online',
                      onlineAgents.toString(),
                      'active now',
                      SpiroDesignSystem.success600,
                      Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SpiroDesignSystem.space4),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Offline',
                      offlineAgents.toString(),
                      'inactive',
                      SpiroDesignSystem.gray500,
                      Icons.cancel_outlined,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space4),
                  Expanded(
                    child: _buildStatCard(
                      'Active Today',
                      activeAgents.toString(),
                      'working',
                      SpiroDesignSystem.warning600,
                      Icons.work_outline,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Horizontal layout for larger screens
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Total Agents',
                    totalAgents.toString(),
                    'registered',
                    SpiroDesignSystem.primaryBlue600,
                    Icons.people_outline,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Online',
                    onlineAgents.toString(),
                    'active now',
                    SpiroDesignSystem.success600,
                    Icons.check_circle_outline,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Offline',
                    offlineAgents.toString(),
                    'inactive',
                    SpiroDesignSystem.gray500,
                    Icons.cancel_outlined,
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space4),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 250),
                  child: _buildStatCard(
                    'Active Today',
                    activeAgents.toString(),
                    'working',
                    SpiroDesignSystem.warning600,
                    Icons.work_outline,
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

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: EdgeInsets.all(SpiroDesignSystem.space4),
      decoration: SpiroDesignSystem.cardDecoration,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: SpiroDesignSystem.gray50,
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
                border: Border.all(color: SpiroDesignSystem.gray300),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search agents by name, ID, email, phone...',
                  hintStyle: SpiroDesignSystem.bodyL.copyWith(
                    color: SpiroDesignSystem.gray500,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: SpiroDesignSystem.gray500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SpiroDesignSystem.space4,
                    vertical: SpiroDesignSystem.space3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAgentForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      margin: EdgeInsets.only(bottom: SpiroDesignSystem.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Agent',
                      style: SpiroDesignSystem.displayS.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    SizedBox(height: SpiroDesignSystem.space1),
                    Text(
                      'Fill in the agent details below',
                      style: SpiroDesignSystem.bodyL.copyWith(
                        color: SpiroDesignSystem.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: SpiroDesignSystem.gray600,
                ),
                onPressed: () {
                  setState(() {
                    _showAddForm = false;
                    _clearAgentForm();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: SpiroDesignSystem.space6),
          // Fixed: Make form responsive
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Single column layout for smaller screens
                return Column(
                  children: [
                    _buildFormField(
                      label: 'First Name',
                      hintText: 'e.g., Cynthia',
                      controller: _firstnameController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Middle Name',
                      hintText: 'e.g., Situma',
                      controller: _middlenameController,
                      isRequired: false,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Last Name',
                      hintText: 'e.g., Fake',
                      controller: _lastnameController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildDateFormField(
                      label: 'Date of Birth',
                      hintText: 'e.g., 1990-05-15',
                      controller: _dobController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Phone Number',
                      hintText: 'e.g., 0712345678',
                      controller: _phonenumberController,
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'National ID',
                      hintText: 'e.g., ID123456',
                      controller: _identificationController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Nationality',
                      hintText: 'e.g., Kenyan',
                      controller: _nationalityController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Email Address',
                      hintText: 'e.g., CFake@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      isRequired: true,
                    ),
                  ],
                );
              } else {
                // Two column layout for larger screens
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            label: 'First Name',
                            hintText: 'e.g., Cynthia',
                            controller: _firstnameController,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Middle Name',
                            hintText: 'e.g., Situma',
                            controller: _middlenameController,
                            isRequired: false,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Phone Number',
                            hintText: 'e.g., 0712345678',
                            controller: _phonenumberController,
                            keyboardType: TextInputType.phone,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'National ID',
                            hintText: 'e.g., ID123456',
                            controller: _identificationController,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: SpiroDesignSystem.space4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            label: 'Last Name',
                            hintText: 'e.g., Fake',
                            controller: _lastnameController,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildDateFormField(
                            label: 'Date of Birth',
                            hintText: 'e.g., 1990-05-15',
                            controller: _dobController,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Nationality',
                            hintText: 'e.g., Kenyan',
                            controller: _nationalityController,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Email Address',
                            hintText: 'e.g., CFake@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: SpiroDesignSystem.space6),
          // Fixed: Make action buttons responsive
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAddForm = false;
                      _clearAgentForm();
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: SpiroDesignSystem.bodyL.copyWith(
                      color: SpiroDesignSystem.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space3),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: _buildHeaderButton(
                    onPressed: _isLoading ? () {} : _submitAgentForm,
                    icon: Icons.person_add_outlined,
                    label: _isLoading ? 'Registering...' : 'Register Agent',
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditAgentForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SpiroDesignSystem.space6),
      decoration: SpiroDesignSystem.cardDecoration,
      margin: EdgeInsets.only(bottom: SpiroDesignSystem.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Agent Details',
                      style: SpiroDesignSystem.displayS.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    if (_currentEditingAgentId.isNotEmpty) ...[
                      SizedBox(height: SpiroDesignSystem.space1),
                      Text(
                        'Editing Agent ID: $_currentEditingAgentId',
                        style: SpiroDesignSystem.bodyL.copyWith(
                          color: SpiroDesignSystem.gray600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: SpiroDesignSystem.gray600,
                ),
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
          SizedBox(height: SpiroDesignSystem.space6),
          // Fixed: Make edit form responsive too
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Single column layout for smaller screens
                return Column(
                  children: [
                    _buildFormField(
                      label: 'First Name',
                      hintText: 'Enter first name',
                      controller: _editFirstnameController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Middle Name',
                      hintText: 'Enter middle name',
                      controller: _editMiddlenameController,
                      isRequired: false,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Last Name',
                      hintText: 'Enter last name',
                      controller: _editLastnameController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildDateFormField(
                      label: 'Date of Birth',
                      hintText: 'Enter date of birth',
                      controller: _editDobController,
                      isRequired: true,
                      isEdit: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Phone Number',
                      hintText: 'Enter phone number',
                      controller: _editPhonenumberController,
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'National ID',
                      hintText: 'Enter national ID',
                      controller: _editIdentificationController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Nationality',
                      hintText: 'Enter nationality',
                      controller: _editNationalityController,
                      isRequired: true,
                    ),
                    SizedBox(height: SpiroDesignSystem.space4),
                    _buildFormField(
                      label: 'Email',
                      hintText: 'Enter email address',
                      controller: _editEmailController,
                      keyboardType: TextInputType.emailAddress,
                      isRequired: true,
                    ),
                  ],
                );
              } else {
                // Two column layout for larger screens
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            label: 'First Name',
                            hintText: 'Enter first name',
                            controller: _editFirstnameController,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Middle Name',
                            hintText: 'Enter middle name',
                            controller: _editMiddlenameController,
                            isRequired: false,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Phone Number',
                            hintText: 'Enter phone number',
                            controller: _editPhonenumberController,
                            keyboardType: TextInputType.phone,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'National ID',
                            hintText: 'Enter national ID',
                            controller: _editIdentificationController,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: SpiroDesignSystem.space4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            label: 'Last Name',
                            hintText: 'Enter last name',
                            controller: _editLastnameController,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildDateFormField(
                            label: 'Date of Birth',
                            hintText: 'Enter date of birth',
                            controller: _editDobController,
                            isRequired: true,
                            isEdit: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Nationality',
                            hintText: 'Enter nationality',
                            controller: _editNationalityController,
                            isRequired: true,
                          ),
                          SizedBox(height: SpiroDesignSystem.space4),
                          _buildFormField(
                            label: 'Email',
                            hintText: 'Enter email address',
                            controller: _editEmailController,
                            keyboardType: TextInputType.emailAddress,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: SpiroDesignSystem.space6),
          // Fixed: Make action buttons responsive
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
                  child: Text(
                    'Cancel',
                    style: SpiroDesignSystem.bodyL.copyWith(
                      color: SpiroDesignSystem.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: SpiroDesignSystem.space3),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: _buildHeaderButton(
                    onPressed: _isLoading ? () {} : _saveAgentEdits,
                    icon: Icons.save_outlined,
                    label: _isLoading ? 'Saving...' : 'Save Changes',
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentsTable() {
    if (_filteredAgents.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(SpiroDesignSystem.space8),
        decoration: SpiroDesignSystem.cardDecoration,
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: SpiroDesignSystem.gray400,
            ),
            SizedBox(height: SpiroDesignSystem.space4),
            Text(
              'No agents found',
              style: SpiroDesignSystem.displayS.copyWith(
                fontWeight: FontWeight.w600,
                color: SpiroDesignSystem.gray900,
              ),
            ),
            SizedBox(height: SpiroDesignSystem.space2),
            Text(
              'Add your first agent to get started',
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: SpiroDesignSystem.cardDecoration,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(SpiroDesignSystem.space4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: SpiroDesignSystem.gray200, width: 1),
              ),
              color: SpiroDesignSystem.gray50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SpiroDesignSystem.radiusLg),
                topRight: Radius.circular(SpiroDesignSystem.radiusLg),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Agent ID',
                    style: SpiroDesignSystem.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Full Name',
                    style: SpiroDesignSystem.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Phone',
                    style: SpiroDesignSystem.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Email',
                    style: SpiroDesignSystem.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nationality',
                    style: SpiroDesignSystem.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    style: SpiroDesignSystem.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Actions',
                    style: SpiroDesignSystem.bodyS.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SpiroDesignSystem.gray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._filteredAgents
              .map((agent) => _buildAgentTableRow(agent))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAgentTableRow(Agent agent) {
    Color statusColor = _getStatusColor(_getAgentDisplayStatus(agent));
    String statusText = _getAgentDisplayStatus(agent);

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
              _getAgentDisplayId(agent),
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _getAgentFullName(agent),
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray900,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              agent.phonenumber,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              agent.email,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              agent.nationality,
              style: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SpiroDesignSystem.space2,
                vertical: SpiroDesignSystem.space1,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusSm),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: SpiroDesignSystem.space2),
                  Text(
                    statusText.toUpperCase(),
                    style: SpiroDesignSystem.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _buildActionButton(
                  Icons.edit_outlined,
                  'Edit',
                  SpiroDesignSystem.primaryBlue600,
                  () => _editAgent(agent),
                ),
                SizedBox(width: SpiroDesignSystem.space2),
                _buildActionButton(
                  Icons.delete_outline,
                  'Delete',
                  SpiroDesignSystem.danger600,
                  () => _showDeleteConfirmation(
                    _getAgentFullName(agent),
                    _getAgentDisplayId(agent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String tooltip,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: color),
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.all(SpiroDesignSystem.space2),
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
      _populateEditFormWithAgentData(agent);
    });
  }

  void _populateEditFormWithAgentData(Agent agent) {
    _editFirstnameController.text = agent.firstname;
    _editMiddlenameController.text = agent.middlename;
    _editLastnameController.text = agent.lastname;
    _editDobController.text = agent.dob;
    _editNationalityController.text = agent.nationality;
    _editIdentificationController.text = agent.identification;
    _editPhonenumberController.text = agent.phonenumber;
    _editEmailController.text = agent.email;
  }

  Future<void> _saveAgentEdits() async {
    setState(() => _isLoading = true);
    try {
      // Create updated agent using copyWith or constructor
      final updatedAgent = Agent(
        id: _currentEditingAgentId,
        firstname: _editFirstnameController.text,
        middlename: _editMiddlenameController.text,
        lastname: _editLastnameController.text,
        dob: _editDobController.text,
        nationality: _editNationalityController.text,
        identification: _editIdentificationController.text,
        phonenumber: _editPhonenumberController.text,
        email: _editEmailController.text,
        statusId: 'b8641bcd-07d5-4919-b459-5a081dee449b',
        createdBy: 'admin',
      );

      await _agentService.updateAgent(_currentEditingAgentId, updatedAgent);
      _showSuccessNotification("Agent details updated successfully!");
      await _loadAgents(); // Refresh the list

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
        _emailController.text.isEmpty) {
      _showErrorNotification("Please fill in all required fields");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final newAgent = Agent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstname: _firstnameController.text,
        middlename: _middlenameController.text,
        lastname: _lastnameController.text,
        dob: _dobController.text,
        nationality: _nationalityController.text,
        identification: _identificationController.text,
        phonenumber: _phonenumberController.text,
        email: _emailController.text,
        statusId: 'b8641bcd-07d5-4919-b459-5a081dee449b',
        createdBy: 'admin',
      );

      await _agentService.addAgent(newAgent);
      _showSuccessNotification("Agent registered successfully!");
      await _loadAgents();

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
          ),
          title: Text(
            'Delete Agent',
            style: SpiroDesignSystem.displayS.copyWith(
              fontWeight: FontWeight.w700,
              color: SpiroDesignSystem.gray900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to delete this agent?",
                style: SpiroDesignSystem.bodyL.copyWith(
                  color: SpiroDesignSystem.gray700,
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space4),
              Container(
                padding: EdgeInsets.all(SpiroDesignSystem.space3),
                decoration: BoxDecoration(
                  color: SpiroDesignSystem.danger50,
                  borderRadius: BorderRadius.circular(
                    SpiroDesignSystem.radiusMd,
                  ),
                  border: Border.all(color: SpiroDesignSystem.danger200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: $name",
                      style: SpiroDesignSystem.bodyL.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SpiroDesignSystem.gray900,
                      ),
                    ),
                    SizedBox(height: SpiroDesignSystem.space1),
                    Text(
                      "Agent ID: $agentId",
                      style: SpiroDesignSystem.bodyL.copyWith(
                        color: SpiroDesignSystem.gray700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SpiroDesignSystem.space3),
              Text(
                "This action cannot be undone.",
                style: SpiroDesignSystem.bodyS.copyWith(
                  color: SpiroDesignSystem.danger600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: SpiroDesignSystem.bodyL.copyWith(
                  color: SpiroDesignSystem.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(width: SpiroDesignSystem.space2),
            Container(
              decoration: BoxDecoration(
                color: SpiroDesignSystem.danger600,
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement actual delete functionality
                },
                child: Text(
                  'Delete',
                  style: SpiroDesignSystem.bodyL.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ),
          ],
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: SpiroDesignSystem.gray300),
            borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray500,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: SpiroDesignSystem.space3,
                vertical: SpiroDesignSystem.space3,
              ),
              border: InputBorder.none,
              isDense: true,
            ),
            style: SpiroDesignSystem.bodyL.copyWith(
              color: SpiroDesignSystem.gray900,
            ),
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
    return _buildFormField(
      label: label,
      hintText: hintText,
      controller: controller,
      maxLines: maxLines,
      isRequired: true,
    );

  }

  Widget _buildCardIconButton(
    IconData icon,
    String tooltip,
    Color color,
    VoidCallback onPressed,
  ) {
    return _buildActionButton(icon, tooltip, color, onPressed);
  }

  void _showSuccessNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: SpiroDesignSystem.bodyL.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: SpiroDesignSystem.success600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: SpiroDesignSystem.bodyL.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: SpiroDesignSystem.danger600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return SpiroDesignSystem.success600;
      case 'busy':
        return SpiroDesignSystem.warning600;
      case 'break':
        return SpiroDesignSystem.primaryBlue600;
      case 'offline':
        return SpiroDesignSystem.gray500;
      default:
        return SpiroDesignSystem.gray500;
    }
  }
}
