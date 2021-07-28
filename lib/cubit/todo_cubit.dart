import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos_app_bloc_aws/models/Todo.dart';
import 'package:todos_app_bloc_aws/repository/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final _todoRepo = TodoRepository();
  TodoCubit() : super(TodoLoading());

  void getTodos() async {
    if (state is! TodoLoaded) {
      emit(TodoLoading());
    }

    try {
      final todos = await _todoRepo.getTodos();
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(exception: e));
    }
  }

  void addTodo(String title) async {
    await _todoRepo.addTodo(title);
    getTodos();
  }

  void updateTodoIsComplete(Todo todo, bool isComplete) async {
    await _todoRepo.updateTodoIsComplete(todo, isComplete);
    getTodos();
  }
}
