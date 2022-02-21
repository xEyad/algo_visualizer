// ignore_for_file: prefer_const_constructors

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
  final bubbleSorter = BubbleSorter([3, 38, 5, 44, 15, 36, 26, 27, 2, 46, 4, 19, 47, 50, 48]);
  List<int> get numbers => bubbleSorter.numbers;
  List<int> _currentSelection = [];

  @override
  void initState() {
    super.initState();
    bubbleSorter.currentSelectionStream.listen((event) {
      setState(() {
        _currentSelection = event;
      });
      print('Current selection: $_currentSelection');
    });
  }
  void bubbleSort() {
    bubbleSorter.sortWithAnimation();
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
          child: Text('Bubble sort'),
        ),
      ],
    );
  }

  Widget barsList() {

    List<Widget> items = [];
    for (var i = 0; i < numbers.length; i++) {
      items.add(
        Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: bar(numbers[i],_currentSelection.contains(i)),
              )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items,
    );
  }

  Widget bar(int value, bool isHighlighted) {
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
            color: isHighlighted?Colors.blueAccent:Colors.black,
            width: 30,
          ),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 5),
        alignment: Alignment.bottomCenter,
        height: value.toDouble(),
        color: Colors.black,
        width: 30,
        child: Text(
          '$value',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
