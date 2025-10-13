import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../configs/Navigator.dart';
import '../../data/internal/application/NavigatorType.dart';
import '../../data/internal/application/SpiroModels.dart';
import '../../data/internal/application/TextType.dart';
import '../../designs/Component.dart';
import '../login/Login.dart';
import 'ConnectDashboard.dart';
import 'Dashboard.dart';
import 'ViewDashboard.dart';
import 'views/AgentsView.dart';
import 'widgets/AfricaMapWidget.dart';
import 'widgets/CountryMapWidget.dart';

class DashboardState extends State<Dashboard>
    with TickerProviderStateMixin
    implements ConnectDashboard {
  String? _selectedCountry;
  String _selectedView = 'dashboard';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewDashboard>.reactive(
      viewModelBuilder: () => ViewDashboard(context, this),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Color(0xFFF9FAFB),
        appBar: _buildAppBar(),
        drawer: Drawer(child: _buildSidebar()),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      toolbarHeight: 64,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu_rounded, color: Color(0xFF374151), size: 24),
          tooltip: 'Open menu',
          splashRadius: 24,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3B82F6).withValues(alpha: 0.5),
                        blurRadius: 20,
                      ),
                      BoxShadow(
                        color: Color(0xFF3B82F6).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: textWithColor(
                    'SPIRO',
                    11,
                    TextType.Bold,
                    Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                textWithColor(
                  'Control Tower',
                  16,
                  TextType.Bold,
                  Color(0xFF111827),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFD1D5DB),
                    shape: BoxShape.circle,
                  ),
                ),
                Flexible(
                  child: textWithColor(
                    _getViewDescription(),
                    14,
                    TextType.Regular,
                    Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (widget.userRole?.role == 'global')
          Padding(
            padding: EdgeInsets.only(right: 8, left: 8),
            child: Material(
              color: Colors.transparent,
              child: PopupMenuButton<String>(
                offset: Offset(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFE5E7EB), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.public, size: 18, color: Color(0xFF6B7280)),
                      SizedBox(width: 8),
                      text(_getCountryLabel(), 13, TextType.Medium),
                      SizedBox(width: 4),
                      Icon(
                        Icons.expand_more,
                        size: 18,
                        color: Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                ),
                onSelected: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
                itemBuilder: (context) => [
                  _buildMenuItem(
                    'All',
                    '🌍 All Countries',
                    _selectedCountry == 'All',
                  ),
                  _buildMenuItem(
                    'Kenya',
                    '🇰🇪 Kenya',
                    _selectedCountry == 'Kenya',
                  ),
                  _buildMenuItem(
                    'Rwanda',
                    '🇷🇼 Rwanda',
                    _selectedCountry == 'Rwanda',
                  ),
                  _buildMenuItem(
                    'Uganda',
                    '🇺🇬 Uganda',
                    _selectedCountry == 'Uganda',
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(right: 16, left: 8),
          child: PopupMenuButton(
            offset: Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFDCEFFE),
              child: textWithColor(
                (widget.userRole?.label ?? 'U').substring(0, 1).toUpperCase(),
                15,
                TextType.Bold,
                Color(0xFF3B82F6),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(widget.userRole?.label ?? 'User', 15, TextType.Bold),
                    SizedBox(height: 4),
                    textWithColor(
                      _getRoleDescription(widget.userRole?.role ?? ''),
                      12,
                      TextType.Regular,
                      Color(0xFF6B7280),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleBadgeColor(widget.userRole?.role ?? ''),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: textWithColor(
                        _getRoleBadgeText(widget.userRole?.role ?? ''),
                        11,
                        TextType.Bold,
                        _getRoleBadgeTextColor(widget.userRole?.role ?? ''),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: _handleLogout,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    textWithColor(
                      'Logout',
                      14,
                      TextType.Medium,
                      Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(height: 1, color: Color(0xFFE5E7EB)),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    String label,
    bool isSelected,
  ) {
    return PopupMenuItem(
      value: value,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: text(
              label,
              14,
              isSelected ? TextType.Bold : TextType.Regular,
            ),
          ),
          if (isSelected)
            Icon(Icons.check_rounded, color: Color(0xFF3B82F6), size: 18),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final navigationItems = [
      {
        'id': 'dashboard',
        'title': 'Dashboard',
        'icon': Icons.dashboard_rounded,
      },
      {'id': 'agents', 'title': 'Agents', 'icon': Icons.people_rounded},
      {'id': 'stations', 'title': 'Stations', 'icon': Icons.store_rounded},
      {
        'id': 'batteries',
        'title': 'Batteries',
        'icon': Icons.battery_charging_full_rounded,
      },
      {
        'id': 'analytics',
        'title': 'Analytics',
        'icon': Icons.analytics_rounded,
      },
      {'id': 'incidents', 'title': 'Incidents', 'icon': Icons.warning_rounded},
      {'id': 'reports', 'title': 'Reports', 'icon': Icons.description_rounded},
      {
        'id': 'data-entry',
        'title': 'Data Entry',
        'icon': Icons.edit_note_rounded,
      },
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3B82F6).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: textWithColor('S', 20, TextType.Bold, Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text('Spiro Dashboard', 15, TextType.Bold),
                      SizedBox(height: 2),
                      textWithColor(
                        widget.userRole?.role == 'global'
                            ? 'Global Operations'
                            : widget.userRole?.role == 'local'
                            ? '🇰🇪 Kenya Ops'
                            : '🇰🇪 Agent',
                        11,
                        TextType.Regular,
                        Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                textWithColor(
                  'NAVIGATION',
                  11,
                  TextType.Bold,
                  Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: navigationItems.map((item) {
                final isActive = _selectedView == item['id'];
                return Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedView = item['id'] as String;
                        });
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Color(0xFFEFF6FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isActive
                                ? Color(0xFF3B82F6).withValues(alpha: 0.2)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              color: isActive
                                  ? Color(0xFF3B82F6)
                                  : Color(0xFF6B7280),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: text(
                                item['title'] as String,
                                14,
                                isActive ? TextType.Bold : TextType.Medium,
                              ),
                            ),
                            if (isActive)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3B82F6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFE5E7EB),
                  child: textWithColor(
                    (widget.userRole?.label ?? 'U')
                        .substring(0, 1)
                        .toUpperCase(),
                    14,
                    TextType.Bold,
                    Color(0xFF374151),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(widget.userRole?.label ?? 'User', 13, TextType.Bold),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getRoleBadgeColor(
                            widget.userRole?.role ?? '',
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: textWithColor(
                          _getRoleBadgeText(widget.userRole?.role ?? ''),
                          9,
                          TextType.Bold,
                          _getRoleBadgeTextColor(widget.userRole?.role ?? ''),
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleLogout,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFEF4444),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedView == 'dashboard') {
      return _buildDashboardView();
    } else if (_selectedView == 'agents') {
      return AgentsView();
    } else {
      return _buildPlaceholderContent();
    }
  }

  Widget _buildDashboardView() {
    final metrics = _getMetricsForSelectedCountry();

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text('Dashboard Overview', 28, TextType.Bold),
                SizedBox(height: 8),
                textWithColor(
                  'Real-time operations monitoring across ${_selectedCountry == 'All' ? 'all regions' : _selectedCountry ?? 'all regions'}',
                  14,
                  TextType.Regular,
                  Color(0xFF6B7280),
                ),
              ],
            ),
          ),
          _buildMetricsCards(metrics),
          SizedBox(height: 32),
          Container(
            margin: EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text('Operational Maps', 22, TextType.Bold),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text('Regional Operations', 18, TextType.Bold),
                            if (_selectedCountry != null)
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _selectedCountry = null;
                                  });
                                },
                                icon: Icon(Icons.clear, size: 16),
                                label: text(
                                  'Clear Filter',
                                  12,
                                  TextType.Medium,
                                ),
                              ),
                          ],
                        ),
                      ),
                      AfricaMapWidget(
                        onCountrySelect: (countryCode) {
                          setState(() {
                            _selectedCountry = countryCode;
                          });
                        },
                        selectedCountry: _selectedCountry,
                      ),
                    ],
                  ),
                ),
                if (_selectedCountry != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: text('Station Details', 18, TextType.Bold),
                        ),
                        CountryMapWidget(countryCode: _selectedCountry!),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildRecentActivityCard()),
                    SizedBox(width: 24),
                    Expanded(child: _buildQuickActionsCard()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildRecentActivityCard(),
                    SizedBox(height: 24),
                    _buildQuickActionsCard(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCards(MetricData metrics) {
    final cards = [
      {
        'title': 'Active Agents',
        'value': '${metrics.activeAgents}',
        'subtitle': 'Online now',
        'icon': Icons.people_rounded,
        'color': Color(0xFF3B82F6),
        'bgColor': Color(0xFFEFF6FF),
        'trend': 12,
      },
      {
        'title': 'Power Stations',
        'value': '${metrics.powerStations}',
        'subtitle': '${metrics.totalPower} MW',
        'icon': Icons.bolt_rounded,
        'color': Color(0xFF10B981),
        'bgColor': Color(0xFFD1FAE5),
        'trend': 5,
      },
      {
        'title': 'Incidents',
        'value': '${metrics.totalIncidents}',
        'subtitle': 'Reported today',
        'icon': Icons.warning_rounded,
        'color': metrics.totalIncidents > 2
            ? Color(0xFFEF4444)
            : Color(0xFFF59E0B),
        'bgColor': metrics.totalIncidents > 2
            ? Color(0xFFFEE2E2)
            : Color(0xFFFEF3C7),
        'trend': -8,
      },
      {
        'title': 'Battery Swaps',
        'value': '${metrics.swapsToday}',
        'subtitle': 'Last 24 hours',
        'icon': Icons.battery_charging_full_rounded,
        'color': Color(0xFF8B5CF6),
        'bgColor': Color(0xFFF3E8FF),
        'trend': 15,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 4;
        if (constraints.maxWidth < 800) columns = 2;
        if (constraints.maxWidth < 500) columns = 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return _buildMetricCard(
              card['title'] as String,
              card['value'] as String,
              card['subtitle'] as String,
              card['icon'] as IconData,
              card['trend'] as int,
              card['color'] as Color,
              card['bgColor'] as Color,
            );
          },
        );
      },
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    int trend,
    Color color,
    Color bgColor,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE5E7EB), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWithColor(
                          title,
                          13,
                          TextType.Medium,
                          Color(0xFF6B7280),
                        ),
                        SizedBox(height: 12),
                        text(value, 32, TextType.Bold),
                        SizedBox(height: 4),
                        textWithColor(
                          subtitle,
                          12,
                          TextType.Regular,
                          Color(0xFF9CA3AF),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: trend > 0 ? Color(0xFFD1FAE5) : Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trend > 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 16,
                      color: trend > 0 ? Color(0xFF10B981) : Color(0xFFEF4444),
                    ),
                    SizedBox(width: 6),
                    textWithColor(
                      '${trend > 0 ? '+' : ''}$trend%',
                      12,
                      TextType.Bold,
                      trend > 0 ? Color(0xFF10B981) : Color(0xFFEF4444),
                    ),
                    SizedBox(width: 4),
                    textWithColor(
                      'vs last week',
                      11,
                      TextType.Regular,
                      Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              text('Recent Activity', 18, TextType.Bold),
            ],
          ),
          SizedBox(height: 24),
          Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: 48,
                    color: Color(0xFFD1D5DB),
                  ),
                  SizedBox(height: 12),
                  textWithColor(
                    'Activity feed coming soon...',
                    13,
                    TextType.Regular,
                    Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              text('Quick Actions', 18, TextType.Bold),
            ],
          ),
          SizedBox(height: 24),
          Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 48,
                    color: Color(0xFFD1D5DB),
                  ),
                  SizedBox(height: 12),
                  textWithColor(
                    'Quick actions coming soon...',
                    13,
                    TextType.Regular,
                    Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE5E7EB), width: 2),
            ),
            child: Icon(
              Icons.construction_rounded,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 24),
          text(_getViewTitle(), 24, TextType.Bold),
          SizedBox(height: 8),
          textWithColor(
            'Content coming soon...',
            14,
            TextType.Regular,
            Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Color _getRoleBadgeColor(String role) {
    switch (role) {
      case 'global':
        return Color(0xFFDCEFFE);
      case 'local':
        return Color(0xFFD1FAE5);
      case 'agent':
        return Color(0xFFFED7AA);
      default:
        return Color(0xFFF3F4F6);
    }
  }

  Color _getRoleBadgeTextColor(String role) {
    switch (role) {
      case 'global':
        return Color(0xFF1E40AF);
      case 'local':
        return Color(0xFF065F46);
      case 'agent':
        return Color(0xFF92400E);
      default:
        return Color(0xFF374151);
    }
  }

  String _getRoleBadgeText(String role) {
    switch (role) {
      case 'global':
        return 'GLOBAL ADMIN';
      case 'local':
        return 'LOCAL ADMIN';
      case 'agent':
        return 'AGENT';
      default:
        return 'USER';
    }
  }

  String _getCountryLabel() {
    switch (_selectedCountry) {
      case 'Kenya':
        return '🇰🇪 Kenya';
      case 'Rwanda':
        return '🇷🇼 Rwanda';
      case 'Uganda':
        return '🇺🇬 Uganda';
      default:
        return 'All Countries';
    }
  }

  String _getViewTitle() {
    switch (_selectedView) {
      case 'dashboard':
        return 'Dashboard';
      case 'agents':
        return 'Agents';
      case 'stations':
        return 'Stations';
      case 'batteries':
        return 'Batteries';
      case 'analytics':
        return 'Analytics';
      case 'incidents':
        return 'Incidents';
      case 'reports':
        return 'Reports';
      case 'data-entry':
        return 'Data Entry';
      default:
        return 'Dashboard';
    }
  }

  String _getViewDescription() {
    switch (_selectedView) {
      case 'dashboard':
        return 'Control tower overview';
      case 'agents':
        return 'Workforce management';
      case 'stations':
        return 'Station operations';
      case 'batteries':
        return 'Battery lifecycle tracking';
      case 'analytics':
        return 'Performance insights';
      case 'incidents':
        return 'Critical events';
      case 'reports':
        return 'Operations reports';
      case 'data-entry':
        return 'Forms & submissions';
      default:
        return 'Control tower overview';
    }
  }

  String _getRoleDescription(String role) {
    switch (role) {
      case 'global':
        return 'Global Administrator';
      case 'local':
        return 'Local Administrator';
      case 'agent':
        return 'Agent';
      default:
        return 'User';
    }
  }

  void _handleLogout() {
    Future.delayed(Duration(milliseconds: 100), () {
      SpiroNavigation().navigateToPage(
        NavigatorType.openFully,
        const Login(),
        context,
      );
    });
  }

  MetricData _getMetricsForSelectedCountry() {
    if (widget.userRole?.role == 'global') {
      if (_selectedCountry == null || _selectedCountry == 'All') {
        return MetricData.getGlobalMetrics();
      }

      switch (_selectedCountry) {
        case 'KE':
        case 'Kenya':
          return MetricData.getKenyaMetrics();
        case 'RW':
        case 'Rwanda':
          return MetricData.getRwandaMetrics();
        case 'UG':
        case 'Uganda':
          return MetricData.getUgandaMetrics();
        default:
          return MetricData.getGlobalMetrics();
      }
    } else {
      return MetricData.getKenyaMetrics();
    }
  }
}
