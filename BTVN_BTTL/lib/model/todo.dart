class Todo {
  final int? id;
  final String title;
  final String content;
  bool isDone;

  Todo({
    this.id,
    required this.title,
    required this.content,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isDone: map['isDone'] == 1,
    );
  }
}