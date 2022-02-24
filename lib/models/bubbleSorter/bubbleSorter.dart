// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

library bubble_sorter;
import 'dart:async';

import 'package:algo_visualizer/models/simpleAnimationStatus.dart';
import 'package:rxdart/rxdart.dart';

part 'bubbleSorterSteps.dart';

class BubbleSorter 
{
  BubbleSorter(this._numbers)
  :
  _originalNumbersList = List.from(_numbers),
  _lastSortedIndex = _numbers.length;
  
  final List<int> _originalNumbersList;
  List<int> _numbers;
  List<int> get numbers => _numbers;
  final _currentSelectionStream = StreamController<List<int>>();
  Stream<List<int>> get currentSelectionStream =>  _currentSelectionStream.stream;

  final _willSwapSelectionStream = StreamController<bool>();
  Stream<bool> get willSwapSelectionStream =>  _willSwapSelectionStream.stream;

  final _animationStatusSubject = BehaviorSubject<SimpleAnimationStatus>.seeded(SimpleAnimationStatus.stopped);
  set _animationStatus(SimpleAnimationStatus s) => _animationStatusSubject.add(s);
  SimpleAnimationStatus get animationStatus => _animationStatusSubject.value;
  Stream<SimpleAnimationStatus> get animationStatusStream => _animationStatusSubject.stream.asBroadcastStream();
  
  List<_Step> swapSteps = [];

  //animation Variables
  int get animationStepSpeedInMs => 500;
  Timer? _animationTimer;
  int _curStepIndex = 0;
  int _lastSortedIndex;
  int get lastSortedIndex => _lastSortedIndex;

  void startAnimation()
  {        
    if(swapSteps.isEmpty)
    {
      _lastSortedIndex = _numbers.length;
      sortWithoutAnimation();
      _numbers = List.from(_originalNumbersList);      
    }

    _animationStatus = SimpleAnimationStatus.animating;
    _animationTimer = Timer.periodic(
      Duration(milliseconds:animationStepSpeedInMs ),(timer){
        print('starting bubble sort animation step');
        if(_curStepIndex == swapSteps.length)
        {
          _animationTimer?.cancel();
          _animationStatus = SimpleAnimationStatus.stopped;
          _currentSelectionStream.add([]);          
          print('Animation completed');
          return;
        }

        final curStep = swapSteps[_curStepIndex];
        _runNextStep();

        if( curStep is _AnimationSwapStep )
          _runNextStep();

        if(curStep is _AnimationUpdateLastSortedIndexValueStep)
          _runNextStep();

      }
    );
  }

  void _runNextStep()
  {
    final step = swapSteps[_curStepIndex];
    step.execute();
    _curStepIndex++;
  }
  
  void pauseAnimation()
  {
    _animationStatus = SimpleAnimationStatus.stopped;
    _animationTimer?.cancel();
    print('Animation paused');
  }

  void stopAnimation()
  {
    _animationStatus = SimpleAnimationStatus.stopped;
    _animationTimer?.cancel();
    reset();
    print('Animation stopped');
  }

  void reset()
  {
    _lastSortedIndex = _numbers.length;
    _currentSelectionStream.add([]);
    _numbers = List.from(_originalNumbersList);
    swapSteps.clear();
  }

  void runRecordedSteps()
  {
    for (var step in swapSteps) {step.execute(); }
  }

  void undoAllSteps()
  {
    if(swapSteps.isEmpty)
      return;
    for (var i = swapSteps.length-1; i >= 0 ; i--) {
      final curStep = swapSteps[i];
      if(curStep is _SwapStep)
        curStep.reverse();
    }
  }

  void sortWithoutAnimation()
  {
          
    bool didASwap = false;
    do {
      swapSteps.add(_AnimationUpdateLastSortedIndexValueStep(this,_lastSortedIndex));
      didASwap = false;
      for (var i = 0; i < _lastSortedIndex-1; i++) 
      {
        final curNum = numbers[i];
        final nextNum = numbers[i+1];
        swapSteps.add(_AnimationHighlightSelectionStep(this,i));
        if(curNum>nextNum) 
        {
          swapSteps.add(_AnimationSwapStep(this));
          swapSteps.add(_SwapStep(this,i));
          _swap(numbers,i,i+1);
          didASwap = true;
        }
      }
      _lastSortedIndex--;
    } while (didASwap);
  }

  void _swap(List<int> arr,int i1,int i2)
  {
    var t1 = arr[i1];
    var t2 = arr[i2];
    arr[i1] = t2;
    arr[i2] = t1;
  }

}
