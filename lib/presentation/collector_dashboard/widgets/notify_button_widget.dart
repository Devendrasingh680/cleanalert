import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotifyButtonWidget extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const NotifyButtonWidget({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<NotifyButtonWidget> createState() => _NotifyButtonWidgetState();
}

class _NotifyButtonWidgetState extends State<NotifyButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isLoading) {
      HapticFeedback.mediumImpact();
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 14.h,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLoading
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                elevation: widget.isLoading ? 0 : 4,
                shadowColor: AppTheme.lightTheme.colorScheme.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.w),
                ),
                padding: EdgeInsets.symmetric(vertical: 4.h),
              ),
              child: widget.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 6.w,
                          height: 6.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Sending Notification...',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🚛',
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Notify Residents',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
