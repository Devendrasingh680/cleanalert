import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

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
