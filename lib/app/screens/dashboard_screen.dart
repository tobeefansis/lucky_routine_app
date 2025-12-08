import 'dart:ui';

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
          const SizedBox(height: 20),
          Text(
            'Task filter',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters
                  .map(
                    (filter) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _FilterChip(
                        filter: filter,
                        isSelected: _selectedFilterId == filter.id,
                        onSelected: (isSelected) => setState(
                          () =>
                              _selectedFilterId = isSelected ? filter.id : null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
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
                return _TaskCard(
                  task: task,
                  assignee: assignee,
                  onToggle: (value) =>
                      widget.onToggleTaskStatus(task.id, value ?? false),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 14),
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
        SnackBar(
          content: const Text('Add more family members to spin the wheel'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.accentPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.isSelected,
    required this.onSelected,
  });

  final TaskFilterOption filter;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    filter.color == Colors.white
                        ? AppColors.accentPrimary
                        : filter.color,
                    filter.color == Colors.white
                        ? AppColors.accentSecondary
                        : filter.color.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : filter.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.4)
                : Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        (filter.color == Colors.white
                                ? AppColors.accentPrimary
                                : filter.color)
                            .withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          filter.label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.assignee,
    required this.onToggle,
  });

  final Task task;
  final FamilyMember? assignee;
  final ValueChanged<bool?> onToggle;

  @override
  Widget build(BuildContext context) {
    final baseColor = assignee?.color ?? AppColors.accentPrimary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor.withOpacity(0.35),
                baseColor.withOpacity(0.1),
                Colors.white.withOpacity(0.3),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: baseColor.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color: task.isDone
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
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
                          color: assignee!.color.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  assignee == null
                      ? 'Unassigned'
                      : '${assignee!.name} · ${assignee!.relation}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            value: task.isDone,
            onChanged: onToggle,
            activeColor: AppColors.accentPrimary,
            checkColor: Colors.white,
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
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
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.holographicGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.glowPurple.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.glowCyan.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: -5,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(28),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.casino_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Random assignee',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
