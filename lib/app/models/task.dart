class Task {
  const Task({
    required this.id,
    required this.title,
    this.assigneeId,
    this.isDone = false,
  });

  final String id;
  final String title;
  final String? assigneeId;
  final bool isDone;

  Task copyWith({
    String? title,
    String? assigneeId,
    bool updateAssignee = false,
    bool? isDone,
  }) => Task(
    id: id,
    title: title ?? this.title,
    assigneeId: updateAssignee ? assigneeId : this.assigneeId,
    isDone: isDone ?? this.isDone,
  );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    assigneeId: json['assigneeId'] as String?,
    isDone: json['isDone'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'assigneeId': assigneeId,
    'isDone': isDone,
  };
}
