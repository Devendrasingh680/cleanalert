import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/map_controls_widget.dart';
import './widgets/notification_history_marker.dart';
import './widgets/route_progress_widget.dart';
import './widgets/street_info_bottom_sheet.dart';

class CollectionRouteMap extends StatefulWidget {
  const CollectionRouteMap({Key? key}) : super(key: key);

  @override
  State<CollectionRouteMap> createState() => _CollectionRouteMapState();
}

class _CollectionRouteMapState extends State<CollectionRouteMap> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isStandardMap = true;
  bool _isNotifying = false;
  bool _isLoadingLocation = true;

  // Mock route data
  final List<Map<String, dynamic>> _routeData = [
    {
      "id": 1,
      "streetName": "Oak Street",
      "coordinates": {"lat": 37.7849, "lng": -122.4094},
      "residentCount": 24,
      "estimatedTime": "15 min",
      "completed": true,
      "notificationHistory": [
        {
          "timestamp": "08:45 AM",
          "status": "delivered",
          "deliveredCount": 22,
          "totalResidents": 24,
        }
      ]
    },
    {
      "id": 2,
      "streetName": "Pine Avenue",
      "coordinates": {"lat": 37.7849, "lng": -122.4074},
      "residentCount": 18,
      "estimatedTime": "12 min",
      "completed": false,
      "notificationHistory": []
    },
    {
      "id": 3,
      "streetName": "Maple Drive",
      "coordinates": {"lat": 37.7869, "lng": -122.4084},
      "residentCount": 31,
      "estimatedTime": "20 min",
      "completed": false,
      "notificationHistory": []
    },
    {
      "id": 4,
      "streetName": "Cedar Lane",
      "coordinates": {"lat": 37.7829, "lng": -122.4104},
      "residentCount": 15,
      "estimatedTime": "10 min",
      "completed": false,
      "notificationHistory": []
    },
  ];

  String _currentStreetName = "Pine Avenue";
  int _currentResidentCount = 18;
  String _currentEstimatedTime = "12 min";

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _setupMarkersAndPolylines();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      _updateCurrentLocationMarker();
    } catch (e) {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _setupMarkersAndPolylines() {
    Set<Marker> markers = {};
    List<LatLng> routePoints = [];

    // Add route markers
    for (var street in _routeData) {
      final coordinates = street["coordinates"] as Map<String, dynamic>;
      final LatLng position = LatLng(
        (coordinates["lat"] as double),
        (coordinates["lng"] as double),
      );

      routePoints.add(position);

      // Street marker
      markers.add(
        Marker(
          markerId: MarkerId('street_${street["id"]}'),
          position: position,
          icon: street["completed"] as bool
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: street["streetName"] as String,
            snippet:
                '${street["residentCount"]} residents • ${street["estimatedTime"]}',
          ),
          onTap: () => _onStreetMarkerTapped(street),
        ),
      );

      // Add notification history markers
      final notificationHistory = street["notificationHistory"] as List;
      for (int i = 0; i < notificationHistory.length; i++) {
        final notification = notificationHistory[i] as Map<String, dynamic>;
        markers.add(
          Marker(
            markerId: MarkerId('notification_${street["id"]}_$i'),
            position: LatLng(
              position.latitude + (i * 0.0001),
              position.longitude + (i * 0.0001),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              notification["status"] == "delivered"
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
            onTap: () => _showNotificationHistoryDialog(
                notification, street["streetName"] as String),
          ),
        );
      }
    }

    // Create route polyline
    if (routePoints.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('collection_route'),
          points: routePoints,
          color: AppTheme.lightTheme.primaryColor,
          width: 4,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _updateCurrentLocationMarker() {
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
        );
      });
    }
  }

  void _onStreetMarkerTapped(Map<String, dynamic> street) {
    setState(() {
      _currentStreetName = street["streetName"] as String;
      _currentResidentCount = street["residentCount"] as int;
      _currentEstimatedTime = street["estimatedTime"] as String;
    });
    _showStreetInfoBottomSheet();
  }

  void _showStreetInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StreetInfoBottomSheet(
        streetName: _currentStreetName,
        estimatedTime: _currentEstimatedTime,
        residentCount: _currentResidentCount,
        onNotifyStreet: _notifyCurrentStreet,
        isNotifying: _isNotifying,
      ),
    );
  }

  void _showNotificationHistoryDialog(
      Map<String, dynamic> notification, String streetName) {
    showDialog(
      context: context,
      builder: (context) => NotificationHistoryDialog(
        timestamp: notification["timestamp"] as String,
        status: notification["status"] as String,
        deliveredCount: notification["deliveredCount"] as int,
        totalResidents: notification["totalResidents"] as int,
        streetName: streetName,
      ),
    );
  }

  Future<void> _notifyCurrentStreet() async {
    setState(() => _isNotifying = true);

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate notification process
    await Future.delayed(const Duration(seconds: 2));

    // Update route data with notification
    final streetIndex = _routeData.indexWhere(
      (street) => street["streetName"] == _currentStreetName,
    );

    if (streetIndex != -1) {
      final currentTime = DateTime.now();
      final timeString =
          "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')} ${currentTime.hour >= 12 ? 'PM' : 'AM'}";

      (_routeData[streetIndex]["notificationHistory"] as List).add({
        "timestamp": timeString,
        "status": "delivered",
        "deliveredCount":
            _currentResidentCount - 2, // Mock some delivery failures
        "totalResidents": _currentResidentCount,
      });

      _routeData[streetIndex]["completed"] = true;
    }

    setState(() => _isNotifying = false);

    // Close bottom sheet
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🚛'),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Residents on $_currentStreetName have been notified!',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Update markers
    _setupMarkersAndPolylines();
  }

  void _centerOnCurrentLocation() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  void _toggleMapType() {
    setState(() {
      _isStandardMap = !_isStandardMap;
    });
  }

  int get _completedStreets =>
      _routeData.where((street) => street["completed"] as bool).length;
  double get _progressPercentage =>
      (_completedStreets / _routeData.length) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Collection Route Map',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
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
      ),
      body: _isLoadingLocation
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading your location...',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude)
                        : const LatLng(
                            37.7849, -122.4094), // Default to San Francisco
                    zoom: 14.0,
                  ),
                  mapType: _isStandardMap ? MapType.normal : MapType.satellite,
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  trafficEnabled: true,
                  onTap: (LatLng position) {
                    // Handle map tap - could be used for manual street selection
                  },
                ),

                // Route progress indicator
                RouteProgressWidget(
                  completedStreets: _completedStreets,
                  totalStreets: _routeData.length,
                  progressPercentage: _progressPercentage,
                ),

                // Map controls
                MapControlsWidget(
                  onLocationPressed: _centerOnCurrentLocation,
                  onMapTypeToggle: _toggleMapType,
                  isStandardMap: _isStandardMap,
                ),

                // Floating action button for quick street notification
                Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: FloatingActionButton.extended(
                    onPressed: _showStreetInfoBottomSheet,
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    icon: const Text('🚛', style: TextStyle(fontSize: 20)),
                    label: Text(
                      'Notify Street',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
