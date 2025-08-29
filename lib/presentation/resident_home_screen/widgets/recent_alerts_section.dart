import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentAlertsSection extends StatelessWidget {
  final List<Map<String, dynamic>> recentAlerts;
  final VoidCallback onViewAll;

  const RecentAlertsSection({
    Key? key,
    required this.recentAlerts,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Alerts",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  "View All",
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.secondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          recentAlerts.isEmpty ? _buildEmptyState() : _buildAlertsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            "📭",
            style: TextStyle(fontSize: 48),
          ),
          SizedBox(height: 2.h),
          Text(
            "No Recent Alerts",
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            "You'll see your collection notifications here",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    return Column(
      children: (recentAlerts as List).take(3).map<Widget>((dynamic alertItem) {
        final alert = alertItem as Map<String, dynamic>;
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: _getAlertStatusColor(
                          alert["status"] as String? ?? "acknowledged")
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: _getAlertStatusIcon(
                        alert["status"] as String? ?? "acknowledged"),
                    color: _getAlertStatusColor(
                        alert["status"] as String? ?? "acknowledged"),
                    size: 16,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert["title"] as String? ?? "Collection Alert",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _formatAlertTimestamp(alert["timestamp"]),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getAlertStatusColor(
                          alert["status"] as String? ?? "acknowledged")
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatAlertStatus(
                      alert["status"] as String? ?? "acknowledged"),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getAlertStatusColor(
                        alert["status"] as String? ?? "acknowledged"),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getAlertStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'acknowledged':
        return AppTheme.successLight;
      case 'dismissed':
        return AppTheme.textSecondaryLight;
      case 'pending':
        return AppTheme.warningLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  String _getAlertStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'acknowledged':
        return 'check_circle';
      case 'dismissed':
        return 'cancel';
      case 'pending':
        return 'schedule';
      default:
        return 'notifications';
    }
  }

  String _formatAlertStatus(String status) {
    switch (status.toLowerCase()) {
      case 'acknowledged':
        return "Read";
      case 'dismissed':
        return "Dismissed";
      case 'pending':
        return "Pending";
      default:
        return "New";
    }
  }

  String _formatAlertTimestamp(dynamic timestamp) {
    if (timestamp == null) return "Just now";

    try {
      DateTime dateTime;
      if (timestamp is DateTime) {
        dateTime = timestamp;
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return "Just now";
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes}m ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours}h ago";
      } else if (difference.inDays < 7) {
        return "${difference.inDays}d ago";
      } else {
        return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
      }
    } catch (e) {
      return "Just now";
    }
  }
}
