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
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        member.color.withOpacity(0.35),
        member.color.withOpacity(0.1),
        Colors.transparent,
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: member.color,
          child: Text(
            member.initials,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(member.name),
        subtitle: Text(
          member.relation,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          color: AppColors.accentPrimary,
          onPressed: onEdit,
        ),
      ),
    );
  }
}
