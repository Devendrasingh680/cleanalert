import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alert_notification_card.dart';
import './widgets/collection_schedule_item.dart';
import './widgets/empty_alert_state.dart';
import './widgets/recent_alerts_section.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({Key? key}) : super(key: key);

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _hasActiveAlert = false;
  bool _isRefreshing = false;

  // Mock data for active alert
  final Map<String, dynamic> _activeAlert = {
    "id": 1,
    "title": "🚛 Collector Arrived!",
    "message":
        "Your garbage collector has arrived on Maple Street. Please bring out your waste bins.",
    "location": "Maple Street",
    "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
    "status": "pending",
    "collectorId": "GC001",
    "collectorName": "Mike Johnson"
  };

  // Mock data for collection schedule
  final List<Map<String, dynamic>> _collectionSchedule = [
    {
      "id": 1,
      "day": "Today",
      "time": "8:00 AM",
      "wasteType": "general",
      "status": "in_progress",
      "location": "Maple Street"
    },
    {
      "id": 2,
      "day": "Wednesday",
      "time": "8:30 AM",
      "wasteType": "recyclable",
      "status": "upcoming",
      "location": "Maple Street"
    },
    {
      "id": 3,
      "day": "Friday",
      "time": "9:00 AM",
      "wasteType": "organic",
      "status": "upcoming",
      "location": "Maple Street"
    },
    {
      "id": 4,
      "day": "Saturday",
      "time": "7:30 AM",
      "wasteType": "hazardous",
      "status": "upcoming",
      "location": "Maple Street"
    }
  ];

  // Mock data for recent alerts
  final List<Map<String, dynamic>> _recentAlerts = [
    {
      "id": 1,
      "title": "Collection Completed",
      "message": "Your waste has been collected successfully",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "acknowledged",
      "location": "Maple Street"
    },
    {
      "id": 2,
      "title": "Collector Arrived",
      "message": "Garbage truck arrived on your street",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "status": "acknowledged",
      "location": "Maple Street"
    },
    {
      "id": 3,
      "title": "Collection Reminder",
      "message": "Don't forget to put out your recyclables tomorrow",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "status": "dismissed",
      "location": "Maple Street"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _simulateIncomingAlert();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateIncomingAlert() {
    // Simulate receiving an alert after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _hasActiveAlert = true;
        });
        _showSystemNotification();
      }
    });
  }

  void _showSystemNotification() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text("🚛", style: TextStyle(fontSize: 16)),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                "Garbage collector has arrived on your street!",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.secondaryLight,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ Updated successfully",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.surface,
            ),
          ),
          backgroundColor: AppTheme.successLight,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleAlertDismiss() {
    HapticFeedback.lightImpact();
    setState(() {
      _hasActiveAlert = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Alert dismissed",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.surface,
          ),
        ),
        backgroundColor: AppTheme.textSecondaryLight,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAlertAcknowledge() {
    HapticFeedback.mediumImpact();
    setState(() {
      _hasActiveAlert = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.surface,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                "Thank you! Feedback sent to municipal system",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleViewAllAlerts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAlertHistoryModal(),
    );
  }

  Widget _buildAlertHistoryModal() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Alert History",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondaryLight,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: _recentAlerts.length,
              itemBuilder: (context, index) {
                final alert = _recentAlerts[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert["title"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        alert["message"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _formatTimestamp(alert["timestamp"]),
                        style:
                            AppTheme.dataTextStyle(isLight: true, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
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
      } else {
        return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
      }
    } catch (e) {
      return "Just now";
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  Map<String, dynamic>? _getNextCollection() {
    final upcomingCollections = (_collectionSchedule as List)
        .where((dynamic item) =>
            (item as Map<String, dynamic>)["status"] == "upcoming")
        .toList();

    return upcomingCollections.isNotEmpty
        ? upcomingCollections.first as Map<String, dynamic>
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              "🏠",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Home",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getCurrentDate(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-preferences'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textSecondaryLight,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.secondaryLight,
          unselectedLabelColor: AppTheme.textSecondaryLight,
          indicatorColor: AppTheme.secondaryLight,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Home"),
            Tab(text: "Schedule"),
            Tab(text: "Settings"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildScheduleTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.secondaryLight,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // Alert Reception Zone
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications_active',
                        color: AppTheme.secondaryLight,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Alert Zone",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.secondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Active Alert or Empty State
                  _hasActiveAlert
                      ? AlertNotificationCard(
                          alertData: _activeAlert,
                          onDismiss: _handleAlertDismiss,
                          onAcknowledge: _handleAlertAcknowledge,
                        )
                      : EmptyAlertState(
                          nextCollection: _getNextCollection(),
                        ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Recent Alerts Section
            RecentAlertsSection(
              recentAlerts: _recentAlerts,
              onViewAll: _handleViewAllAlerts,
            ),

            SizedBox(height: 4.h),

            // Quick Actions
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Actions",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: 'map',
                          title: "View Route",
                          subtitle: "Track collector",
                          onTap: () => Navigator.pushNamed(
                              context, '/collection-route-map'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: 'person_switch',
                          title: "Switch Role",
                          subtitle: "Collector mode",
                          onTap: () => Navigator.pushNamed(
                              context, '/user-role-selection'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Collection Schedule",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Your weekly waste collection schedule",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Schedule List
          Column(
            children: (_collectionSchedule as List)
                .map<Widget>((dynamic scheduleItem) {
              final schedule = scheduleItem as Map<String, dynamic>;
              return CollectionScheduleItem(scheduleData: schedule);
            }).toList(),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  "Manage your preferences and notifications",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Settings Options
          _buildSettingsOption(
            icon: 'notifications',
            title: "Notification Settings",
            subtitle: "Manage alert preferences",
            onTap: () =>
                Navigator.pushNamed(context, '/settings-and-preferences'),
          ),

          _buildSettingsOption(
            icon: 'location_on',
            title: "Location Settings",
            subtitle: "Update your address",
            onTap: () {},
          ),

          _buildSettingsOption(
            icon: 'schedule',
            title: "Collection Preferences",
            subtitle: "Set reminder times",
            onTap: () {},
          ),

          _buildSettingsOption(
            icon: 'help',
            title: "Help & Support",
            subtitle: "Get assistance",
            onTap: () {},
          ),

          _buildSettingsOption(
            icon: 'info',
            title: "About CleanAlert",
            subtitle: "App information",
            onTap: () {},
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
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
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.primaryLight,
                  size: 18,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
