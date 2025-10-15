import 'package:flutter/material.dart';

import '../../utils/DesignSystem.dart';

enum BadgeType { success, warning, danger, info, neutral }

class ModernBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final bool isPulsing;
  final IconData? icon;
  final double? fontSize;

  const ModernBadge({
    Key? key,
    required this.text,
    this.type = BadgeType.neutral,
    this.isPulsing = false,
    this.icon,
    this.fontSize,
  }) : super(key: key);

  Color _getBackgroundColor() {
    switch (type) {
      case BadgeType.success:
        return SpiroDesignSystem.success50;
      case BadgeType.warning:
        return SpiroDesignSystem.warning50;
      case BadgeType.danger:
        return SpiroDesignSystem.danger50;
      case BadgeType.info:
        return SpiroDesignSystem.info50;
      case BadgeType.neutral:
        return SpiroDesignSystem.gray100;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case BadgeType.success:
        return SpiroDesignSystem.success200;
      case BadgeType.warning:
        return SpiroDesignSystem.warning200;
      case BadgeType.danger:
        return SpiroDesignSystem.danger200;
      case BadgeType.info:
        return SpiroDesignSystem.info200;
      case BadgeType.neutral:
        return SpiroDesignSystem.gray300;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case BadgeType.success:
        return SpiroDesignSystem.success700;
      case BadgeType.warning:
        return SpiroDesignSystem.warning700;
      case BadgeType.danger:
        return SpiroDesignSystem.danger700;
      case BadgeType.info:
        return SpiroDesignSystem.info700;
      case BadgeType.neutral:
        return SpiroDesignSystem.gray700;
    }
  }

  List<BoxShadow> _getShadow() {
    switch (type) {
      case BadgeType.success:
        return isPulsing ? SpiroDesignSystem.shadowSuccess : [];
      case BadgeType.danger:
        return isPulsing ? SpiroDesignSystem.shadowCritical : [];
      case BadgeType.info:
        return isPulsing ? SpiroDesignSystem.shadowPrimary : [];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpiroDesignSystem.space2_5,
        vertical: SpiroDesignSystem.space1,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusFull),
        border: Border.all(color: _getBorderColor(), width: 1),
        boxShadow: _getShadow(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize ?? SpiroDesignSystem.fontSize11,
              color: _getTextColor(),
            ),
            SizedBox(width: SpiroDesignSystem.space1),
          ],
          Text(
            text,
            style: SpiroDesignSystem.caption.copyWith(
              fontSize: fontSize ?? SpiroDesignSystem.fontSize11,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
          ),
        ],
      ),
    );

    if (isPulsing) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1.0),
        duration: SpiroDesignSystem.duration1000,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: badge);
        },
        onEnd: () {
          // Animation will repeat automatically due to TweenAnimationBuilder
        },
      );
    }

    return badge;
  }
}

class ModernCard extends StatefulWidget {
  final Widget child;
  final String? title;
  final IconData? titleIcon;
  final Color? titleIconColor;
  final VoidCallback? onTap;
  final bool hasHoverEffect;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ModernCard({
    Key? key,
    required this.child,
    this.title,
    this.titleIcon,
    this.titleIconColor,
    this.onTap,
    this.hasHoverEffect = true,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SpiroDesignSystem.duration200,
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: SpiroDesignSystem.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.hasHoverEffect) {
          setState(() => _isHovered = true);
          _controller.forward();
        }
      },
      onExit: (_) {
        if (widget.hasHoverEffect) {
          setState(() => _isHovered = false);
          _controller.reverse();
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, child) {
            return Container(
              margin: widget.margin ?? EdgeInsets.zero,
              decoration: BoxDecoration(
                color: SpiroDesignSystem.gray50,
                borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusLg),
                border: Border.all(
                  color: _isHovered
                      ? SpiroDesignSystem.primaryBlue200
                      : SpiroDesignSystem.gray200,
                  width: 1,
                ),
                boxShadow: _isHovered
                    ? SpiroDesignSystem.shadowLg
                    : SpiroDesignSystem.shadowMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null) ...[
                    Container(
                      padding: EdgeInsets.all(SpiroDesignSystem.space4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            SpiroDesignSystem.gray50,
                            SpiroDesignSystem.gray100.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(SpiroDesignSystem.radiusLg),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (widget.titleIcon != null) ...[
                            Container(
                              padding: EdgeInsets.all(SpiroDesignSystem.space2),
                              decoration: BoxDecoration(
                                color:
                                    (widget.titleIconColor ??
                                            SpiroDesignSystem.primaryBlue500)
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  SpiroDesignSystem.radiusMd,
                                ),
                                border: Border.all(
                                  color:
                                      (widget.titleIconColor ??
                                              SpiroDesignSystem.primaryBlue500)
                                          .withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                widget.titleIcon,
                                color:
                                    widget.titleIconColor ??
                                    SpiroDesignSystem.primaryBlue500,
                                size: 18,
                              ),
                            ),
                            SizedBox(width: SpiroDesignSystem.space3),
                          ],
                          Expanded(
                            child: Text(
                              widget.title!,
                              style: SpiroDesignSystem.titleM.copyWith(
                                fontWeight: FontWeight.w600,
                                color: SpiroDesignSystem.gray900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Expanded(
                    child: Container(
                      padding:
                          widget.padding ??
                          EdgeInsets.all(SpiroDesignSystem.space4),
                      child: widget.child,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ModernInput extends StatefulWidget {
  final String label;
  final String? placeholder;
  final String? value;
  final ValueChanged<String>? onChanged;
  final bool isPassword;
  final bool hasError;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;

  const ModernInput({
    Key? key,
    required this.label,
    this.placeholder,
    this.value,
    this.onChanged,
    this.isPassword = false,
    this.hasError = false,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
  }) : super(key: key);

  @override
  State<ModernInput> createState() => _ModernInputState();
}

class _ModernInputState extends State<ModernInput> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(text: widget.value);

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  BoxDecoration _getDecoration() {
    if (widget.hasError) {
      return SpiroDesignSystem.inputErrorDecoration;
    } else if (_isFocused) {
      return SpiroDesignSystem.inputFocusDecoration;
    } else {
      return SpiroDesignSystem.inputDecoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: SpiroDesignSystem.bodyL.copyWith(
            fontWeight: FontWeight.w600,
            color: SpiroDesignSystem.gray700,
          ),
        ),
        SizedBox(height: SpiroDesignSystem.space2),
        AnimatedContainer(
          duration: SpiroDesignSystem.duration200,
          decoration: _getDecoration(),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword,
            onChanged: widget.onChanged,
            style: SpiroDesignSystem.bodyL.copyWith(
              color: SpiroDesignSystem.gray900,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: SpiroDesignSystem.bodyL.copyWith(
                color: SpiroDesignSystem.gray500,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(SpiroDesignSystem.space4),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? SpiroDesignSystem.primaryBlue500
                          : SpiroDesignSystem.gray500,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? IconButton(
                      icon: Icon(
                        widget.suffixIcon,
                        color: SpiroDesignSystem.gray500,
                      ),
                      onPressed: widget.onSuffixIconTap,
                    )
                  : null,
            ),
          ),
        ),
        if (widget.hasError && widget.errorText != null) ...[
          SizedBox(height: SpiroDesignSystem.space1),
          Text(
            widget.errorText!,
            style: SpiroDesignSystem.bodyS.copyWith(
              color: SpiroDesignSystem.danger500,
            ),
          ),
        ],
      ],
    );
  }
}
