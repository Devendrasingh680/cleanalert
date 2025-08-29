import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CollectionScheduleItem extends StatelessWidget {
  final Map<String, dynamic> scheduleData;

  const CollectionScheduleItem({
    Key? key,
    required this.scheduleData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
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
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getWasteTypeColor(
                  scheduleData["wasteType"] as String? ?? "general"),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _getWasteTypeEmoji(
                    scheduleData["wasteType"] as String? ?? "general"),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheduleData["day"] as String? ?? "Today",
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "${scheduleData["time"] as String? ?? "8:00 AM"} • ${_formatWasteType(scheduleData["wasteType"] as String? ?? "general")}",
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
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getStatusColor(
                      scheduleData["status"] as String? ?? "upcoming")
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatStatus(scheduleData["status"] as String? ?? "upcoming"),
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: _getStatusColor(
                    scheduleData["status"] as String? ?? "upcoming"),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getWasteTypeColor(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'recyclable':
        return AppTheme.secondaryLight;
      case 'organic':
        return AppTheme.successLight;
      case 'hazardous':
        return AppTheme.errorLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getWasteTypeEmoji(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'recyclable':
        return "♻️";
      case 'organic':
        return "🌱";
      case 'hazardous':
        return "⚠️";
      default:
        return "🗑️";
    }
  }

  String _formatWasteType(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'recyclable':
        return "Recyclable Waste";
      case 'organic':
        return "Organic Waste";
      case 'hazardous':
        return "Hazardous Waste";
      default:
        return "General Waste";
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successLight;
      case 'in_progress':
        return AppTheme.warningLight;
      case 'missed':
        return AppTheme.errorLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return "Completed";
      case 'in_progress':
        return "In Progress";
      case 'missed':
        return "Missed";
      default:
        return "Upcoming";
    }
  }
}
