import 'package:flutter/material.dart';
import 'package:vibez/screens/main/main_screen.dart';
import 'package:vibez/screens/main/main_screen_web.dart';

class MainScreenLayout extends StatefulWidget {
  const MainScreenLayout({super.key});

  @override
  State<MainScreenLayout> createState() => _MainScreenLayoutState();
}

class _MainScreenLayoutState extends State<MainScreenLayout> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        if (availableWidth >= 1000) {
          return MainScreenWeb();
        }  else {
          return MainScreen();
        }
      },
    );
  }
}
