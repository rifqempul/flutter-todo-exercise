import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoids/blocs/_blocs.dart';

import 'package:todoids/main.dart';
import 'package:todoids/models/todo_item.dart';
import 'package:todoids/screens/about/about_screen.dart';
import 'package:todoids/screens/settings/settings_screen.dart';
import 'package:todoids/widgets/dashboard_widget.dart';

class HomeScreen extends StatefulWidget {
  static String name = 'HomeScreen';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: name),
      builder: (_) {
        return HomeScreen();
      },
    );
  }

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<FormState> _todoForm = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? todoText;

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    _todoForm.currentState?.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  final Map<String, Color> _colorThemesOptions = {
    'Indigo': Colors.indigo,
    'pink': Colors.pink,
    'green': Colors.green,
    'blue': Colors.blue,
  };

  Future _createTodo() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).dialogBackgroundColor,
            border:
                Border.all(style: BorderStyle.solid, color: Colors.transparent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text('Tulis Todo Anda'),
              ),
              Form(
                key: _todoForm,
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                  _todoForm.currentState?.save();
                },
                child: Column(
                  children: [
                    TextFormField(
                      key: Key('text1'),
                      onChanged: (val) {
                        _todoForm.currentState?.validate();

                        _todoForm.currentState?.save();
                        todoText = val;
                      },
                      decoration: const InputDecoration(hintText: 'Enter Text'),
                      showCursor: true,
                    ),
                    TextButton(
                      onPressed: () {
                        _todoForm.currentState?.validate();

                        todoBox.add({
                          'content': todoText,
                          'isCompleted': false,
                        });

                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [Icon(Icons.add), Text('Tambah')],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _useWheelOption(String text, Color color) {
    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().swithColor(color: color);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 5,
        ),
        child: Text('$text'),
      ),
    );
  }

  Widget _useDrawer() {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(SettingsScreen.route());
            },
          ),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              Icon icon = Icon(Icons.nightlight_round);
              Text text = Text('Dark Mode');

              if (Theme.of(context).brightness == Brightness.dark) {
                icon = Icon(Icons.ac_unit);
                text = Text('Bright Mode');
              }

              return ListTile(
                leading: icon,
                title: text,
                onTap: () {
                  context.read<ThemeCubit>().toggleDarkTheme();
                  // Theme.of(context).
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('About'),
            onTap: () {
              Navigator.of(context).push(AboutScreen.route());
              // Theme.of(context).
            },
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Customize'),
            onTap: () {
              Navigator.of(context)
                  .pushAndRemoveUntil(HomeScreen.route(), (route) => false);
              showModalBottomSheet(
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (_) {
                    return BottomSheet(
                        onClosing: () {},
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).dialogBackgroundColor,
                              boxShadow: kElevationToShadow[3],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close),
                                  ),
                                ),
                                Container(
                                  height: 110,
                                  child: ListWheelScrollView.useDelegate(
                                    itemExtent: 44,
                                    onSelectedItemChanged: (i) {
                                      print(_colorThemesOptions[i]);
                                      context.read<ThemeCubit>().swithColor(
                                            color: _colorThemesOptions.entries
                                                .toList()[i]
                                                .value,
                                          );
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      childCount: _colorThemesOptions.length,
                                      builder: (context, i) {
                                        return _useWheelOption(
                                          _colorThemesOptions.entries
                                              .toList()[i]
                                              .key,
                                          _colorThemesOptions[i] ??
                                              Colors.black,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  });
              // showDialog(
              //     context: context,
              //     barrierDismissible: false,

              //     builder: (_) {
              //       return Dialog(

              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             ListTile(
              //               leading: Icon(Icons.palette),

              //             ),
              //           ],
              //         ),
              //       );
              //     });
              // Theme.of(context).
            },
          ),
        ],
      ),
    );
  }

  Widget _useAppbar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
          ),
          color: Colors.white,
          onPressed: () async => await _createTodo(),
        )
      ],
      elevation: 0,
      excludeHeaderSemantics: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
        ),
        color: Colors.white,
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      floating: true,
      onStretchTrigger: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hello'),
          ),
        );
      },
      automaticallyImplyLeading: false,
      title: Text('Todo App'),
      centerTitle: true,
      iconTheme: Theme.of(context).accentIconTheme,
    );
  }

  Widget _useDashboard() {
    return SliverToBoxAdapter(
      child: DashboardWidget(),
    );
  }

  String dropdownValue = '_dropdownList';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _useDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              _useAppbar(),
              _useDashboard(),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   color: Theme.of(context).primaryColor,
                //   child: DropdownButton<String>(
                //     value: dropdownValue,
                //     onTap: () {
                //       print('tapped');
                //     },
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         dropdownValue = newValue!;
                //       });
                //     },
                //     dropdownColor: Theme.of(context).primaryColor,
                //     iconSize: 0,
                //     isExpanded: true,
                //     elevation: 0,
                //     style: TextStyle(color: Colors.white),
                //     underline: Container(
                //       height: 0,
                //       color: Colors.transparent,
                //     ),
                //     items: <String>['_dropdownList', '_dropdownList2']
                //         .map<DropdownMenuItem<String>>(
                //             (value) => DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Container(
                //                     child: Text(value),
                //                   ),
                //                 ))
                //         .toList(),
                //   ),
                // ),
                BlocBuilder<ListTodoBloc, AppState>(
                  builder: (context, state) {
                    if (state is Loaded<List<TodoItem>>) {
                      if (state.result.isEmpty) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(child: Text('No Todo')),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.result.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          TodoItem item = state.result[index];
                          return GestureDetector(
                            onLongPress: () {
                              todoBox.deleteAt(index);
                            },
                            onTap: () {
                              item = item.copyWith(completed: !item.completed);
                              todoBox.putAt(
                                item.id,
                                item.toMap(),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 10,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '    ${state.result[index].name}    ',
                                style: item.completed
                                    ? TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 18,
                                        color: Colors.grey,
                                      )
                                    : TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
