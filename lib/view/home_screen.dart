import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app_bloc_aws/cubit/todo_cubit.dart';
import 'package:todos_app_bloc_aws/models/Todo.dart';
import 'package:todos_app_bloc_aws/view/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('My Todos'),
      floatingActionButton: floatingActionButton(),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            return state.todos.isEmpty
                ? emptyTodo()
                : todosListView(state.todos);
          } else if (state is TodoError) {
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }

  Center emptyTodo() {
    return Center(
      child: Text('You don\'t have any todo'),
    );
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          context: context,
          builder: (context) => addTodoView(),
        );
      },
      child: Icon(Icons.add),
    );
  }

  Widget addTodoView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
          ),
          Text(
            'Todo tittle',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Enter todo title'),
          ),
          SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<TodoCubit>(context).addTodo(titleController.text);
              titleController.text = '';
              Navigator.of(context).pop();
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Add todo',
                  textAlign: TextAlign.center,
                )),
          ),
        ],
      ),
    );
  }

  AppBar appBar(String tittle) {
    return AppBar(
      title: Text(tittle),
    );
  }

  Widget todosListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          child: CheckboxListTile(
            title: Text(todo.title),
            value: todo.isComplete,
            onChanged: (newValue) {
              BlocProvider.of<TodoCubit>(context)
                  .updateTodoIsComplete(todo, newValue);
            },
          ),
        );
      },
    );
  }
}
