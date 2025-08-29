import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RouteProgressWidget extends StatelessWidget {
  final int completedStreets;
  final int totalStreets;
  final double progressPercentage;

  const RouteProgressWidget({
    Key? key,
    required this.completedStreets,
    required this.totalStreets,
    required this.progressPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.h,
      left: 4.w,
      right: 20.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Route Progress',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$completedStreets/$totalStreets',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: progressPercentage / 100,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor),
              minHeight: 6,
            ),
            SizedBox(height: 0.5.h),
            Text(
              '${progressPercentage.toStringAsFixed(0)}% Complete',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
