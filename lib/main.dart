import 'package:flutter/material.dart';

import 'counter_page.dart';
import 'custom_drawer.dart';
import 'custom_drawer_3d.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complex UI with Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: buildCustomDrawer3D(),
    );
  }

  CustomDrawer buildCustomDrawer() {
    return CustomDrawer(
      parent: Container(color: Colors.blue.shade300),
      child: CounterPage(
        menuButton: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => CustomDrawer.of(context).toggle(),
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
    );
  }

  CustomDrawer3D buildCustomDrawer3D() {
    return CustomDrawer3D(
      parent: Container(
        color: Colors.blue.shade300,
        child: SizedBox(width: 300, child: Placeholder()),
      ),
      child: CounterPage(
        menuButton: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => CustomDrawer3D.of(context).toggle(),
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
    );
  }
}
