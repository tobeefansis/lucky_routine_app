import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.dashboard_outlined), text: 'Dashboard'),
                  Tab(icon: Icon(Icons.check_circle_outline), text: 'Tasks'),
                  Tab(
                    icon: Icon(Icons.family_restroom_outlined),
                    text: 'Family',
                  ),
                  Tab(icon: Icon(Icons.settings_outlined), text: 'Settings'),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(24),
                indicator: BoxDecoration(
                  gradient: AppColors.vibrantGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softGlow,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                dividerColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
