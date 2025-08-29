import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuietHoursWidget extends StatelessWidget {
  final bool isEnabled;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;

  const QuietHoursWidget({
    Key? key,
    required this.isEnabled,
    required this.startTime,
    required this.endTime,
    required this.onEnabledChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsToggleWidget(
          title: 'Quiet Hours',
          subtitle: 'Disable notifications during specified hours',
          value: isEnabled,
          onChanged: onEnabledChanged,
          iconName: 'bedtime',
        ),
        isEnabled
            ? Container(
                margin: EdgeInsets.only(top: 1.h, left: 6.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTimeSelector(
                        context,
                        'Start',
                        startTime,
                        onStartTimeChanged,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: _buildTimeSelector(
                        context,
                        'End',
                        endTime,
                        onEndTimeChanged,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTimeSelector(
    BuildContext context,
    String label,
    TimeOfDay time,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (selectedTime != null) {
          onChanged(selectedTime);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              time.format(context),
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsToggleWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? iconName;

  const SettingsToggleWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: [
          iconName != null
              ? Container(
                  margin: EdgeInsets.only(right: 3.w),
                  child: CustomIconWidget(
                    iconName: iconName!,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          subtitle!,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
