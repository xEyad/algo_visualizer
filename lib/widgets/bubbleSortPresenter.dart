// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:algo_visualizer/models/bubbleSorter.dart';
import 'package:flutter/material.dart';

class BubbleSortPresenter extends StatefulWidget {
  const BubbleSortPresenter({Key? key}) : super(key: key);

  @override
  State<BubbleSortPresenter> createState() => _BubbleSortPresenterState();
}

class _BubbleSortPresenterState extends State<BubbleSortPresenter> with SingleTickerProviderStateMixin {
  final bubbleSorter =
      BubbleSorter([3, 38, 112, 74, 15, 36, 26, 27, 2, 86, 4, 19, 47, 50, 48]);
  List<int> get numbers => bubbleSorter.numbers;
  List<int> _currentSelection = [];
  List<StreamSubscription> subscriptions = [];
  late Animation<double> animation;
  late AnimationController controller; 


  @override
  void initState() {
    super.initState();
    initAnimationPreRequistes(); 
    initListeners();
  }

  void initAnimationPreRequistes() {
    controller = AnimationController(duration: Duration(milliseconds:bubbleSorter.animationStepSpeedInMs), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
    ..addListener(() {
      setState(() {
        // The state that has changed here is the animation object’s value.
      });
    }); 
  }

  void initListeners() {
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
    controller.dispose();
    super.dispose();
  }

  void onReset() {
    bubbleSorter.reset();
    setState(() {});
    print(numbers);
  }

  void onPause() {
    // controller.stop();
    bubbleSorter.pauseAnimation();
    setState(() {});
  }

  void onStartSort() {
    // controller.forward();
    bubbleSorter.startAnimation();
    setState(() {});
    print(numbers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[barsList(), actionBtns()],
    );
  }

  Widget barsList() {
    List<Widget> items = [];
    for (var i = 0; i < numbers.length; i++) {
      items.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: bar(numbers[i], _currentSelection.contains(i),
            i >= bubbleSorter.lastSortedIndex),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items,
    );
  }

  Widget bar(int value, bool isHighlighted, bool isSorted) {
    Color barColor = Colors.black;
    if (isHighlighted)
      barColor = Colors.blueAccent;
    else if (isSorted) barColor = Colors.green;

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

  Widget actionBtns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onReset,
          child: Text('Reset'),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: onStartSort,
          child: Text('Start Bubble sort'),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: onPause,
          child: Text('Pause'),
        ),
      ],
    );
  }

}
