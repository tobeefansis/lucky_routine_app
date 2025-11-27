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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: AppColors.vibrantGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppColors.softGlow,
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                        ),
                        child: FamilyMemberTile(
                          member: member,
                          onEdit: () => _showMemberDialog(context, member),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: members.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 110,
          child: SafeArea(
            top: false,
            child: FilledButton.icon(
              onPressed: () => _showMemberDialog(context, null),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add family member'),
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
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                existing == null ? 'New family member' : 'Edit member',
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter a name'
                            : null,
                      ),
                      TextFormField(
                        controller: relationController,
                        decoration: const InputDecoration(
                          labelText: 'Relationship',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter a description'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Member color',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: availableColors
                            .map(
                              (color) => _ColorOption(
                                color: color,
                                isSelected: selectedColor == color,
                                onTap: () =>
                                    setDialogState(() => selectedColor = color),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
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
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
