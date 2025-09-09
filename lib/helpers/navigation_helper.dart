import 'package:flutter/material.dart';
import '../screens/home_pet/vp_home.dart';

class NavigationHelper {
  static void navigateToScreen(
    BuildContext context,
    int index,
    int currentIndex,
  ) {
    if (index == currentIndex) return;

    Widget screen;
    switch (index) {
      case 0:
        screen = const VPHomeScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: Duration.zero,
      ),
    );
  }
}
