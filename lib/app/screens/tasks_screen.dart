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
          padding: const EdgeInsets.only(bottom: 120),
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
                      child: TaskTile(
                        task: task,
                        assignee: _resolveAssignee(task.assigneeId),
                        onEdit: () => _showTaskDialog(context, task),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: tasks.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
        ),
        Positioned(
          right: 24,
          bottom: 110,
          child: SafeArea(
            top: false,
            child: FilledButton.icon(
              onPressed: () => _showTaskDialog(context, null),
              icon: const Icon(Icons.add_task),
              label: const Text('Add task'),
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
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(existing == null ? 'New task' : 'Edit task'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a title'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: selectedAssignee,
                  decoration: const InputDecoration(labelText: 'Assignee'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Unassigned'),
                    ),
                    ...members.map(
                      (member) => DropdownMenuItem<String?>(
                        value: member.id,
                        child: Text(member.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => selectedAssignee = value,
                ),
              ],
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
