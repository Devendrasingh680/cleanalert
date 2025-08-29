import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LearnMoreBottomSheet extends StatelessWidget {
  const LearnMoreBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Role Information',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoleSection(
                    emoji: '🚛',
                    title: 'Collector Role',
                    description:
                        'Municipal waste collectors use this interface to notify residents when they arrive on their street. Features include:',
                    features: [
                      'Send arrival notifications to residents',
                      'Track collection routes and schedules',
                      'Update collection status in real-time',
                      'Access location-based services',
                    ],
                    backgroundColor: AppTheme.primaryLight,
                  ),
                  SizedBox(height: 3.h),
                  _buildRoleSection(
                    emoji: '🏠',
                    title: 'Resident Role',
                    description:
                        'Residents receive instant notifications when waste collectors arrive. Features include:',
                    features: [
                      'Receive real-time arrival notifications',
                      'View collection schedules and updates',
                      'Track waste collection history',
                      'Manage notification preferences',
                    ],
                    backgroundColor: AppTheme.secondaryLight,
                  ),
                  SizedBox(height: 3.h),
                  _buildInfoSection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSection({
    required String emoji,
    required String title,
    required String description,
    required List<String> features,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: backgroundColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(width: 3.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: backgroundColor,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 2.h),
          ...features.map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIconWidget(
                      iconName: 'check',
                      color: backgroundColor,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        feature,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Important Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'You can change your role anytime in the Settings. This app is part of our municipal partnership program to improve waste collection efficiency.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Both roles require location permissions for optimal functionality and real-time coordination.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: 13.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
