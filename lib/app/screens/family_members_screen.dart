import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_family_state.dart';
import '../widgets/family_member_tile.dart';

const List<Color> _colorOptions = [
  Color(0xFFFC5C65),
  Color(0xFFF7B731),
  Color(0xFF2BCBBA),
  Color(0xFF45AAF2),
  Color(0xFFA55EEA),
  Color(0xFF26DE81),
  Color(0xFFFD9644),
  Color(0xFF778CA3),
];

class FamilyMembersScreen extends StatelessWidget {
  const FamilyMembersScreen({
    required this.members,
    required this.onCreateMember,
    required this.onUpdateMember,
    required this.onDeleteMember,
    super.key,
  });

  final List<FamilyMember> members;
  final void Function(String name, String relation, Color color) onCreateMember;
  final void Function(String id, String name, String relation, Color color)
  onUpdateMember;
  final void Function(String id) onDeleteMember;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: members.isEmpty
                ? const EmptyFamilyState()
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Dismissible(
                        key: ValueKey(member.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => onDeleteMember(member.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            gradient: AppColors.pinkPurpleGradient,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: AppColors.pinkGlow,
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        child: FamilyMemberTile(
                          member: member,
                          onEdit: () => _showMemberDialog(context, member),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemCount: members.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 110,
          child: SafeArea(
            top: false,
            child: _AddButton(
              onPressed: () => _showMemberDialog(context, null),
              icon: Icons.person_add_alt_1_rounded,
              label: 'Add member',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showMemberDialog(
    BuildContext context,
    FamilyMember? existing,
  ) async {
    final nameController = TextEditingController(text: existing?.name);
    final relationController = TextEditingController(text: existing?.relation);
    final formKey = GlobalKey<FormState>();
    final availableColors = List<Color>.of(_colorOptions);
    if (existing != null && !availableColors.contains(existing.color)) {
      availableColors.insert(0, existing.color);
    }
    Color selectedColor = existing?.color ?? availableColors.first;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.85),
                            Colors.white.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 1.5,
                        ),
                        boxShadow: AppColors.softGlow,
                      ),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.pinkPurpleGradient,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: AppColors.pinkGlow,
                                    ),
                                    child: Icon(
                                      existing == null
                                          ? Icons.person_add_alt_1_rounded
                                          : Icons.edit_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    existing == null
                                        ? 'New family member'
                                        : 'Edit member',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: AppColors.accentPrimary
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.accentPrimary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Please enter a name'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: relationController,
                                decoration: InputDecoration(
                                  labelText: 'Relationship',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: AppColors.accentPrimary
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.accentPrimary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Please enter a description'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Member color',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: availableColors
                                    .map(
                                      (color) => _ColorOption(
                                        color: color,
                                        isSelected: selectedColor == color,
                                        onTap: () => setDialogState(
                                          () => selectedColor = color,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 28),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.textSecondary,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: AppColors.pinkPurpleGradient,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: AppColors.pinkGlow,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            Navigator.of(context).pop(true);
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(14),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    final name = nameController.text.trim();
    final relation = relationController.text.trim();

    if (existing == null) {
      onCreateMember(name, relation, selectedColor);
    } else {
      onUpdateMember(existing.id, name, relation, selectedColor);
    }
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isSelected ? 0.6 : 0.35),
              blurRadius: isSelected ? 14 : 8,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
            : null,
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.pinkPurpleGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.pinkGlow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
