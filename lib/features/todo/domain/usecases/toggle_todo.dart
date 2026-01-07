import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class ToggleTodo {
  final TodoRepository repository;
  ToggleTodo(this.repository);

  Future<void> call(Todo todo) async {
    await repository.updateTodo(todo.copyWith(done: !todo.done));
  }
}
