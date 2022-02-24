// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:algo_visualizer/models/bubbleSorter/bubbleSorter.dart';
import 'package:algo_visualizer/models/simpleAnimationStatus.dart';
import 'package:algo_visualizer/widgets/animatableBar.dart';
import 'package:flutter/material.dart';

class BubbleSortPresenter extends StatefulWidget {
  const BubbleSortPresenter({Key? key}) : super(key: key);

  @override
  State<BubbleSortPresenter> createState() => _BubbleSortPresenterState();
}

class _BubbleSortPresenterState extends State<BubbleSortPresenter> with SingleTickerProviderStateMixin {
  
  final barsSpacing = 4.0;
  final bubbleSorter = BubbleSorter([112,3, 38,  74, 15, 36, 26, 27, 2, 86, 4, 19, 47, 50, 48]);
  List<int> get numbers => bubbleSorter.numbers;
  List<int> _currentSelection = [];
  List<StreamSubscription> subscriptions = [];
  late List<AnimatableBarController> animatableBarControllers;
  late Animation<double> animation;
  late AnimationController animationController; 

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
    animationController = AnimationController(duration: Duration(milliseconds:(bubbleSorter.animationStepSpeedInMs*0.8).toInt()), vsync: this);
    animationController.addStatusListener((status) { 
      if(status== AnimationStatus.completed)
      {
        print('resetting bar animation controller');
        animationController.reset();
        setState(() {});
      }
    });
    animation = Tween<double>(begin: 0, end: AnimatableBar.width + barsSpacing*2).animate(animationController)
    ..addListener(() {
      if(_currentSelection.isEmpty) return;
      print('starting animation for ${_currentSelection[0]} and ${_currentSelection[1]}');
      final barCtrl1 = getControllerMatchingIndex(_currentSelection[1]);
      final barCtrl2 = getControllerMatchingIndex(_currentSelection[0]);
      barCtrl1.offset = Offset(animation.value, 0);
      barCtrl2.offset = Offset(-animation.value , 0);
    }); 
  }

  void initListeners() {
    final s1 = bubbleSorter.currentSelectionStream.listen((event) {
      for (var barCtrl in animatableBarControllers) 
      {
        //reset bars
        barCtrl.isHighlighted = false;
        barCtrl.offset = Offset.zero;
        if(bubbleSorter.lastSortedIndex<numbers.length)
        {
          final lastSortedValue = numbers[bubbleSorter.lastSortedIndex];
          if(barCtrl.value >= lastSortedValue)
            barCtrl.isSorted = true;
        }        
      }
      
      //highlight selection
      _currentSelection = event;
      for (var selectedIdx in _currentSelection) {
        final ctrl = getControllerMatchingIndex(selectedIdx);
        ctrl.isHighlighted = true;
      }
      print('Current selection: $_currentSelection');
    });

    final s2 = bubbleSorter.willSwapSelectionStream.listen((willSwap) { 
      if(willSwap)
      {
        print('starting bar animation controller');
        animationController.forward();
      }
      else
      {
        setState(() {});
      }
    });

    final s3 = bubbleSorter.animationStatusStream.listen((event) { 
      setState(() {});
    });
    
    subscriptions.addAll([s1,s2,s3]);
  }

  @override
  void dispose() {
    for (var s in subscriptions) {
      s.cancel();
    }
    animationController.dispose();
    super.dispose();
  }

  void onReset() {
    onPause();
    for (var element in animatableBarControllers) {element.reset();}
    bubbleSorter.reset();
    animationController.reset();
    setState(() {});
    print(numbers);
  }

  void onPause() {
    animationController.stop();
    bubbleSorter.pauseAnimation();
    setState(() {});
  }

  void onStartSort() {
    // bubbleSorter.sortWithoutAnimation();
    // setState(() {});
    // return;
    bubbleSorter.startAnimation();
    setState(() {});
    print(numbers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[barsList(),SizedBox(height: 30,), actionBtns()],
    );
  }
  
  Widget barsList() {
    List<Widget> items = [];
    for (var i = 0; i < numbers.length; i++) {
      items.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: barsSpacing),
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
          onPressed: bubbleSorter.animationStatus == SimpleAnimationStatus.animating? null : onReset,
          child: Text('Reset'),
        ),
        SizedBox(
          width: 20,
        ),
        // ElevatedButton(
        //   onPressed: (){
        //     bubbleSorter.reset();
        //     setState(() {});
        //   },
        //   child: Text('Super Reset'),
        // ),
        // SizedBox(
        //   width: 20,
        // ),
        ElevatedButton(
          onPressed: bubbleSorter.animationStatus == SimpleAnimationStatus.animating? null : onStartSort,
          child: Text('Start Bubble sort'),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: bubbleSorter.animationStatus == SimpleAnimationStatus.stopped? null :onPause,
          child: Text('Pause'),
        ),
      ],
    );
  }

  // Widget goToStep()
  // {
  //   return DropdownButton(items: items, onChanged: onChanged)
  // }
}
