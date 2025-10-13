import 'package:flutter/material.dart';

import '../../../data/internal/application/TextType.dart';
import '../../../designs/Component.dart';

class AgentsView extends StatefulWidget {
  final String? selectedCountry;

  const AgentsView({Key? key, this.selectedCountry}) : super(key: key);

  @override
  State<AgentsView> createState() => _AgentsViewState();
}

class _AgentsViewState extends State<AgentsView> {
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedStation = 'All';
  String _sortBy = 'name';
  bool _isGridView = false;

  final List<AgentData> _agents = [
    AgentData(
      id: 'AG001',
      name: 'John Kamau',
      email: 'john.kamau@spiro.ke',
      phone: '+254 712 345 678',
      station: 'Nairobi CBD',
      status: 'active',
      swapsToday: 18,
      totalSwaps: 245,
      rating: 4.8,
      joinDate: '2024-01-15',
      lastActive: '5 min ago',
      avatar: '👨🏿‍💼',
    ),
    AgentData(
      id: 'AG002',
      name: 'Mary Wanjiku',
      email: 'mary.w@spiro.ke',
      phone: '+254 723 456 789',
      station: 'Nairobi Westlands',
      status: 'active',
      swapsToday: 15,
      totalSwaps: 198,
      rating: 4.9,
      joinDate: '2024-02-20',
      lastActive: '12 min ago',
      avatar: '👩🏿‍💼',
    ),
    AgentData(
      id: 'AG003',
      name: 'Peter Ochieng',
      email: 'peter.o@spiro.ke',
      phone: '+254 734 567 890',
      station: 'Nairobi Eastleigh',
      status: 'active',
      swapsToday: 16,
      totalSwaps: 212,
      rating: 4.7,
      joinDate: '2023-12-10',
      lastActive: '2 min ago',
      avatar: '👨🏿‍💼',
    ),
    AgentData(
      id: 'AG004',
      name: 'Grace Akinyi',
      email: 'grace.a@spiro.ke',
      phone: '+254 745 678 901',
      station: 'Mombasa Nyali',
      status: 'inactive',
      swapsToday: 0,
      totalSwaps: 167,
      rating: 4.6,
      joinDate: '2024-03-05',
      lastActive: '2 days ago',
      avatar: '👩🏿‍💼',
    ),
    AgentData(
      id: 'AG005',
      name: 'David Mwangi',
      email: 'david.m@spiro.ke',
      phone: '+254 756 789 012',
      station: 'Kisumu Central',
      status: 'active',
      swapsToday: 9,
      totalSwaps: 123,
      rating: 4.5,
      joinDate: '2024-04-12',
      lastActive: '30 min ago',
      avatar: '👨🏿‍💼',
    ),
    AgentData(
      id: 'AG006',
      name: 'Sarah Njeri',
      email: 'sarah.n@spiro.ke',
      phone: '+254 767 890 123',
      station: 'Nakuru Town',
      status: 'on-leave',
      swapsToday: 0,
      totalSwaps: 98,
      rating: 4.4,
      joinDate: '2024-05-08',
      lastActive: '1 week ago',
      avatar: '👩🏿‍💼',
    ),
  ];

  List<AgentData> get _filteredAgents {
    return _agents.where((agent) {
      final matchesSearch =
          agent.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          agent.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          agent.id.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _selectedStatus == 'All' || agent.status == _selectedStatus;
      final matchesStation =
          _selectedStation == 'All' || agent.station == _selectedStation;

      return matchesSearch && matchesStatus && matchesStation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 24),
          _buildMetricsCards(),
          SizedBox(height: 24),
          _buildFiltersBar(),
          SizedBox(height: 24),
          Expanded(child: _isGridView ? _buildGridView() : _buildTableView()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text('Agents Management', 28, TextType.Bold),
            SizedBox(height: 8),
            textWithColor(
              '${_filteredAgents.length} agents across ${widget.selectedCountry ?? 'all regions'}',
              14,
              TextType.Regular,
              Color(0xFF6B7280),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Add new agent
          },
          icon: Icon(Icons.add_rounded, size: 20),
          label: text('Add Agent', 14, TextType.Bold),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCards() {
    final activeAgents = _agents.where((a) => a.status == 'active').length;
    final todaySwaps = _agents.fold<int>(0, (sum, a) => sum + a.swapsToday);
    final avgRating =
        _agents.fold<double>(0, (sum, a) => sum + a.rating) / _agents.length;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Agents',
            '${_agents.length}',
            Icons.people_rounded,
            Color(0xFF3B82F6),
            Color(0xFFEFF6FF),
            '+12%',
            true,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Active Now',
            '$activeAgents',
            Icons.check_circle_rounded,
            Color(0xFF10B981),
            Color(0xFFD1FAE5),
            '$activeAgents/${_agents.length}',
            true,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Swaps Today',
            '$todaySwaps',
            Icons.battery_charging_full_rounded,
            Color(0xFF8B5CF6),
            Color(0xFFF3E8FF),
            '+8%',
            true,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Avg Rating',
            avgRating.toStringAsFixed(1),
            Icons.star_rounded,
            Color(0xFFF59E0B),
            Color(0xFFFEF3C7),
            '⭐ ${avgRating.toStringAsFixed(1)}/5.0',
            true,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color bgColor,
    String subtitle,
    bool isPositive,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          SizedBox(height: 16),
          text(value, 32, TextType.Bold),
          SizedBox(height: 4),
          textWithColor(title, 13, TextType.Medium, Color(0xFF6B7280)),
          SizedBox(height: 8),
          textWithColor(subtitle, 12, TextType.Regular, color),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search agents by name, email, or ID...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
                ),
                filled: true,
                fillColor: Color(0xFFF9FAFB),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),

          // Status Filter Dropdown
          _buildFilterDropdown(
            'Status: $_selectedStatus',
            Icons.circle,
            ['All', 'active', 'inactive', 'on-leave'],
            _selectedStatus,
            (value) => setState(() => _selectedStatus = value),
            _getStatusColor,
          ),
          SizedBox(width: 12),

          // Station Filter Dropdown
          _buildFilterDropdown(
            'Station: $_selectedStation',
            Icons.location_on,
            ['All', ..._agents.map((a) => a.station).toSet().toList()],
            _selectedStation,
            (value) => setState(() => _selectedStation = value),
            null,
          ),
          SizedBox(width: 12),

          // View Toggle
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildViewToggleButton(
                  Icons.table_rows_rounded,
                  !_isGridView,
                  () {
                    setState(() => _isGridView = false);
                  },
                ),
                _buildViewToggleButton(
                  Icons.grid_view_rounded,
                  _isGridView,
                  () {
                    setState(() => _isGridView = true);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    IconData icon,
    List<String> items,
    String selectedValue,
    Function(String) onChanged,
    Color Function(String)? getColor,
  ) {
    return PopupMenuButton<String>(
      offset: Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
          border: Border.all(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Color(0xFF6B7280)),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.expand_more, size: 18, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
      itemBuilder: (context) => items.map((item) {
        return PopupMenuItem<String>(
          value: item,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (getColor != null)
                Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: item == 'All' ? Colors.grey : getColor(item),
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selectedValue == item
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: Color(0xFF111827),
                ),
              ),
              if (selectedValue == item) ...[
                Spacer(),
                Icon(Icons.check, size: 18, color: Color(0xFF3B82F6)),
              ],
            ],
          ),
        );
      }).toList(),
      onSelected: onChanged,
    );
  }

  Widget _buildViewToggleButton(
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? Color(0xFF3B82F6) : Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildTableView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: text('Agent', 13, TextType.Bold)),
                Expanded(flex: 2, child: text('Contact', 13, TextType.Bold)),
                Expanded(child: text('Station', 13, TextType.Bold)),
                Expanded(child: text('Status', 13, TextType.Bold)),
                Expanded(child: text('Today', 13, TextType.Bold)),
                Expanded(child: text('Total', 13, TextType.Bold)),
                Expanded(child: text('Rating', 13, TextType.Bold)),
                SizedBox(width: 100, child: text('Actions', 13, TextType.Bold)),
              ],
            ),
          ),

          // Table Body
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAgents.length,
              itemBuilder: (context, index) {
                final agent = _filteredAgents[index];
                return _buildTableRow(agent, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(AgentData agent, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: index == _filteredAgents.length - 1 ? 0 : 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Agent Info
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(agent.avatar, style: TextStyle(fontSize: 20)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(agent.name, 14, TextType.Bold),
                      SizedBox(height: 2),
                      textWithColor(
                        agent.id,
                        12,
                        TextType.Regular,
                        Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contact
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWithColor(
                  agent.email,
                  13,
                  TextType.Regular,
                  Color(0xFF374151),
                ),
                SizedBox(height: 2),
                textWithColor(
                  agent.phone,
                  12,
                  TextType.Regular,
                  Color(0xFF6B7280),
                ),
              ],
            ),
          ),

          // Station
          Expanded(
            child: textWithColor(
              agent.station,
              13,
              TextType.Medium,
              Color(0xFF374151),
            ),
          ),

          // Status
          Expanded(child: _buildStatusBadge(agent.status)),

          // Today Swaps
          Expanded(child: text('${agent.swapsToday}', 14, TextType.Bold)),

          // Total Swaps
          Expanded(
            child: textWithColor(
              '${agent.totalSwaps}',
              13,
              TextType.Regular,
              Color(0xFF6B7280),
            ),
          ),

          // Rating
          Expanded(
            child: Row(
              children: [
                Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
                SizedBox(width: 4),
                text('${agent.rating}', 13, TextType.Bold),
              ],
            ),
          ),

          // Actions
          SizedBox(
            width: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(Icons.visibility_outlined, () {
                  // View details
                }),
                SizedBox(width: 8),
                _buildActionButton(Icons.edit_outlined, () {
                  // Edit agent
                }),
                SizedBox(width: 8),
                _buildActionButton(Icons.more_vert, () {
                  // More options
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _filteredAgents.length,
      itemBuilder: (context, index) {
        final agent = _filteredAgents[index];
        return _buildAgentCard(agent);
      },
    );
  }

  Widget _buildAgentCard(AgentData agent) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(agent.avatar, style: TextStyle(fontSize: 28)),
                ),
              ),
              _buildStatusBadge(agent.status),
            ],
          ),

          // Name and ID
          Column(
            children: [
              text(agent.name, 16, TextType.Bold),
              SizedBox(height: 4),
              textWithColor(agent.id, 12, TextType.Regular, Color(0xFF6B7280)),
            ],
          ),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                'Today',
                '${agent.swapsToday}',
                Color(0xFF8B5CF6),
              ),
              Container(width: 1, height: 30, color: Color(0xFFE5E7EB)),
              _buildStatColumn(
                'Total',
                '${agent.totalSwaps}',
                Color(0xFF3B82F6),
              ),
              Container(width: 1, height: 30, color: Color(0xFFE5E7EB)),
              _buildStatColumn('Rating', '${agent.rating}', Color(0xFFF59E0B)),
            ],
          ),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: text('View Details', 13, TextType.Bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        textWithColor(value, 18, TextType.Bold, color),
        SizedBox(height: 2),
        textWithColor(label, 11, TextType.Regular, Color(0xFF6B7280)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final bgColor = color.withAlpha(26);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(51)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6),
          Text(
            status == 'on-leave' ? 'On Leave' : status.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: Color(0xFF6B7280)),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Color(0xFF10B981);
      case 'inactive':
        return Color(0xFFEF4444);
      case 'on-leave':
        return Color(0xFFF59E0B);
      default:
        return Color(0xFF6B7280);
    }
  }
}

class AgentData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String station;
  final String status;
  final int swapsToday;
  final int totalSwaps;
  final double rating;
  final String joinDate;
  final String lastActive;
  final String avatar;

  AgentData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.station,
    required this.status,
    required this.swapsToday,
    required this.totalSwaps,
    required this.rating,
    required this.joinDate,
    required this.lastActive,
    required this.avatar,
  });
}
