import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ContinueButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const ContinueButton({
    Key? key,
    required this.isEnabled,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 7.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.outline,
          foregroundColor: AppTheme.lightTheme.colorScheme.surface,
          elevation: isEnabled ? 4 : 0,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Text(
          'Continue',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.surface,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
