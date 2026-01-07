import '../../domain/entities/todo.dart';

class TodoModel {
  String id;
  String title;
  bool done;

  TodoModel({required this.id, required this.title, required this.done});

  factory TodoModel.fromEntity(Todo t) =>
      TodoModel(id: t.id, title: t.title, done: t.done);
  Todo toEntity() => Todo(id: id, title: title, done: done);
}
