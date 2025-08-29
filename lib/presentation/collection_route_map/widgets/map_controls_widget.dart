import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapControlsWidget extends StatelessWidget {
  final VoidCallback onLocationPressed;
  final VoidCallback onMapTypeToggle;
  final bool isStandardMap;

  const MapControlsWidget({
    Key? key,
    required this.onLocationPressed,
    required this.onMapTypeToggle,
    required this.isStandardMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12.h,
      right: 4.w,
      child: Column(
        children: [
          // Location centering button
          Container(
            width: 12.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onLocationPressed,
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'my_location',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Map type toggle button
          Container(
            width: 12.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onMapTypeToggle,
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isStandardMap ? 'satellite' : 'map',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
