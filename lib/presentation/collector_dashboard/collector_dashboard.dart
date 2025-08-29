import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_card_widget.dart';
import './widgets/location_display_widget.dart';
import './widgets/notify_button_widget.dart';
import './widgets/status_indicator_widget.dart';

class CollectorDashboard extends StatefulWidget {
  const CollectorDashboard({super.key});

  @override
  State<CollectorDashboard> createState() => _CollectorDashboardState();
}

class _CollectorDashboardState extends State<CollectorDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLocationAccurate = true;
  bool _isNotificationLoading = false;
  bool _isConnected = true;
  String _currentStreet = "Maple Street, Block A";
  int _notificationsSent = 0;
  int _residentsReached = 0;
  int _acknowledgments = 0;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _mockRouteData = [
    {
      "street": "Maple Street, Block A",
      "households": 24,
      "completed": 0,
      "status": "current"
    },
    {
      "street": "Oak Avenue, Block B",
      "households": 18,
      "completed": 0,
      "status": "pending"
    },
    {
      "street": "Pine Road, Block C",
      "households": 32,
      "completed": 0,
      "status": "pending"
    },
  ];

  final List<Map<String, dynamic>> _mockNotificationHistory = [
    {
      "id": 1,
      "street": "Elm Street, Block D",
      "timestamp": "2025-08-29 04:45:00",
      "residents_notified": 28,
      "acknowledgments": 22,
      "status": "completed"
    },
    {
      "id": 2,
      "street": "Cedar Lane, Block E",
      "timestamp": "2025-08-29 04:20:00",
      "residents_notified": 15,
      "acknowledgments": 12,
      "status": "completed"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _simulateLocationUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateLocationUpdates() {
    // Simulate periodic location updates
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLocationAccurate = true;
        });
      }
    });
  }

  Future<void> _refreshLocation() async {
    setState(() {
      _isLocationAccurate = false;
    });

    HapticFeedback.lightImpact();

    // Simulate location refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLocationAccurate = true;
      });
    }
  }

  Future<void> _sendNotification() async {
    setState(() {
      _isNotificationLoading = true;
    });

    // Simulate notification sending
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isNotificationLoading = false;
        _notificationsSent++;
        _residentsReached += 24; // Current street households
        _acknowledgments += 18; // Simulated acknowledgments
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('✅'),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Notification sent to 24 residents on $_currentStreet',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshLocation,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicators
            Row(
              children: [
                Expanded(
                  child: StatusIndicatorWidget(
                    title: 'Network',
                    value: _isConnected ? 'Connected' : 'Offline',
                    color: _isConnected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.error,
                    emoji: _isConnected ? '📶' : '📵',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: StatusIndicatorWidget(
                    title: 'GPS Status',
                    value: _isLocationAccurate ? 'Accurate' : 'Searching',
                    color: _isLocationAccurate
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.error,
                    emoji: _isLocationAccurate ? '🎯' : '🔍',
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // Location display
            LocationDisplayWidget(
              currentStreet: _currentStreet,
              isLocationAccurate: _isLocationAccurate,
              onRefresh: _refreshLocation,
            ),
            SizedBox(height: 4.h),

            // Notify button
            NotifyButtonWidget(
              isLoading: _isNotificationLoading,
              onPressed: _sendNotification,
            ),
            SizedBox(height: 4.h),

            // Action cards
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Route Progress',
              subtitle: '1 of 3 streets completed today',
              emoji: '🗺️',
              onTap: () =>
                  Navigator.pushNamed(context, '/collection-route-map'),
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Notification History',
              subtitle: '$_notificationsSent notifications sent today',
              emoji: '📋',
              onTap: () {
                _tabController.animateTo(2);
              },
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Collection Schedule',
              subtitle: 'View today\'s collection routes',
              emoji: '📅',
              onTap: () =>
                  Navigator.pushNamed(context, '/collection-route-map'),
            ),
            SizedBox(height: 4.h),

            // Statistics
            Text(
              'Today\'s Statistics',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            Row(
              children: [
                Expanded(
                  child: StatusIndicatorWidget(
                    title: 'Residents Reached',
                    value: '$_residentsReached',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    emoji: '🏠',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: StatusIndicatorWidget(
                    title: 'Acknowledgments',
                    value: '$_acknowledgments',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    emoji: '✅',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Collection Route',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockRouteData.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final route = _mockRouteData[index];
              final isCurrent = (route["status"] as String) == "current";
              final isCompleted = (route["status"] as String) == "completed";

              return Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: isCurrent
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                    width: isCurrent ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppTheme.lightTheme.colorScheme.primary
                            : isCompleted
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          isCurrent
                              ? '🚛'
                              : isCompleted
                                  ? '✅'
                                  : '⏳',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route["street"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isCurrent
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${route["households"]} households',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          'CURRENT',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification History',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _mockNotificationHistory.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        '📋',
                        style: TextStyle(fontSize: 48.sp),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No notifications sent yet',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Your notification history will appear here',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mockNotificationHistory.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final notification =
                        _mockNotificationHistory[index];
                    final timestamp =
                        DateTime.parse(notification["timestamp"] as String);
                    final timeString =
                        "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";

                    return Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                                child: Text(
                                  '✅',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification["street"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Sent at $timeString',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Expanded(
                                child: StatusIndicatorWidget(
                                  title: 'Notified',
                                  value:
                                      '${notification["residents_notified"]}',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  emoji: '🏠',
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: StatusIndicatorWidget(
                                  title: 'Acknowledged',
                                  value: '${notification["acknowledgments"]}',
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  emoji: '✅',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Collector Dashboard',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/settings-and-preferences'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Route'),
            Tab(text: 'History'),
          ],
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildRouteTab(),
          _buildHistoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  const Text('❓'),
                  SizedBox(width: 2.w),
                  const Text('Field Support'),
                ],
              ),
              content: Text(
                'Need help with the app or have technical issues? Contact field support for immediate assistance.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📞 Connecting to field support...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Call Support'),
                ),
              ],
            ),
          );
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        child: CustomIconWidget(
          iconName: 'help',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 24,
        ),
      ),
    );
  }
}
