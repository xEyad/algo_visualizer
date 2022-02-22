// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:algo_visualizer/models/bubbleSorter.dart';
import 'package:flutter/material.dart';
// ignore_for_file: avoid_print

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bubbleSorter = BubbleSorter([3, 38, 112, 74, 15, 36, 26, 27, 2, 86, 4, 19, 47, 50, 48]);
  List<int> get numbers => bubbleSorter.numbers;
  List<int> _currentSelection = [];
  List<StreamSubscription> subscriptions = [];

  @override
  void initState() {
    super.initState();
    final s1 = bubbleSorter.currentSelectionStream.listen((event) {
      setState(() {
        _currentSelection = event;
      });
      print('Current selection: $_currentSelection');
    });


    subscriptions.addAll([s1]);
  }

  @override
  void dispose() {

    for (var s in subscriptions) {
      s.cancel();
    }

    super.dispose();
  }

  void bubbleSort() {
    bubbleSorter.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[barsList(), actionBtns()],
        ),
      ),
    );
  }

  Widget actionBtns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            bubbleSorter.reset();
            setState(() {});
            print(numbers);
          },
          child: Text('Reset'),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () {
            bubbleSort();
            setState(() {});
            print(numbers);
          },
          child: Text('Start Bubble sort'),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () {
            bubbleSorter.pauseAnimation();
            setState(() {});
          },
          child: Text('Pause'),
        ),
      ],
    );
  }

  Widget barsList() {
    List<Widget> items = [];
    for (var i = 0; i < numbers.length; i++) {
      items.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: bar(numbers[i], _currentSelection.contains(i),i>=bubbleSorter.lastSortedIndex),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items,
    );
  }

  Widget bar(int value, bool isHighlighted,bool isSorted) {
    Color barColor = Colors.black;
    if(isHighlighted)
      barColor = Colors.blueAccent;
    else if(isSorted)
      barColor = Colors.green;

    if (value < 20) {
      return Column(
        children: [
          Text(
            '$value',
            style: TextStyle(color: Colors.black),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomCenter,
            height: value.toDouble(),
            color: barColor,
            width: 30,
          ),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 5),
        alignment: Alignment.bottomCenter,
        height: value.toDouble(),
        color: barColor,
        width: 30,
        child: Text(
          '$value',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
