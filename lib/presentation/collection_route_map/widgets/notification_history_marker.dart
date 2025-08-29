import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationHistoryMarker extends StatelessWidget {
  final String timestamp;
  final String status;
  final int deliveredCount;
  final VoidCallback onTap;

  const NotificationHistoryMarker({
    Key? key,
    required this.timestamp,
    required this.status,
    required this.deliveredCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDelivered = status == 'delivered';
    final Color statusColor = isDelivered
        ? AppTheme.lightTheme.primaryColor
        : AppTheme.lightTheme.colorScheme.error;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: statusColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: isDelivered ? 'check_circle' : 'error',
            color: statusColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class NotificationHistoryDialog extends StatelessWidget {
  final String timestamp;
  final String status;
  final int deliveredCount;
  final int totalResidents;
  final String streetName;

  const NotificationHistoryDialog({
    Key? key,
    required this.timestamp,
    required this.status,
    required this.deliveredCount,
    required this.totalResidents,
    required this.streetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDelivered = status == 'delivered';
    final Color statusColor = isDelivered
        ? AppTheme.lightTheme.primaryColor
        : AppTheme.lightTheme.colorScheme.error;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status icon
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: isDelivered ? 'check_circle' : 'error',
                  color: statusColor,
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Title
            Text(
              'Notification Details',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),

            // Street name
            _buildDetailRow('Street', streetName, context),
            SizedBox(height: 1.h),

            // Timestamp
            _buildDetailRow('Time', timestamp, context),
            SizedBox(height: 1.h),

            // Status
            _buildDetailRow('Status', status.toUpperCase(), context,
                valueColor: statusColor),
            SizedBox(height: 1.h),

            // Delivery count
            _buildDetailRow('Delivered',
                '$deliveredCount/$totalResidents residents', context),
            SizedBox(height: 3.h),

            // Close button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Close',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
