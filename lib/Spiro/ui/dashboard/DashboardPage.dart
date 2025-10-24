import 'package:flutter/material.dart';
import 'package:horizonui/Spiro/ui/dashboard/ConnectDashboard.dart';
import 'package:horizonui/Spiro/ui/dashboard/ViewDashboard.dart';
import 'package:stacked/stacked.dart';

import '../../designs/Responsive.dart';
import '../../utils/DesignSystem.dart';
import '../agents/Agents.dart';
import '../analytics/Analytics.dart';
import '../batteries/Batteries.dart';
import '../clamp/ClampBox.dart';
import '../incidents/Incidents.dart';
import '../reports/Reports.dart';
import '../settings/Settings.dart';
import '../stations/stations_page.dart';
import 'Dashboard.dart';
import 'content/DashboardPageContent.dart';

// : Added utility widgets to prevent render overflow

class DashboardPageState extends State<Dashboard>
    with TickerProviderStateMixin
    implements ConnectDashboard {
  String _selectedMenuItem = 'Dashboard';
  Widget _currentPage = DashboardPageContent();
  bool _isSidebarOpen = true;
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;

  ViewDashboard? _model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewDashboard>.reactive(
      viewModelBuilder: () => ViewDashboard(context, this),
      onViewModelReady: (viewModel) => {_model = viewModel, _initialiseView()},
      builder: (context, viewModel, child) => PopScope(
        canPop: false, // Prevents auto pop
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            if (_model?.loadingEntry == null && _model?.errorEntry == null) {
              _closeApp();
            }
          }
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
                  return Responsive(
                    mobile: _mobileView(viewportConstraints),
                    desktop: _desktopView(viewportConstraints),
                    tablet: _desktopView(viewportConstraints),
                  );
                },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      duration: SpiroDesignSystem.duration300,
      vsync: this,
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: SpiroDesignSystem.easeOut,
    );
    _sidebarController.forward();
  }

  _mobileView(BoxConstraints viewportConstraints) {
    return Column();
  }

  _desktopView(BoxConstraints constraints) {
    return Row(
      children: [
        // Enhanced Animated Sidebar - FIXED OVERFLOW
        AnimatedBuilder(
          animation: _sidebarAnimation,
          builder: (context, child) {
            final sidebarWidth = (_isSidebarOpen
                ? (constraints.maxWidth > 1200 ? 280.0 : 250.0) *
                      _sidebarAnimation.value
                : 0.0);

            return Container(
              width: sidebarWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    SpiroDesignSystem.primaryBlue600,
                    SpiroDesignSystem.primaryBlue700,
                  ],
                ),
                boxShadow: SpiroDesignSystem.shadowXl,
              ),
              child: ClipRect(
                child: Opacity(
                  opacity: _sidebarAnimation.value,
                  child: sidebarWidth > 100
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Enhanced Header with glassmorphism - FIXED TEXT OVERFLOW
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    SpiroDesignSystem.primaryBlue500,
                                    SpiroDesignSystem.primaryBlue600,
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.all(SpiroDesignSystem.space3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Spiro Control',
                                      style: SpiroDesignSystem.titleL.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).fadeIn(),
                                  ),
                                  SizedBox(height: SpiroDesignSystem.space0_5),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Operations Control Tower',
                                      style: SpiroDesignSystem.bodyL.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ).fadeIn(),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      SpiroDesignSystem.primaryBlue600,
                                      SpiroDesignSystem.primaryBlue700,
                                    ],
                                  ),
                                ),
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(
                                    context,
                                  ).copyWith(scrollbars: false),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    physics: ClampingScrollPhysics(),
                                    children: [
                                      _buildMenuItem(
                                        'Dashboard',
                                        Icons.dashboard_outlined,
                                        Icons.dashboard,
                                      ),
                                      _buildMenuItem(
                                        'Agents',
                                        Icons.people_outline,
                                        Icons.people,
                                      ),
                                      _buildMenuItem(
                                        'Stations',
                                        Icons.ev_station_outlined,
                                        Icons.ev_station,
                                      ),
                                      _buildMenuItem(
                                        'Batteries',
                                        Icons.battery_std_outlined,
                                        Icons.battery_std,
                                      ),
                                      _buildMenuItem(
                                        'Analytics',
                                        Icons.analytics_outlined,
                                        Icons.analytics,
                                      ),
                                      _buildMenuItem(
                                        'Incidents',
                                        Icons.warning_amber_outlined,
                                        Icons.warning_amber,
                                      ),
                                      _buildMenuItem(
                                        'Reports',
                                        Icons.assessment_outlined,
                                        Icons.assessment,
                                      ),
                                      _buildMenuItem(
                                        'Settings',
                                        Icons.settings_outlined,
                                        Icons.settings,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Enhanced User Profile Section - FIXED OVERFLOW
                            Container(
                              margin: EdgeInsets.all(SpiroDesignSystem.space2),
                              padding: EdgeInsets.all(SpiroDesignSystem.space3),
                              decoration:
                                  SpiroDesignSystem.glassMorphismDecoration,
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient:
                                            SpiroDesignSystem.primaryGradient,
                                        boxShadow:
                                            SpiroDesignSystem.shadowPrimary,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        radius: 18,
                                      ),
                                    ),
                                    SizedBox(width: SpiroDesignSystem.space2),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Shawn Matunda',
                                            style: SpiroDesignSystem.bodyL
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            'Global Admin',
                                            style: SpiroDesignSystem.bodyS
                                                .copyWith(
                                                  color: Colors.white70,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          SpiroDesignSystem.radiusMd,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.logout,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _handleLogout(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).slideIn(),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
              ),
            );
          },
        ),

        // Enhanced Main Content Area - FIXED FLEX OVERFLOW
        Expanded(
          child: ClampedBox(
            child: Stack(
              children: [
                _currentPage.fadeIn(),

                // Enhanced Sidebar Toggle Button - FIXED POSITIONING
                Positioned(
                  left: SpiroDesignSystem.space4,
                  top: SpiroDesignSystem.space4,
                  child: SafeArea(
                    child: AnimatedScale(
                      scale: _isSidebarOpen ? 0.9 : 1.1,
                      duration: SpiroDesignSystem.duration200,
                      child: InkWell(
                        onTap: _toggleSidebar,
                        borderRadius: BorderRadius.circular(
                          SpiroDesignSystem.radiusFull,
                        ),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: SpiroDesignSystem.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: SpiroDesignSystem.shadowPrimary,
                          ),
                          child: Icon(
                            _isSidebarOpen ? Icons.chevron_left : Icons.menu,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _navigateToPage(String pageName) {
    debugPrint('Navigating to: $pageName');

    setState(() {
      _selectedMenuItem = pageName;
      switch (pageName) {
        case 'Dashboard':
          _currentPage = DashboardPageContent();
          break;
        case 'Agents':
          _currentPage = AgentsPage();
          break;
        case 'Stations':
          _currentPage = StationsPage();
          break;
        case 'Batteries':
          _currentPage = BatteriesPage();
          break;
        case 'Analytics':
          _currentPage = AnalyticsPage();
          break;
        case 'Incidents':
          _currentPage = IncidentsPage();
          break;
        case 'Reports':
          _currentPage = ReportsPage();
          break;
        case 'Settings':
          _currentPage = SettingsPage();
          break;
        default:
          _currentPage = DashboardPageContent();
      }
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _sidebarController.forward();
      } else {
        _sidebarController.reverse();
      }
    });
  }

  AnimatedContainer _buildMenuItem(
    String title,
    IconData outlineIcon,
    IconData filledIcon,
  ) {
    bool isSelected = _selectedMenuItem == title;
    return AnimatedContainer(
      duration: SpiroDesignSystem.duration200,
      margin: EdgeInsets.symmetric(
        horizontal: SpiroDesignSystem.space2,
        vertical: SpiroDesignSystem.space0_5,
      ),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [Colors.white24, Colors.white12],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
        border: isSelected ? Border.all(color: Colors.white30, width: 1) : null,
        boxShadow: isSelected ? SpiroDesignSystem.shadowSm : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToPage(title),
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
          child: ListTile(
            leading: SizedBox(
              width: 24,
              height: 24,
              child: AnimatedSwitcher(
                duration: SpiroDesignSystem.duration150,
                child: Icon(
                  isSelected ? filledIcon : outlineIcon,
                  color: Colors.white,
                  size: 20,
                  key: ValueKey(isSelected),
                ),
              ),
            ),
            title: Text(
              title,
              style: SpiroDesignSystem.bodyL.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.white,
              ),
            ),
            trailing: isSelected
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white30,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  /* return Scaffold(
      backgroundColor: SpiroDesignSystem.gray50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ;
        },
      ),
    );*/

  void _handleLogout() {
    debugPrint('Logging out...');
    // Implement logout logic here
  }

  void _closeApp() {}

  _initialiseView() {}
}

// Dashboard Page Content

//  implementation of ConnectDashboard for API calls
class _DashboardConnection extends ConnectDashboard {}
