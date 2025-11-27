import 'package:flutter/material.dart';

import '../models/family_member.dart';
import '../models/task.dart';
import '../models/task_filter_option.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_tasks_state.dart';
import 'random_member_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    required this.tasks,
    required this.members,
    required this.onToggleTaskStatus,
    super.key,
  });

  final List<Task> tasks;
  final List<FamilyMember> members;
  final void Function(String taskId, bool isDone) onToggleTaskStatus;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const String _unassignedFilter = '__unassigned__';
  String? _selectedFilterId;

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isFilterValid =
        _selectedFilterId == null ||
        _selectedFilterId == _unassignedFilter ||
        widget.members.any((member) => member.id == _selectedFilterId);
    if (!isFilterValid) {
      setState(() => _selectedFilterId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = [
      const TaskFilterOption(id: null, label: 'All', color: Colors.white),
      const TaskFilterOption(
        id: _unassignedFilter,
        label: 'Unassigned',
        color: Colors.white,
      ),
      ...widget.members.map(
        (member) => TaskFilterOption(
          id: member.id,
          label: member.name,
          color: member.color,
        ),
      ),
    ];

    final filteredTasks = _filteredTasks();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WheelButton(onPressed: () => _openWheel(context)),
          const SizedBox(height: 16),
          Text(
            'Task filter',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters
                  .map(
                    (filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter.label),
                        selected: _selectedFilterId == filter.id,
                        labelStyle: TextStyle(
                          color: _selectedFilterId == filter.id
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: filter.color.withOpacity(0.4),
                        selectedColor: filter.color,
                        onSelected: (isSelected) => setState(
                          () =>
                              _selectedFilterId = isSelected ? filter.id : null,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          if (filteredTasks.isEmpty)
            EmptyTasksState(
              message: _selectedFilterId == null
                  ? 'No tasks yet'
                  : 'No tasks for the selected assignee',
            )
          else
            ListView.separated(
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final assignee = _resolveAssignee(task.assigneeId);
                Gradient gradient;
                if (assignee != null) {
                  gradient = LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      assignee.color.withOpacity(0.35),
                      assignee.color.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  );
                } else {
                  gradient = LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(1),
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  );
                }
                return DecoratedBox(
                  key: ValueKey(task.id),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.6)),
                    boxShadow: AppColors.softGlow,
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isDone
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      assignee == null
                          ? 'Unassigned'
                          : '${assignee.name} · ${assignee.relation}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    value: task.isDone,
                    onChanged: (value) =>
                        widget.onToggleTaskStatus(task.id, value ?? false),
                    activeColor: AppColors.accentPrimary,
                    checkboxShape: const CircleBorder(),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: filteredTasks.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
        ],
      ),
    );
  }

  List<Task> _filteredTasks() {
    if (_selectedFilterId == null) return widget.tasks;
    if (_selectedFilterId == _unassignedFilter) {
      return widget.tasks.where((task) => task.assigneeId == null).toList();
    }
    return widget.tasks
        .where((task) => task.assigneeId == _selectedFilterId)
        .toList();
  }

  FamilyMember? _resolveAssignee(String? id) {
    if (id == null) return null;
    final index = widget.members.indexWhere((member) => member.id == id);
    if (index == -1) return null;
    return widget.members[index];
  }

  void _openWheel(BuildContext context) {
    if (widget.members.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add more family members to spin the wheel'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RandomMemberScreen(members: widget.members),
      ),
    );
  }
}

class _WheelButton extends StatelessWidget {
  const _WheelButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.vibrantGradient,
          borderRadius: BorderRadius.circular(26),
          boxShadow: AppColors.softGlow,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(26),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.casino, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Random assignee',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
