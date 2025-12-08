import 'dart:ui';

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                glowBase.withOpacity(0.4),
                glowBase.withOpacity(0.15),
                Colors.white.withOpacity(0.3),
              ],
              stops: const [0.0, 0.35, 1.0],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: glowBase.withOpacity(0.25),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: _buildLeadingAvatar(glowBase),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color: task.isDone
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            subtitle: Row(
              children: [
                if (assignee != null) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: assignee!.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: assignee!.color.withOpacity(0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  assignee?.name ?? 'Unassigned',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (task.isDone) ...[
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.lightGreen.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.lightGreen,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accentPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 20),
                    color: AppColors.accentPrimary,
                    onPressed: onEdit,
                    splashRadius: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingAvatar(Color glowBase) {
    if (assignee == null) {
      return Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.vibrantGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.glowPurple.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.task_alt_rounded, color: Colors.white),
      );
    }

    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: assignee!.color,
        boxShadow: [
          BoxShadow(
            color: assignee!.color.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          assignee!.initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
