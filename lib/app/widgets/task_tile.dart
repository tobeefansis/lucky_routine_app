import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.assignee,
    required this.onEdit,
    super.key,
  });

  final Task task;
  final FamilyMember? assignee;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final glowBase = assignee?.color ?? AppColors.accentPrimary;
    final glowGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        glowBase.withOpacity(0.35),
        glowBase.withOpacity(0.12),
        Colors.transparent,
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: glowGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: assignee == null
            ? Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.vibrantGradient,
                  boxShadow: AppColors.softGlow,
                ),
                child: const Icon(Icons.task_alt, color: Colors.white),
              )
            : CircleAvatar(
                radius: 22,
                backgroundColor: assignee!.color,
                child: Text(
                  assignee!.initials,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone
                ? AppColors.textSecondary
                : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          assignee?.name ?? 'Unassigned',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.isDone) ...[
              const Icon(Icons.check_circle, color: Colors.lightGreen),
              const SizedBox(width: 4),
            ],
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.accentPrimary,
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
