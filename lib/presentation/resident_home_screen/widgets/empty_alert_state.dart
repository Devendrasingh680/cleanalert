import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyAlertState extends StatelessWidget {
  final Map<String, dynamic>? nextCollection;

  const EmptyAlertState({
    Key? key,
    this.nextCollection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                "🏠",
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "No Active Alerts",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            "You'll receive notifications when garbage collectors arrive on your street",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (nextCollection != null) ...[
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.primaryLight,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Next Collection",
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "${nextCollection!["day"] as String? ?? "Tomorrow"} at ${nextCollection!["time"] as String? ?? "8:00 AM"}",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _formatWasteType(
                        nextCollection!["wasteType"] as String? ?? "general"),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatWasteType(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'recyclable':
        return "♻️ Recyclable Waste";
      case 'organic':
        return "🌱 Organic Waste";
      case 'hazardous':
        return "⚠️ Hazardous Waste";
      default:
        return "🗑️ General Waste";
    }
  }
}
