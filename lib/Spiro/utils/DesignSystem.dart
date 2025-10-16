import 'package:flutter/material.dart';

/// Spiro Dashboard Design System
class SpiroDesignSystem {
  // Primary Blue Palette (replacing orange)
  static const Color primaryBlue50 = Color(0xFFEBF3FF);
  static const Color primaryBlue100 = Color(0xFFDBEAFE);
  static const Color primaryBlue200 = Color(0xFFBFDBFE);
  static const Color primaryBlue300 = Color(0xFF93C5FD);
  static const Color primaryBlue400 = Color(0xFF60A5FA);
  static const Color primaryBlue500 = Color(0xFF3B82F6);
  static const Color primaryBlue600 = Color(0xFF2563EB);
  static const Color primaryBlue700 = Color(0xFF1D4ED8);
  static const Color primaryBlue800 = Color(0xFF1E40AF);
  static const Color primaryBlue900 = Color(0xFF1E3A8A);

  // Success Green
  static const Color success50 = Color(0xFFECFDF5);
  static const Color success100 = Color(0xFFD1FAE5);
  static const Color success200 = Color(0xFFA7F3D0);
  static const Color success300 = Color(0xFF6EE7B7);
  static const Color success400 = Color(0xFF34D399);
  static const Color success500 = Color(0xFF10B981);
  static const Color success600 = Color(0xFF059669);
  static const Color success700 = Color(0xFF047857);
  static const Color success800 = Color(0xFF065F46);
  static const Color success900 = Color(0xFF064E3B);

  // Warning Amber
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning200 = Color(0xFFFDE68A);
  static const Color warning300 = Color(0xFFFCD34D);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning800 = Color(0xFF92400E);
  static const Color warning900 = Color(0xFF78350F);

  // Danger Red
  static const Color danger50 = Color(0xFFFEF2F2);
  static const Color danger100 = Color(0xFFFEE2E2);
  static const Color danger200 = Color(0xFFFECACA);
  static const Color danger300 = Color(0xFFFCA5A5);
  static const Color danger400 = Color(0xFFF87171);
  static const Color danger500 = Color(0xFFEF4444);
  static const Color danger600 = Color(0xFFDC2626);
  static const Color danger700 = Color(0xFFB91C1C);
  static const Color danger800 = Color(0xFF991B1B);
  static const Color danger900 = Color(0xFF7F1D1D);

  // Info Purple
  static const Color info50 = Color(0xFFFAF5FF);
  static const Color info100 = Color(0xFFF3E8FF);
  static const Color info200 = Color(0xFFE9D5FF);
  static const Color info300 = Color(0xFFD8B4FE);
  static const Color info400 = Color(0xFFC084FC);
  static const Color info500 = Color(0xFFA855F7);
  static const Color info600 = Color(0xFF9333EA);
  static const Color info700 = Color(0xFF7C3AED);
  static const Color info800 = Color(0xFF6B21A8);
  static const Color info900 = Color(0xFF581C87);

  // Neutral Grays (10 shades)
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Special Effect Colors
  static const Color glassMorphism = Color(0x1AFFFFFF);
  static const Color glassMorphismBorder = Color(0x33FFFFFF);
  static const Color criticalGlow = Color(0x40EF4444);
  static const Color primaryGlow = Color(0x403B82F6);
  static const Color successGlow = Color(0x4010B981);
  static const Color warningGlow = Color(0x40F59E0B);
  static const Color focusGlow = Color(0x6093C5FD);

  // Dark theme colors
  static const Color darkSurface = Color(0xFF0F1419);
  static const Color darkSurfaceVariant = Color(0xFF1A202C);
  static const Color darkBorder = Color(0xFF2D3748);

  // ============================================================================
  // TYPOGRAPHY SYSTEM
  // ============================================================================

  // Font Families
  static const String fontFamilySystem = 'SF Pro Display';
  static const String fontFamilyMono = 'SF Mono';

  // Typography Scale
  static const double fontSize48 = 48.0; // Display XL
  static const double fontSize36 = 36.0; // Display L
  static const double fontSize30 = 30.0; // Display M
  static const double fontSize24 = 24.0; // Display S
  static const double fontSize20 = 20.0; // Title L
  static const double fontSize18 = 18.0; // Title M
  static const double fontSize16 = 16.0; // Title S
  static const double fontSize14 = 14.0; // Body L
  static const double fontSize12 = 12.0; // Body S
  static const double fontSize11 = 11.0; // Caption

  // Text Styles
  static const TextStyle displayXL = TextStyle(
    fontSize: fontSize48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.1,
  );

  static const TextStyle displayL = TextStyle(
    fontSize: fontSize36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.2,
  );

  static const TextStyle displayM = TextStyle(
    fontSize: fontSize30,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle titleL = TextStyle(
    fontSize: fontSize20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleM = TextStyle(
    fontSize: fontSize18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle bodyL = TextStyle(
    fontSize: fontSize14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyS = TextStyle(
    fontSize: fontSize12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSize11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.3,
  );

  static const TextStyle monoL = TextStyle(
    fontSize: fontSize14,
    fontFamily: fontFamilyMono,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle monoS = TextStyle(
    fontSize: fontSize12,
    fontFamily: fontFamilyMono,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle displayS = TextStyle(
    fontSize: fontSize24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Add titleS as an alias for consistency
  static const TextStyle titleS = TextStyle(
    fontSize: fontSize16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ============================================================================
  // SHADOWS & DEPTH (Enhanced 6-level scale)
  // ============================================================================

  // Flat
  static const List<BoxShadow> shadowNone = [];

  // Subtle
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
      color: Color(0x0A000000),
    ),
  ];

  // Card level
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
      color: Color(0x0A000000),
    ),
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
      color: Color(0x05000000),
    ),
  ];

  // Modal level
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      color: Color(0x0A000000),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
      color: Color(0x05000000),
    ),
  ];

  // Floating/Lifted
  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
      color: Color(0x19000000),
    ),
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
      color: Color(0x0F000000),
    ),
  ];

  // Maximum elevation
  static const List<BoxShadow> shadow2Xl = [
    BoxShadow(
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
      color: Color(0x25000000),
    ),
  ];

  // Colored glows
  static const List<BoxShadow> shadowPrimary = [
    BoxShadow(offset: Offset(0, 8), blurRadius: 16, color: primaryGlow),
    BoxShadow(offset: Offset(0, 4), blurRadius: 6, color: Color(0x0A000000)),
  ];

  static const List<BoxShadow> shadowSuccess = [
    BoxShadow(offset: Offset(0, 8), blurRadius: 16, color: successGlow),
    BoxShadow(offset: Offset(0, 4), blurRadius: 6, color: Color(0x0A000000)),
  ];

  static const List<BoxShadow> shadowCritical = [
    BoxShadow(offset: Offset(0, 8), blurRadius: 16, color: criticalGlow),
    BoxShadow(offset: Offset(0, 4), blurRadius: 6, color: Color(0x0A000000)),
  ];

  // Inner shadows
  static const List<BoxShadow> shadowInner = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      color: Color(0x0F000000),
      spreadRadius: -1,
    ),
  ];

  // ============================================================================
  // BORDER RADIUS (Enhanced 8-level scale)
  // ============================================================================

  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 9999.0;

  // ============================================================================
  // SPACING SYSTEM (Enhanced 8px base grid)
  // ============================================================================

  static const double space0 = 0.0;
  static const double space0_5 = 2.0;
  static const double space1 = 4.0;
  static const double space1_5 = 6.0;
  static const double space2 = 8.0;
  static const double space2_5 = 10.0;
  static const double space3 = 12.0;
  static const double space3_5 = 14.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space7 = 28.0;
  static const double space8 = 32.0;
  static const double space9 = 36.0;
  static const double space10 = 40.0;
  static const double space11 = 44.0;
  static const double space12 = 48.0;
  static const double space14 = 56.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;
  static const double space24 = 96.0;

  // ============================================================================
  // ANIMATIONS & TRANSITIONS (Enhanced)
  // ============================================================================

  // Durations
  static const Duration durationInstant = Duration(milliseconds: 0);
  static const Duration duration75 = Duration(milliseconds: 75);
  static const Duration duration100 = Duration(milliseconds: 100);
  static const Duration duration150 = Duration(milliseconds: 150);
  static const Duration duration200 = Duration(milliseconds: 200);
  static const Duration duration300 = Duration(milliseconds: 300);
  static const Duration duration500 = Duration(milliseconds: 500);
  static const Duration duration700 = Duration(milliseconds: 700);
  static const Duration duration1000 = Duration(milliseconds: 1000);

  // Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // ============================================================================
  // GRADIENTS (Enhanced)
  // ============================================================================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue500, primaryBlue600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientHover = LinearGradient(
    colors: [primaryBlue400, primaryBlue500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [danger500, danger600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success500, success600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning500, warning600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassMorphismGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0x00FFFFFF), Color(0x20FFFFFF), Color(0x00FFFFFF)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
  );

  // ============================================================================
  // COMPONENT STYLES
  // ============================================================================

  // Card Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: gray50,
    borderRadius: BorderRadius.circular(radiusLg),
    boxShadow: shadowMd,
    border: Border.all(color: gray200, width: 1.0),
  );

  static BoxDecoration get cardDecorationHover => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusLg),
    boxShadow: shadowLg,
    border: Border.all(color: gray300, width: 1.0),
  );

  static BoxDecoration get glassMorphismDecoration => BoxDecoration(
    gradient: glassMorphismGradient,
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: glassMorphismBorder, width: 1.0),
    boxShadow: shadowMd,
  );

  // Button Styles
  static BoxDecoration get primaryButtonDecoration => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(radiusMd),
    boxShadow: shadowSm,
  );

  static BoxDecoration get primaryButtonHoverDecoration => BoxDecoration(
    gradient: primaryGradientHover,
    borderRadius: BorderRadius.circular(radiusMd),
    boxShadow: shadowMd,
  );

  static BoxDecoration get secondaryButtonDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: gray300, width: 1.0),
    boxShadow: shadowSm,
  );

  static BoxDecoration get ghostButtonDecoration => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(radiusMd),
  );

  static BoxDecoration get dangerButtonDecoration => BoxDecoration(
    gradient: dangerGradient,
    borderRadius: BorderRadius.circular(radiusMd),
    boxShadow: shadowSm,
  );

  // Badge Styles
  static BoxDecoration baseBadgeDecoration(
    Color backgroundColor,
    Color borderColor,
  ) => BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(radiusFull),
    border: Border.all(color: borderColor, width: 1.0),
  );

  static BoxDecoration get criticalBadgeDecoration => BoxDecoration(
    color: danger50,
    borderRadius: BorderRadius.circular(radiusFull),
    border: Border.all(color: danger200, width: 1.0),
    boxShadow: shadowCritical,
  );

  static BoxDecoration get activeBadgeDecoration => BoxDecoration(
    color: success50,
    borderRadius: BorderRadius.circular(radiusFull),
    border: Border.all(color: success200, width: 1.0),
  );

  // Input Styles
  static BoxDecoration get inputDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: gray300, width: 1.0),
  );

  static BoxDecoration get inputFocusDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: primaryBlue500, width: 2.0),
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 3,
        color: focusGlow,
      ),
    ],
  );

  static BoxDecoration get inputErrorDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: danger500, width: 1.0),
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 3,
        color: Color(0x20EF4444),
      ),
    ],
  );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  // Get status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'online':
      case 'success':
        return success500;
      case 'warning':
      case 'pending':
        return warning500;
      case 'error':
      case 'critical':
      case 'offline':
        return danger500;
      case 'info':
        return info500;
      default:
        return gray500;
    }
  }

  // Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return danger500;
      case 'high':
        return warning500;
      case 'medium':
        return primaryBlue500;
      case 'low':
        return success500;
      default:
        return gray500;
    }
  }

  // Shimmer animation
  static Widget shimmerEffect({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: shimmerGradient.colors,
              stops: shimmerGradient.stops,
              begin: Alignment(value - 1.0, 0.0),
              end: Alignment(value, 0.0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  // Additional color aliases for compatibility (moved here to fix undefined name errors)
  static const Color red600 = danger600;
  static const Color green600 = success600;
  static const Color orange600 = warning600;

  // White transparency colors for UI elements
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);

  // Glass morphism gradient
  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Design System Extensions for easy access
extension SpiroColors on Color {
  // Quick access to common colors
  static const primary = SpiroDesignSystem.primaryBlue500;
  static const primaryLight = SpiroDesignSystem.primaryBlue100;
  static const primaryDark = SpiroDesignSystem.primaryBlue900;
  static const secondary = SpiroDesignSystem.gray600;
  static const success = SpiroDesignSystem.success500;
  static const successLight = SpiroDesignSystem.success100;
  static const warning = SpiroDesignSystem.warning500;
  static const warningLight = SpiroDesignSystem.warning100;
  static const danger = SpiroDesignSystem.danger500;
  static const dangerLight = SpiroDesignSystem.danger100;
  static const info = SpiroDesignSystem.info500;
  static const infoLight = SpiroDesignSystem.info100;

  // Surface colors
  static const surface = SpiroDesignSystem.gray50;
  static const surfaceVariant = SpiroDesignSystem.gray100;
  static const outline = SpiroDesignSystem.gray300;
  static const onSurface = SpiroDesignSystem.gray900;
  static const onSurfaceVariant = SpiroDesignSystem.gray600;
}

/// Animation Extensions
extension SpiroAnimations on Widget {
  Widget fadeIn({
    Duration duration = SpiroDesignSystem.duration300,
    Curve curve = SpiroDesignSystem.easeOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: this,
    );
  }

  Widget slideIn({
    Duration duration = SpiroDesignSystem.duration300,
    Curve curve = SpiroDesignSystem.easeOut,
    Offset begin = const Offset(0.0, 0.3),
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(offset: value * 20, child: child);
      },
      child: this,
    );
  }

  Widget scaleIn({
    Duration duration = SpiroDesignSystem.duration200,
    Curve curve = SpiroDesignSystem.easeOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: this,
    );
  }
}
