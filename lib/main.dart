import 'package:flutter/material.dart';
import 'package:myapp/components/navigationtab.dart';
import 'package:myapp/screens/search.dart';
import 'package:myapp/screens/movie.dart';
import 'package:myapp/screens/tv.dart';

void main() => runApp(MyApp(targetIndex: 0));

class DisableOverscroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Movie App';
  int targetIndex = 0;

  MyApp({this.targetIndex});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      initialRoute: '/',
      routes: {
        '/search': (context) => MyApp(
              targetIndex: 2,
            ),
      },
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: DisableOverscroll(),
          child: child,
        );
      },
      home: AppScaffold(
        targetIndex: targetIndex,
      ),
      theme: ThemeData(
        fontFamily: 'Metropolis',
        primaryColor: Colors.pink.shade600,
        highlightColor: Colors.grey.shade50,
      ),
    );
  }
}

class AppScaffold extends StatefulWidget {
  int targetIndex = 0;

  AppScaffold({this.targetIndex});

  @override
  createState() => _AppScaffoldState(navigationIndex: targetIndex);
}

class _AppScaffoldState extends State<AppScaffold> {
  int navigationIndex = 0;
  dynamic currentView;
  Map<String, Object> state = {};
  Map<int, Function> _screenFactories = {
    0: (Map<String, Object> state, Function updateState) =>
        Movie(state: state, updateState: updateState),
    1: (Map<String, Object> state, Function updateState) =>
        Tv(state: state, updateState: updateState),
    2: (Map<String, Object> state, Function updateState) =>
        Search(state: state, updateState: updateState),
  };

  _AppScaffoldState({this.navigationIndex = 0});

  void updateGlobalState(String key, Object value) {
    setState(() {
      state[key] = value;
    });
  }

  void onNavigationChange(int index) {
    setState(() {
      navigationIndex = index;
    });
  }

  getMainView() {
    this.currentView = this._screenFactories[this.navigationIndex](
        this.state, this.updateGlobalState);
    return this.currentView;
  }

  Future<Null> refresh() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: RefreshIndicator(
          child: Container(
            child: this.getMainView(),
          ),
          onRefresh: refresh,
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationTab(
        onNavigationChange: this.onNavigationChange,
        currentIndex: navigationIndex,
      ),
    );
  }
}
