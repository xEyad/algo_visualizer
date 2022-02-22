// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:algo_visualizer/widgets/bubbleSortPresenter.dart';
import 'package:flutter/material.dart';
// ignore_for_file: avoid_print

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Algorithim visualizer"),
      ),
      body: Center(
        child: BubbleSortPresenter(),
      ),
    );
  }

}