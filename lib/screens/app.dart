import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoids/blocs/_blocs.dart';
import 'package:todoids/blocs/app_event.dart';
import 'package:todoids/blocs/list_todo/list_todo_bloc.dart';
import 'package:todoids/blocs/theme/theme_bloc.dart';
import 'package:todoids/main.dart';
import 'package:todoids/repositories/todo_repository.dart';
import 'package:todoids/screens/home/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              // appBarTheme: AppBarTheme(color: CupertinoColors.systemIndigo),
              primaryColor: state.themeColor,
              accentColor: Colors.purpleAccent,
              accentIconTheme: IconThemeData(color: Colors.blue, size: 40),
              // typography: Typography.material2018(),
              iconTheme: IconThemeData(color: Colors.black, size: 30),
              accentTextTheme: TextTheme(
                headline1: TextStyle(
                  color: Colors.white10,
                ),
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: state.themeMode,
            onGenerateRoute: (_) => HomeScreen.route(),
            // home: HomeScreen(),
          );
        },
      ),
    );
  }
}

class AppProviders extends StatelessWidget {
  final child;

  const AppProviders({Key? key, this.child})
      : assert(child != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => ListTodoBloc()
            ..add(
              Initializing(
                data: todoBox,
              ),
            ),
        ),
        BlocProvider(create: (context) => TodoCategoryCubit()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => TodoRepository(),
          )
        ],
        child: child,
      ),
    );
  }
}
