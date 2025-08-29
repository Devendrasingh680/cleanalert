import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/continue_button.dart';
import './widgets/learn_more_bottom_sheet.dart';
import './widgets/role_selection_card.dart';

enum UserRole { none, collector, resident }

class UserRoleSelection extends StatefulWidget {
  const UserRoleSelection({Key? key}) : super(key: key);

  @override
  State<UserRoleSelection> createState() => _UserRoleSelectionState();
}

class _UserRoleSelectionState extends State<UserRoleSelection> {
  UserRole _selectedRole = UserRole.none;

  final List<Map<String, dynamic>> _roleData = [
    {
      "role": UserRole.collector,
      "emoji": "🚛",
      "title": "Waste Collector",
      "description": "I collect waste for the municipality",
      "backgroundColor": AppTheme.primaryLight,
      "route": "/collector-dashboard",
    },
    {
      "role": UserRole.resident,
      "emoji": "🏠",
      "title": "Resident",
      "description": "I need waste collection notifications",
      "backgroundColor": AppTheme.secondaryLight,
      "route": "/resident-home-screen",
    },
  ];

  void _selectRole(UserRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _showLearnMoreBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LearnMoreBottomSheet(),
    );
  }

  void _handleContinue() {
    if (_selectedRole == UserRole.none) return;

    final selectedRoleData = _roleData.firstWhere(
      (data) => data["role"] == _selectedRole,
    );

    // Navigate to appropriate screen based on selected role
    Navigator.pushNamed(context, selectedRoleData["route"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            _buildHeader(),

            // Role selection cards
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Role cards
                    ..._roleData.map((roleData) => RoleSelectionCard(
                          emoji: roleData["emoji"],
                          title: roleData["title"],
                          description: roleData["description"],
                          backgroundColor: roleData["backgroundColor"],
                          isSelected: _selectedRole == roleData["role"],
                          onTap: () => _selectRole(roleData["role"]),
                        )),

                    SizedBox(height: 3.h),

                    // Information text
                    _buildInfoText(),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Bottom section with continue button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Column(
        children: [
          // App logo/branding
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🛎',
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // App name
          Text(
            'CleanAlert',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.primaryColor,
              fontSize: 24.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Subtitle
          Text(
            'Choose your role to get started',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'You can change your role later',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Role switching is available in Settings after initial setup',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Learn more link
          GestureDetector(
            onTap: _showLearnMoreBottomSheet,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Learn More',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 3.w,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Continue button
          ContinueButton(
            isEnabled: _selectedRole != UserRole.none,
            onPressed: _handleContinue,
          ),

          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
