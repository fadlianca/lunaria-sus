import 'package:flutter/material.dart';
import 'route_names.dart';
import 'route_generator.dart';
import '../screens/home_pet/vp_home.dart';

/// Service untuk menangani semua navigasi dalam aplikasi
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Mendapatkan BuildContext dari navigator
  static BuildContext? get context => navigatorKey.currentContext;

  /// Navigate to route dengan nama
  static Future<dynamic> navigateToRoute(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate dan replace current route
  static Future<dynamic> navigateAndReplace(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate dan clear stack
  static Future<dynamic> navigateAndClearStack(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop/kembali ke halaman sebelumnya
  static void goBack({dynamic result}) {
    return navigatorKey.currentState!.pop(result);
  }

  /// Check apakah bisa pop
  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  /// Navigasi khusus untuk bottom navigation dengan animasi minimal
  static void navigateToBottomNavScreen(
    BuildContext context,
    int index,
    int currentIndex,
  ) {
    if (index == currentIndex) return;

    Widget targetScreen;
    switch (index) {
      case NavigationIndex.home:
        targetScreen = const VPHomeScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      RouteGenerator.createBottomNavRoute(targetScreen),
    );
  }

  /// Helper methods untuk navigasi ke screen tertentu
  static Future<dynamic> navigateToCalendar() =>
      navigateToRoute(RouteNames.calendar);
  static Future<dynamic> navigateToTrain() => navigateToRoute(RouteNames.train);
  static Future<dynamic> navigateToHome() => navigateToRoute(RouteNames.home);
  static Future<dynamic> navigateToCommunity() =>
      navigateToRoute(RouteNames.community);
  static Future<dynamic> navigateToProfile() =>
      navigateToRoute(RouteNames.profile);
  static Future<dynamic> navigateToLogin() => navigateToRoute(RouteNames.login);
  static Future<dynamic> navigateToSignup() =>
      navigateToRoute(RouteNames.signup);
  static Future<dynamic> navigateToBuyCookies() =>
      navigateToRoute(RouteNames.buyCookies);
}
