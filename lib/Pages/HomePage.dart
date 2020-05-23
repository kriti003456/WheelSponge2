import 'package:flutter/material.dart';
import 'package:wheelsponge/StaticWidgets/Drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _fetchData(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
    );
  }
}
