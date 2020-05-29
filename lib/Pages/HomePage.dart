import 'package:flutter/material.dart';
import 'package:wheelsponge/Pages/PackagesPage.dart';
import 'package:wheelsponge/StaticWidgets/Drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _fetchData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: PackagesPage(),
    );
  }
}
