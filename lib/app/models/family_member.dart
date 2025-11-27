import 'package:flutter/material.dart';

const Color _defaultMemberColor = Color(0xFF7C83FD);

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.color,
  });

  final String id;
  final String name;
  final String relation;
  final Color color;

  FamilyMember copyWith({String? name, String? relation, Color? color}) =>
      FamilyMember(
        id: id,
        name: name ?? this.name,
        relation: relation ?? this.relation,
        color: color ?? this.color,
      );

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: json['id'] as String,
    name: json['name'] as String,
    relation: json['relation'] as String,
    color: Color(json['color'] as int? ?? _defaultMemberColor.value),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relation': relation,
    'color': color.value,
  };

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    final first = parts.first.characters.first;
    final last = parts.last.characters.first;
    return (first + last).toUpperCase();
  }
}
