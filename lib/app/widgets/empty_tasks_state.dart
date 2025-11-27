import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmptyTasksState extends StatelessWidget {
  const EmptyTasksState({super.key, this.message = 'Create your first task'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.checklist_outlined,
            size: 48,
            color: AppColors.accentPrimary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
