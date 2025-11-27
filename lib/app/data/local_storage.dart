import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/family_member.dart';
import '../models/task.dart';

class LocalStorage {
  LocalStorage._();

  static final LocalStorage _instance = LocalStorage._();

  factory LocalStorage() => _instance;

  static const _familyKey = 'family_members';
  static const _tasksKey = 'tasks';

  SharedPreferences? _prefs;

  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<FamilyMember>> loadFamilyMembers() async {
    await _ensurePrefs();
    final jsonString = _prefs!.getString(_familyKey);
    if (jsonString == null) return [];

    final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
    return data
        .map(
          (item) =>
              FamilyMember.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<List<Task>> loadTasks() async {
    await _ensurePrefs();
    final jsonString = _prefs!.getString(_tasksKey);
    if (jsonString == null) return [];

    final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
    return data
        .map((item) => Task.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> saveFamilyMembers(List<FamilyMember> members) async {
    await _ensurePrefs();
    final encoded = jsonEncode(
      members.map((member) => member.toJson()).toList(growable: false),
    );
    await _prefs!.setString(_familyKey, encoded);
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _ensurePrefs();
    final encoded = jsonEncode(
      tasks.map((task) => task.toJson()).toList(growable: false),
    );
    await _prefs!.setString(_tasksKey, encoded);
  }
}
