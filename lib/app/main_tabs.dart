import 'package:flutter/material.dart';

import 'data/local_storage.dart';
import 'models/family_member.dart';
import 'models/task.dart';
import 'screens/dashboard_screen.dart';
import 'screens/family_members_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_colors.dart';
import 'widgets/bottom_tab_bar.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  static const List<FamilyMember> _seedFamilyMembers = [
    FamilyMember(
      id: 'member-1',
      name: 'Alina',
      relation: 'Spouse',
      color: Color(0xFFFC5C65),
    ),
    FamilyMember(
      id: 'member-2',
      name: 'Mark',
      relation: 'Son',
      color: Color(0xFFF7B731),
    ),
    FamilyMember(
      id: 'member-3',
      name: 'Katya',
      relation: 'Daughter',
      color: Color(0xFF45AAF2),
    ),
    FamilyMember(
      id: 'member-4',
      name: 'Mom',
      relation: 'Parent',
      color: Color(0xFF26DE81),
    ),
  ];

  static const List<Task> _seedTasks = [
    Task(id: 'task-1', title: 'Morning workout'),
    Task(id: 'task-2', title: 'Make breakfast', assigneeId: 'member-1'),
    Task(
      id: 'task-3',
      title: 'Get kids ready for school',
      assigneeId: 'member-3',
    ),
  ];

  final LocalStorage _storage = LocalStorage();

  List<FamilyMember> _familyMembers = const [];
  List<Task> _tasks = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final storedMembers = await _storage.loadFamilyMembers();
    final storedTasks = await _storage.loadTasks();

    if (!mounted) return;

    final usedSeedMembers = storedMembers.isEmpty;
    final usedSeedTasks = storedTasks.isEmpty;

    setState(() {
      _familyMembers = usedSeedMembers
          ? List.of(_seedFamilyMembers)
          : storedMembers;
      _tasks = usedSeedTasks ? List.of(_seedTasks) : storedTasks;
      _isLoading = false;
    });

    if (usedSeedMembers || usedSeedTasks) {
      _persistState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Lucky Routine'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appBarGradient,
              ),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        children: [
                          DashboardScreen(
                            tasks: _tasks,
                            members: _familyMembers,
                            onToggleTaskStatus: _toggleTaskStatus,
                          ),
                          TasksScreen(
                            tasks: _tasks,
                            members: _familyMembers,
                            onCreateTask: _createTask,
                            onUpdateTask: _updateTask,
                            onDeleteTask: _deleteTask,
                          ),
                          FamilyMembersScreen(
                            members: _familyMembers,
                            onCreateMember: _createMember,
                            onUpdateMember: _updateMember,
                            onDeleteMember: _deleteMember,
                          ),
                          const SettingsScreen(),
                        ],
                      ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomTabBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createMember(String name, String relation, Color color) {
    setState(() {
      _familyMembers.add(
        FamilyMember(
          id: _generateId('member'),
          name: name,
          relation: relation,
          color: color,
        ),
      );
    });

    _persistState();
  }

  void _updateMember(String id, String name, String relation, Color color) {
    final index = _familyMembers.indexWhere((member) => member.id == id);
    if (index == -1) return;
    setState(() {
      _familyMembers[index] = _familyMembers[index].copyWith(
        name: name,
        relation: relation,
        color: color,
      );
    });

    _persistState();
  }

  void _deleteMember(String id) {
    setState(() {
      _familyMembers.removeWhere((member) => member.id == id);
      for (var i = 0; i < _tasks.length; i++) {
        if (_tasks[i].assigneeId == id) {
          _tasks[i] = _tasks[i].copyWith(
            assigneeId: null,
            updateAssignee: true,
          );
        }
      }
    });

    _persistState();
  }

  void _createTask(String title, String? assigneeId) {
    setState(() {
      _tasks.add(
        Task(id: _generateId('task'), title: title, assigneeId: assigneeId),
      );
    });

    _persistState();
  }

  void _updateTask(String id, String title, String? assigneeId) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    setState(() {
      _tasks[index] = _tasks[index].copyWith(
        title: title,
        assigneeId: assigneeId,
        updateAssignee: true,
      );
    });

    _persistState();
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });

    _persistState();
  }

  void _toggleTaskStatus(String id, bool isDone) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isDone: isDone);
    });

    _persistState();
  }

  String _generateId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  void _persistState() {
    _storage.saveFamilyMembers(_familyMembers);
    _storage.saveTasks(_tasks);
  }
}
