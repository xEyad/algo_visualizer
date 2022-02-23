// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:async';

import 'package:algo_visualizer/models/simpleAnimationStatus.dart';


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
  final _willSwapSelectionStream = StreamController<bool>();
  Stream<List<int>> get currentSelectionStream =>  _currentSelectionStream.stream;
  Stream<bool> get willSwapSelectionStream =>  _willSwapSelectionStream.stream;
  SimpleAnimationStatus _animationStatus = SimpleAnimationStatus.stopped;
  SimpleAnimationStatus get animationStatus => _animationStatus;

  //animation Variables
  int get animationStepSpeedInMs => 500;
  late Timer _animationTimer;
  int _curStepIndex = 0;
  bool _isSwapHappenedInFullLoop = false;
  int _stepsPerformed = 0;
  int _lastSortedIndex;
  int get lastSortedIndex => _lastSortedIndex;

  void startAnimation()
  {        
    _animationStatus = SimpleAnimationStatus.animating;
    _animationTimer = Timer.periodic(
      Duration(milliseconds:animationStepSpeedInMs ),(timer){
        _animationStatus = SimpleAnimationStatus.animating;
        print('starting bubble sort animation step');
        final bool didCompleteFullLoop = _curStepIndex == _lastSortedIndex-1 ;
        if(didCompleteFullLoop)
          _lastSortedIndex--;

        if(!didCompleteFullLoop)
          _doAnimationStep();
        else if(_isSwapHappenedInFullLoop)
        {
          resetAnimationCounters();
        }
        else
        {
          _currentSelectionStream.add([]);
          resetAnimationCounters();
          _animationTimer.cancel();
          _animationStatus = SimpleAnimationStatus.stopped;
          print('Animation completed');
        }
      }
    );
  }

  void pauseAnimation()
  {
    _animationStatus = SimpleAnimationStatus.stopped;
    _animationTimer.cancel();
    print('Animation paused');
  }

  void stopAnimation()
  {
    _animationStatus = SimpleAnimationStatus.stopped;
    _animationTimer.cancel();
    reset();
    print('Animation stopped');
  }

  void reset()
  {
    _lastSortedIndex = _numbers.length;
    _currentSelectionStream.add([]);
    _numbers = List.from(_originalNumbersList);
    resetAnimationCounters();
  }

  void resetAnimationCounters()
  {
    _isSwapHappenedInFullLoop = false;
    _curStepIndex = 0;
  }

  void _doAnimationStep()
  {    
    final curNum = numbers[_curStepIndex];
    final nextNum = numbers[_curStepIndex+1];
    _currentSelectionStream.add([_curStepIndex,_curStepIndex+1]);
    if(curNum>nextNum) 
    {
      _willSwapSelectionStream.add(true);
      _swap(numbers,_curStepIndex,_curStepIndex+1);
      _isSwapHappenedInFullLoop = true;
    }
    _curStepIndex++;
    _stepsPerformed++;
  }

  void sortWithoutAnimation()
  {
    bool didASwap = false;
    do {
      didASwap = false;
      for (var i = 0; i < numbers.length-1; i++) {
        final curNum = numbers[i];
        final nextNum = numbers[i+1];
        if(curNum>nextNum) 
        {
          _swap(numbers,i,i+1);
          didASwap = true;
        }
      }
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

