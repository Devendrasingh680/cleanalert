import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _loadingOpacityAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing CleanAlert...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading opacity animation
    _loadingOpacityAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Initialize location services
      await _updateStatus('Checking location permissions...');
      await _simulateLocationPermissionCheck();

      // Step 2: Initialize push notifications
      await _updateStatus('Setting up notifications...');
      await _simulateNotificationSetup();

      // Step 3: Load municipal configuration
      await _updateStatus('Loading municipal area...');
      await _simulateMunicipalConfig();

      // Step 4: Check authentication status
      await _updateStatus('Verifying user status...');
      await _simulateAuthCheck();

      // Step 5: Complete initialization
      await _updateStatus('Almost ready...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate based on user status
      _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError();
    }
  }

  Future<void> _updateStatus(String status) async {
    if (mounted) {
      setState(() {
        _initializationStatus = status;
      });
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  Future<void> _simulateLocationPermissionCheck() async {
    // Simulate location permission request
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _simulateNotificationSetup() async {
    // Simulate notification service initialization
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _simulateMunicipalConfig() async {
    // Simulate loading municipal area configuration
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _simulateAuthCheck() async {
    // Simulate authentication status check
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // For demo purposes, navigate to user role selection
      // In real app, this would check authentication and user role
      Navigator.pushReplacementNamed(context, '/user-role-selection');
    }
  }

  void _handleInitializationError() {
    if (mounted) {
      setState(() {
        _initializationStatus = 'Initialization failed. Retrying...';
      });

      // Retry after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _startInitialization();
        }
      });
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Animated Logo Section
              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: _buildLogoSection(),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),

              // Loading Section
              _buildLoadingSection(),

              // Spacer to balance layout
              const Spacer(flex: 3),

              // Footer
              _buildFooter(),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // App Icon with Truck Emoji
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '🚛',
              style: TextStyle(
                fontSize: 12.w,
              ),
            ),
          ),
        ),

        SizedBox(height: 4.h),

        // App Name
        Text(
          'CleanAlert',
          style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.surface,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Smart Waste Collection Coordination',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading Indicator
        AnimatedBuilder(
          animation: _loadingAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: _loadingOpacityAnimation.value,
              child: SizedBox(
                width: 8.w,
                height: 8.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.surface,
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 3.h),

        // Status Text
        Container(
          constraints: BoxConstraints(maxWidth: 80.w),
          child: Text(
            _initializationStatus,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Municipal Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.lightTheme.colorScheme.surface,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Municipal Certified',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Version Info
        Text(
          'Version 1.0.0',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
