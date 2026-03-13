import 'package:flutter_application_1/data/models/todo_tanam_model.dart';

abstract class TodoTanamState {}

class TodoTanamInitial extends TodoTanamState {}

class TodoTanamLoading extends TodoTanamState {}

class TodoTanamLoaded extends TodoTanamState {
  final List<TodoTanamModel> todos;
  final List<TodoTanamModel> pendingTodos;
  final List<TodoTanamModel> completedTodos;

  TodoTanamLoaded(this.todos, this.pendingTodos, this.completedTodos);
}

class TodoTanamError extends TodoTanamState {
  final String message;
  TodoTanamError(this.message);
}
