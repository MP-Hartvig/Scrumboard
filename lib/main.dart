import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard/bloc/card_bloc.dart';
import 'package:scrumboard/event/scrum_event.dart';
import 'package:scrumboard/model/login.dart';
import 'package:scrumboard/screens/home_screen.dart';
import 'package:scrumboard/screens/local_storage_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CardBloc>(create: (context) => CardBloc()),
        ],
        child: const ScreenChanger(),
      ),
    );
  }
}

class ScreenChanger extends StatefulWidget {
  const ScreenChanger({Key? key}) : super(key: key);

  @override
  ScreenChangerState createState() => ScreenChangerState();
}

class ScreenChangerState extends State<ScreenChanger> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  void _toggleDrawer() async {
    if (scaffoldState.currentState != null) {
      if (scaffoldState.currentState!.isDrawerOpen) {
        scaffoldState.currentState!.openEndDrawer();
      } else {
        scaffoldState.currentState!.openDrawer();
      }
    }
  }

  void _menuChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CardBloc photoBloc = BlocProvider.of<CardBloc>(context);
    Login login = Login(username: 'FlutterTester', password: 'FutterTest');
    photoBloc.add(ScrumLoginEvent(login));

    List<Widget> views = <Widget>[
      const HomeScreen(),
      const LocalStorageScreen()
    ];

    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(title: const Text("Scrum board")),
      body: SafeArea(
        child: views[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Menu"),
            ),
            ListTile(
              title: const Text("Home screen"),
              selected: _selectedIndex == 0,
              onTap: () {
                _toggleDrawer();
                _menuChange(0);
              },
            ),
            ListTile(
              title: const Text("Local storage"),
              selected: _selectedIndex == 1,
              onTap: () {
                _toggleDrawer();
                _menuChange(1);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
