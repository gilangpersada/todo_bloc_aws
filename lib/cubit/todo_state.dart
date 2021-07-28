part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded({this.todos});
}

class TodoError extends TodoState {
  final Exception exception;

  TodoError({this.exception});
}
