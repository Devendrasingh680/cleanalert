import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/quiet_hours_widget.dart';
import './widgets/role_selector_widget.dart';
import './widgets/settings_list_tile_widget.dart';
import './widgets/settings_section_widget.dart';
import 'widgets/quiet_hours_widget.dart';
import 'widgets/role_selector_widget.dart';
import 'widgets/settings_list_tile_widget.dart';
import 'widgets/settings_section_widget.dart';
import 'widgets/settings_toggle_widget.dart';

class SettingsAndPreferences extends StatefulWidget {
  const SettingsAndPreferences({Key? key}) : super(key: key);

  @override
  State<SettingsAndPreferences> createState() => _SettingsAndPreferencesState();
}

class _SettingsAndPreferencesState extends State<SettingsAndPreferences> {
  // User role state
  String _currentRole = 'Collector';

  // Notification preferences
  bool _pushNotifications = true;
  bool _soundAlerts = true;
  bool _vibrationPatterns = true;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);

  // Location settings
  bool _gpsAccuracy = true;
  bool _backgroundTracking = false;
  String _streetDetectionSensitivity = 'Medium';

  // Collector-specific settings
  String _notificationRadius = '500m';
  bool _deliveryConfirmation = true;
  String _routePreference = 'Optimized';

  // Resident settings
  String _alertFrequency = 'All Collections';
  bool _householdReminders = true;

  // Accessibility settings
  bool _largeText = false;
  bool _highContrast = false;
  bool _voiceNotifications = false;

  // Privacy settings
  bool _dataSharing = true;
  bool _locationStorage = true;

  final List<Map<String, dynamic>> _municipalAreas = [
    {
      "id": 1,
      "name": "Downtown District",
      "code": "DD-001",
      "verified": true,
    },
    {
      "id": 2,
      "name": "Residential Zone A",
      "code": "RZ-A02",
      "verified": true,
    },
    {
      "id": 3,
      "name": "Industrial Park",
      "code": "IP-003",
      "verified": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings & Preferences',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role Selection Header
            RoleSelectorWidget(
              currentRole: _currentRole,
              onRoleChanged: (role) {
                setState(() {
                  _currentRole = role;
                });
              },
            ),

            SizedBox(height: 3.h),

            // Notification Preferences
            SettingsSectionWidget(
              title: 'Notification Preferences 🛎',
              children: [
                SettingsToggleWidget(
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts when collectors arrive',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                  iconName: 'notifications',
                ),
                SettingsToggleWidget(
                  title: 'Sound Alerts',
                  subtitle: 'Play notification sounds',
                  value: _soundAlerts,
                  onChanged: (value) {
                    setState(() {
                      _soundAlerts = value;
                    });
                  },
                  iconName: 'volume_up',
                ),
                SettingsToggleWidget(
                  title: 'Vibration Patterns',
                  subtitle: 'Vibrate device for notifications',
                  value: _vibrationPatterns,
                  onChanged: (value) {
                    setState(() {
                      _vibrationPatterns = value;
                    });
                  },
                  iconName: 'vibration',
                ),
                QuietHoursWidget(
                  isEnabled: _quietHoursEnabled,
                  startTime: _quietHoursStart,
                  endTime: _quietHoursEnd,
                  onEnabledChanged: (value) {
                    setState(() {
                      _quietHoursEnabled = value;
                    });
                  },
                  onStartTimeChanged: (time) {
                    setState(() {
                      _quietHoursStart = time;
                    });
                  },
                  onEndTimeChanged: (time) {
                    setState(() {
                      _quietHoursEnd = time;
                    });
                  },
                ),
              ],
            ),

            // Location Settings
            SettingsSectionWidget(
              title: 'Location Settings 📍',
              children: [
                SettingsToggleWidget(
                  title: 'High GPS Accuracy',
                  subtitle: 'Use precise location for better street detection',
                  value: _gpsAccuracy,
                  onChanged: (value) {
                    setState(() {
                      _gpsAccuracy = value;
                    });
                  },
                  iconName: 'gps_fixed',
                ),
                SettingsToggleWidget(
                  title: 'Background Tracking',
                  subtitle: 'Allow location access when app is closed',
                  value: _backgroundTracking,
                  onChanged: (value) {
                    setState(() {
                      _backgroundTracking = value;
                    });
                  },
                  iconName: 'location_on',
                ),
                SettingsListTileWidget(
                  title: 'Street Detection Sensitivity',
                  subtitle: 'Current: $_streetDetectionSensitivity',
                  iconName: 'tune',
                  onTap: () => _showSensitivityDialog(),
                ),
              ],
            ),

            // Account Settings
            SettingsSectionWidget(
              title: 'Account Settings 👤',
              children: [
                SettingsListTileWidget(
                  title: 'Profile Information',
                  subtitle: 'Edit your personal details',
                  iconName: 'person',
                  onTap: () => _showProfileDialog(),
                ),
                SettingsListTileWidget(
                  title: 'Municipal Area',
                  subtitle: 'Select your service area',
                  iconName: 'location_city',
                  onTap: () => _showMunicipalAreaDialog(),
                ),
              ],
            ),

            // Role-specific settings
            _currentRole == 'Collector'
                ? _buildCollectorSettings()
                : _buildResidentSettings(),

            // Accessibility Settings
            SettingsSectionWidget(
              title: 'Accessibility ♿',
              children: [
                SettingsToggleWidget(
                  title: 'Large Text',
                  subtitle: 'Increase text size for better readability',
                  value: _largeText,
                  onChanged: (value) {
                    setState(() {
                      _largeText = value;
                    });
                  },
                  iconName: 'text_fields',
                ),
                SettingsToggleWidget(
                  title: 'High Contrast Mode',
                  subtitle: 'Improve visibility with enhanced contrast',
                  value: _highContrast,
                  onChanged: (value) {
                    setState(() {
                      _highContrast = value;
                    });
                  },
                  iconName: 'contrast',
                ),
                SettingsToggleWidget(
                  title: 'Voice Notifications',
                  subtitle: 'Read notifications aloud',
                  value: _voiceNotifications,
                  onChanged: (value) {
                    setState(() {
                      _voiceNotifications = value;
                    });
                  },
                  iconName: 'record_voice_over',
                ),
              ],
            ),

            // Privacy Settings
            SettingsSectionWidget(
              title: 'Privacy & Data 🔒',
              children: [
                SettingsToggleWidget(
                  title: 'Municipal Data Sharing',
                  subtitle: 'Share usage data with municipal authorities',
                  value: _dataSharing,
                  onChanged: (value) {
                    setState(() {
                      _dataSharing = value;
                    });
                  },
                  iconName: 'share',
                ),
                SettingsToggleWidget(
                  title: 'Location Storage',
                  subtitle: 'Store location history for service improvement',
                  value: _locationStorage,
                  onChanged: (value) {
                    setState(() {
                      _locationStorage = value;
                    });
                  },
                  iconName: 'storage',
                ),
                SettingsListTileWidget(
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  iconName: 'privacy_tip',
                  onTap: () => _showPrivacyPolicy(),
                ),
                SettingsListTileWidget(
                  title: 'Terms of Service',
                  subtitle: 'View terms and conditions',
                  iconName: 'description',
                  onTap: () => _showTermsOfService(),
                ),
              ],
            ),

            // Help & Support
            SettingsSectionWidget(
              title: 'Help & Support 💬',
              children: [
                SettingsListTileWidget(
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  iconName: 'help',
                  onTap: () => _showFAQ(),
                ),
                SettingsListTileWidget(
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  iconName: 'support_agent',
                  onTap: () => _contactSupport(),
                ),
                SettingsListTileWidget(
                  title: 'Tutorial Replay',
                  subtitle: 'Watch the app tutorial again',
                  iconName: 'play_circle',
                  onTap: () => _replayTutorial(),
                ),
              ],
            ),

            // App Information
            SettingsSectionWidget(
              title: 'App Information ℹ️',
              children: [
                SettingsListTileWidget(
                  title: 'Version',
                  subtitle: 'CleanAlert v1.2.3 (Build 456)',
                  iconName: 'info',
                  trailing: const SizedBox.shrink(),
                ),
                SettingsListTileWidget(
                  title: 'Check for Updates',
                  subtitle: 'Last checked: Today',
                  iconName: 'system_update',
                  onTap: () => _checkForUpdates(),
                ),
              ],
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectorSettings() {
    return SettingsSectionWidget(
      title: 'Collector Settings 🚛',
      children: [
        SettingsListTileWidget(
          title: 'Route Preferences',
          subtitle: 'Current: $_routePreference',
          iconName: 'route',
          onTap: () => _showRoutePreferencesDialog(),
        ),
        SettingsListTileWidget(
          title: 'Notification Broadcast Radius',
          subtitle: 'Current: $_notificationRadius',
          iconName: 'radio_button_checked',
          onTap: () => _showRadiusDialog(),
        ),
        SettingsToggleWidget(
          title: 'Delivery Confirmation',
          subtitle: 'Require confirmation after collection',
          value: _deliveryConfirmation,
          onChanged: (value) {
            setState(() {
              _deliveryConfirmation = value;
            });
          },
          iconName: 'check_circle',
        ),
      ],
    );
  }

  Widget _buildResidentSettings() {
    return SettingsSectionWidget(
      title: 'Resident Settings 🏠',
      children: [
        SettingsListTileWidget(
          title: 'Alert Frequency',
          subtitle: 'Current: $_alertFrequency',
          iconName: 'schedule',
          onTap: () => _showAlertFrequencyDialog(),
        ),
        SettingsToggleWidget(
          title: 'Household Reminders',
          subtitle: 'Remind to prepare waste for collection',
          value: _householdReminders,
          onChanged: (value) {
            setState(() {
              _householdReminders = value;
            });
          },
          iconName: 'home',
        ),
        SettingsListTileWidget(
          title: 'Collection Schedule',
          subtitle: 'Customize your pickup schedule',
          iconName: 'event',
          onTap: () => _showScheduleDialog(),
        ),
      ],
    );
  }

  void _showSensitivityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Street Detection Sensitivity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Low', 'Medium', 'High'].map((sensitivity) {
            return RadioListTile<String>(
              title: Text(sensitivity),
              value: sensitivity,
              groupValue: _streetDetectionSensitivity,
              onChanged: (value) {
                setState(() {
                  _streetDetectionSensitivity = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Information'),
        content: const Text(
            'Profile editing functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMunicipalAreaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Municipal Area'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _municipalAreas.length,
            itemBuilder: (context, index) {
              final area = _municipalAreas[index];
              return ListTile(
                title: Text(area["name"] as String),
                subtitle: Text(
                    'Code: ${area["code"]} ${(area["verified"] as bool) ? "✅" : "⏳"}'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${area["name"]}')),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRoutePreferencesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Route Preferences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Optimized', 'Shortest', 'Fastest'].map((preference) {
            return RadioListTile<String>(
              title: Text(preference),
              value: preference,
              groupValue: _routePreference,
              onChanged: (value) {
                setState(() {
                  _routePreference = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showRadiusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Broadcast Radius'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['250m', '500m', '1km', '2km'].map((radius) {
            return RadioListTile<String>(
              title: Text(radius),
              value: radius,
              groupValue: _notificationRadius,
              onChanged: (value) {
                setState(() {
                  _notificationRadius = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAlertFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['All Collections', 'My Street Only', 'Weekly Summary']
              .map((frequency) {
            return RadioListTile<String>(
              title: Text(frequency),
              value: frequency,
              groupValue: _alertFrequency,
              onChanged: (value) {
                setState(() {
                  _alertFrequency = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Collection Schedule'),
        content: const Text(
            'Schedule customization would be implemented here with calendar integration.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'CleanAlert Privacy Policy\n\n'
            'We collect location data to provide waste collection services. '
            'Your data is shared only with municipal authorities for service coordination. '
            'We do not sell personal information to third parties.\n\n'
            'Location data is stored securely and deleted after 30 days unless required for service records.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'CleanAlert Terms of Service\n\n'
            'By using this app, you agree to:\n'
            '• Provide accurate location information\n'
            '• Use the service responsibly\n'
            '• Follow municipal waste guidelines\n'
            '• Report any issues promptly\n\n'
            'Service availability depends on municipal participation.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFAQ() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('FAQ')),
          body:
              const Center(child: Text('FAQ content would be displayed here')),
        ),
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text(
          'Support Options:\n\n'
          '📧 Email: support@cleanalert.com\n'
          '📞 Phone: 1-800-CLEAN-01\n'
          '💬 Live Chat: Available 9 AM - 5 PM\n\n'
          'Response time: Within 24 hours',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _replayTutorial() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tutorial replay would start here')),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Checking for updates... You have the latest version!')),
    );
  }
}
