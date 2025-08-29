import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsListTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? iconName;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor;

  const SettingsListTileWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.iconName,
    this.onTap,
    this.trailing,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.w),
        child: Row(
          children: [
            iconName != null
                ? Container(
                    margin: EdgeInsets.only(right: 3.w),
                    child: CustomIconWidget(
                      iconName: iconName!,
                      color:
                          titleColor ?? AppTheme.lightTheme.colorScheme.primary,
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
                      color: titleColor,
                    ),
                  ),
                  subtitle != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: Text(
                            subtitle!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            trailing ??
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
          ],
        ),
      ),
    );
  }
}
