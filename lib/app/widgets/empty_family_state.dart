import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmptyFamilyState extends StatelessWidget {
  const EmptyFamilyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.family_restroom_outlined,
            size: 48,
            color: AppColors.accentSecondary.withOpacity(0.6),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add your first family member',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
