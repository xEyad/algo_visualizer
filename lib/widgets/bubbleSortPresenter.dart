// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:algo_visualizer/models/bubbleSorter.dart';
import 'package:algo_visualizer/widgets/animatableBar.dart';
import 'package:flutter/material.dart';

class BubbleSortPresenter extends StatefulWidget {
  const BubbleSortPresenter({Key? key}) : super(key: key);

  @override
  State<BubbleSortPresenter> createState() => _BubbleSortPresenterState();
}

class _BubbleSortPresenterState extends State<BubbleSortPresenter> with SingleTickerProviderStateMixin {
  
  ///todo: disable start while its working

  final bubbleSorter =
      BubbleSorter([3, 38, 112, 74, 15, 36, 26, 27, 2, 86, 4, 19, 47, 50, 48]);
  List<int> get numbers => bubbleSorter.numbers;
  List<int> _currentSelection = [];
  List<StreamSubscription> subscriptions = [];
  late List<AnimatableBarController> animatableBarControllers;
  late Animation<double> animation;
  late AnimationController controller; 

  AnimatableBarController getControllerMatchingIndex(int index)
  {
    return animatableBarControllers.firstWhere((element) => element.value ==  numbers[index]);
  }

  @override
  void initState() {
    super.initState();
    initAnimationPreRequistes(); 
    initListeners();
    animatableBarControllers = numbers.map((e) => AnimatableBarController(e)).toList();
   
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
      animatableBarControllers.forEach((element) {
        element.isHighlighted = false;
        if(bubbleSorter.lastSortedIndex<numbers.length)
        {
          final lastSortedValue = numbers[bubbleSorter.lastSortedIndex];
          if(element.value >= lastSortedValue)
            element.isSorted = true;
        }        
      });
      
      _currentSelection = event;
      for (var selectedIdx in _currentSelection) {
        final ctrl = getControllerMatchingIndex(selectedIdx);
        ctrl.isHighlighted = true;
      }

      setState(() {});

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
    onPause();
    for (var element in animatableBarControllers) {element.reset();}
    bubbleSorter.reset();
    setState(() {});
    print(numbers);
  }

  void onPause() {
    controller.stop();
    bubbleSorter.pauseAnimation();
  }

  void onStartSort() {
    bubbleSorter.startAnimation();
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
        child: AnimatableBar( getControllerMatchingIndex(i),key: UniqueKey(),),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items,
    );
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
