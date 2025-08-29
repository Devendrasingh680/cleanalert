import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationDisplayWidget extends StatelessWidget {
  final String currentStreet;
  final bool isLocationAccurate;
  final VoidCallback? onRefresh;

  const LocationDisplayWidget({
    super.key,
    required this.currentStreet,
    required this.isLocationAccurate,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: isLocationAccurate
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '📍',
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Current Location',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onRefresh != null)
                GestureDetector(
                  onTap: onRefresh,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    child: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            currentStreet,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isLocationAccurate
                  ? AppTheme.lightTheme.colorScheme.primaryContainer
                  : AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: isLocationAccurate ? 'gps_fixed' : 'gps_not_fixed',
                  color: isLocationAccurate
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  isLocationAccurate ? 'GPS Accurate' : 'GPS Searching...',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isLocationAccurate
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
