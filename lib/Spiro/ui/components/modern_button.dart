import 'package:flutter/material.dart';

import '../../utils/DesignSystem.dart';

enum ModernButtonStyle { primary, secondary, ghost, danger, success }

class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;

  const ModernButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.style = ModernButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SpiroDesignSystem.duration150,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: SpiroDesignSystem.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BoxDecoration _getDecoration() {
    switch (widget.style) {
      case ModernButtonStyle.primary:
        return _isHovered
            ? SpiroDesignSystem.primaryButtonHoverDecoration
            : SpiroDesignSystem.primaryButtonDecoration;
      case ModernButtonStyle.secondary:
        return SpiroDesignSystem.secondaryButtonDecoration;
      case ModernButtonStyle.ghost:
        return SpiroDesignSystem.ghostButtonDecoration;
      case ModernButtonStyle.danger:
        return SpiroDesignSystem.dangerButtonDecoration;
      case ModernButtonStyle.success:
        return BoxDecoration(
          gradient: SpiroDesignSystem.successGradient,
          borderRadius: BorderRadius.circular(SpiroDesignSystem.radiusMd),
          boxShadow: SpiroDesignSystem.shadowSm,
        );
    }
  }

  Color _getTextColor() {
    switch (widget.style) {
      case ModernButtonStyle.primary:
      case ModernButtonStyle.danger:
      case ModernButtonStyle.success:
        return Colors.white;
      case ModernButtonStyle.secondary:
      case ModernButtonStyle.ghost:
        return SpiroDesignSystem.primaryBlue600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          if (widget.onPressed != null) widget.onPressed!();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? _scaleAnimation.value : 1.0,
              child: AnimatedContainer(
                duration: SpiroDesignSystem.duration200,
                width: widget.width,
                height: widget.height ?? 48,
                decoration: _getDecoration(),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.isLoading ? null : widget.onPressed,
                    borderRadius: BorderRadius.circular(
                      SpiroDesignSystem.radiusMd,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SpiroDesignSystem.space4,
                        vertical: SpiroDesignSystem.space3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isLoading) ...[
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTextColor(),
                                ),
                              ),
                            ),
                            SizedBox(width: SpiroDesignSystem.space2),
                          ] else if (widget.icon != null) ...[
                            Icon(widget.icon, color: _getTextColor(), size: 18),
                            SizedBox(width: SpiroDesignSystem.space2),
                          ],
                          Text(
                            widget.text,
                            style: SpiroDesignSystem.bodyL.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getTextColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
