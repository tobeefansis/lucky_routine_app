import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_tasks_state.dart';
import '../widgets/task_tile.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({
    required this.tasks,
    required this.members,
    required this.onCreateTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
    super.key,
  });

  final List<Task> tasks;
  final List<FamilyMember> members;
  final void Function(String title, String? assigneeId) onCreateTask;
  final void Function(String id, String title, String? assigneeId) onUpdateTask;
  final void Function(String id) onDeleteTask;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: tasks.isEmpty
              ? const EmptyTasksState()
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => onDeleteTask(task.id),
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
                      child: TaskTile(
                        task: task,
                        assignee: _resolveAssignee(task.assigneeId),
                        onEdit: () => _showTaskDialog(context, task),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemCount: tasks.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
        ),
        Positioned(
          right: 20,
          bottom: 110,
          child: SafeArea(
            top: false,
            child: _AddButton(
              onPressed: () => _showTaskDialog(context, null),
              icon: Icons.add_task_rounded,
              label: 'Add task',
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showTaskDialog(BuildContext context, Task? existing) async {
    final titleController = TextEditingController(text: existing?.title);
    String? selectedAssignee = existing?.assigneeId;
    if (selectedAssignee != null &&
        !members.any((member) => member.id == selectedAssignee)) {
      selectedAssignee = null;
    }
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: AppColors.vibrantGradient,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: AppColors.neonGlow,
                              ),
                              child: Icon(
                                existing == null
                                    ? Icons.add_task_rounded
                                    : Icons.edit_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              existing == null ? 'New task' : 'Edit task',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: AppColors.accentPrimary.withOpacity(0.2),
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
                              ? 'Please enter a title'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String?>(
                          value: selectedAssignee,
                          decoration: InputDecoration(
                            labelText: 'Assignee',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: AppColors.accentPrimary.withOpacity(0.2),
                              ),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Unassigned'),
                            ),
                            ...members.map(
                              (member) => DropdownMenuItem<String?>(
                                value: member.id,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: member.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(member.name),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) => selectedAssignee = value,
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.vibrantGradient,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: AppColors.softGlow,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (formKey.currentState?.validate() ??
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
        );
      },
    );

    if (confirmed != true) return;

    final title = titleController.text.trim();

    if (existing == null) {
      onCreateTask(title, selectedAssignee);
    } else {
      onUpdateTask(existing.id, title, selectedAssignee);
    }
  }

  FamilyMember? _resolveAssignee(String? id) {
    if (id == null) return null;
    final index = members.indexWhere((member) => member.id == id);
    if (index == -1) return null;
    return members[index];
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
        gradient: AppColors.vibrantGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.neonGlow,
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
