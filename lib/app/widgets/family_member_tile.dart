import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../theme/app_colors.dart';

class FamilyMemberTile extends StatelessWidget {
  const FamilyMemberTile({
    required this.member,
    required this.onEdit,
    super.key,
  });

  final FamilyMember member;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
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
                member.color.withOpacity(0.45),
                member.color.withOpacity(0.15),
                Colors.white.withOpacity(0.35),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: member.color.withOpacity(0.3),
                blurRadius: 18,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            leading: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: member.color,
                boxShadow: [
                  BoxShadow(
                    color: member.color.withOpacity(0.5),
                    blurRadius: 14,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  member.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            title: Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: member.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: member.color.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Text(
                  member.relation,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Container(
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
          ),
        ),
      ),
    );
  }
}
