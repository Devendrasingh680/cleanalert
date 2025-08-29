import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_role_selection/user_role_selection.dart';
import '../presentation/settings_and_preferences/settings_and_preferences.dart';
import '../presentation/collection_route_map/collection_route_map.dart';
import '../presentation/resident_home_screen/resident_home_screen.dart';
import '../presentation/collector_dashboard/collector_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String userRoleSelection = '/user-role-selection';
  static const String settingsAndPreferences = '/settings-and-preferences';
  static const String collectionRouteMap = '/collection-route-map';
  static const String residentHome = '/resident-home-screen';
  static const String collectorDashboard = '/collector-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    userRoleSelection: (context) => const UserRoleSelection(),
    settingsAndPreferences: (context) => const SettingsAndPreferences(),
    collectionRouteMap: (context) => const CollectionRouteMap(),
    residentHome: (context) => const ResidentHomeScreen(),
    collectorDashboard: (context) => const CollectorDashboard(),
    // TODO: Add your other routes here
  };
}
