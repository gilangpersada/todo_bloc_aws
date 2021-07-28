import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app_bloc_aws/amplifyconfiguration.dart';
import 'package:todos_app_bloc_aws/cubit/todo_cubit.dart';
import 'package:todos_app_bloc_aws/models/ModelProvider.dart';
import 'package:todos_app_bloc_aws/view/home_screen.dart';
import 'package:todos_app_bloc_aws/view/loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;
  void _configureAmplify() async {
    Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));

    try {
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TodoCubit()..getTodos(),
        child: _amplifyConfigured ? HomeScreen() : LoadingScreen(),
      ),
    );
  }
}
