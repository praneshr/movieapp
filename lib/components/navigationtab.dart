import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';

class NavigationTab extends StatefulWidget {
  Function onNavigationChange;
  int currentIndex;

  NavigationTab({this.onNavigationChange, this.currentIndex = 0});

  @override
  _NavigationTabState createState() => _NavigationTabState(currentIndex: currentIndex);
}

class _NavigationTabState extends State<NavigationTab> {
  int currentIndex;
  _NavigationTabState({this.currentIndex});

  TextStyle fontStyle =
      TextStyle(height: 1.8, fontWeight: FontWeight.w600, fontSize: 0);

  void onTap(int index) {
    widget.onNavigationChange(index);
    setState(() {
      this.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: this.currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      selectedFontSize: 14,
      unselectedItemColor: Colors.black,
      backgroundColor: Colors.grey.shade50,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedFontSize: 0,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(assets['images']['movie'], width: 18),
          activeIcon: Image.asset(assets['images']['movie'],
              width: 18, color: Theme.of(context).primaryColor),
          title: Text('Movie', style: this.fontStyle),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(assets['images']['tv'], width: 18),
          activeIcon: Image.asset(
            assets['images']['tv'],
            width: 18,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('TV', style: this.fontStyle),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(assets['images']['search'], width: 18),
          activeIcon: Image.asset(assets['images']['search'],
              width: 18, color: Theme.of(context).primaryColor),
          title: Text('Search', style: this.fontStyle),
        ),
      ],
    );
  }
}
