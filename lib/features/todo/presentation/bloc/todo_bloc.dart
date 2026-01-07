import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  TodoBloc(this.repository) : super(TodoLoading()) {
    on<LoadTodos>((e, emit) async {
      emit(TodoLoading());
      try {
        final todos = await repository.getTodos();
        emit(TodoLoaded(todos));
      } catch (err) {
        emit(TodoError('Failed to load'));
      }
    });

    on<AddTodoEvent>((e, emit) async {
      if (state is TodoLoaded) {
        await repository.addTodo(e.todo);
        add(LoadTodos());
      }
    });

    on<ToggleTodoEvent>((e, emit) async {
      if (state is TodoLoaded) {
        await repository.updateTodo(e.todo.copyWith(done: !e.todo.done));
        add(LoadTodos());
      }
    });

    on<UpdateTodoEvent>((e, emit) async {
      if (state is TodoLoaded) {
        await repository.updateTodo(e.todo);
        add(LoadTodos());
      }
    });

    on<ClearCompletedEvent>((e, emit) async {
      if (state is TodoLoaded) {
        final todos = await repository.getTodos();
        for (final t in todos.where((t) => t.done)) {
          await repository.deleteTodo(t.id);
        }
        add(LoadTodos());
      }
    });

    on<DeleteTodoEvent>((e, emit) async {
      if (state is TodoLoaded) {
        await repository.deleteTodo(e.id);
        add(LoadTodos());
      }
    });
  }
}
