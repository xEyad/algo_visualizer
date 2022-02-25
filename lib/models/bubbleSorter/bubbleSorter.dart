// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

library bubble_sorter;
import 'dart:async';
import 'dart:math';

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
  
  final List<_Step> _sorterSteps = [];
  List<_Step> get _swapSteps => _sorterSteps.whereType<_SwapStep>().toList();
  int get swapStepsNumber => _swapSteps.isEmpty?0: _swapSteps.length-1;
  int get curSwapStepIndex => _curSwapStepIndex==-1?0:_curSwapStepIndex;

  //animation Variables
  int get animationStepSpeedInMs => 500;
  Timer? _animationTimer;
  int _curStepIndex = 0;
  int _curSwapStepIndex = 0;
  int _lastSortedIndex;
  int get lastSortedIndex => _lastSortedIndex;

  void startAnimation()
  {        
    if(_sorterSteps.isEmpty)
    {
      _lastSortedIndex = _numbers.length;
      sortWithoutAnimation();
      _curStepIndex = 0;
      _curSwapStepIndex = -1;
      _numbers = List.from(_originalNumbersList);      
    }
    else
    {
      goToStep(_curSwapStepIndex);
    }

    _animationStatus = SimpleAnimationStatus.animating;
    _animationTimer = Timer.periodic(
      Duration(milliseconds:animationStepSpeedInMs ),(timer){
        print('starting bubble sort animation step');
        if(_curStepIndex == _sorterSteps.length)
        {
          _animationTimer?.cancel();
          _animationStatus = SimpleAnimationStatus.stopped;
          _currentSelectionStream.add([]);          
          print('Animation completed');
          return;
        }

        final curStep = _sorterSteps[_curStepIndex];
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
    final step = _sorterSteps[_curStepIndex];
    step.execute();
    _curStepIndex++;
    if(step is _SwapStep)
      _curSwapStepIndex = min(_curSwapStepIndex+1,swapStepsNumber);
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
    _curSwapStepIndex = -1; //null
    _currentSelectionStream.add([]);
    _numbers = List.from(_originalNumbersList);
    _sorterSteps.clear();
  }

  void runRecordedSteps()
  {
    for (var step in _sorterSteps) {step.execute(); }
    _curSwapStepIndex = swapStepsNumber;
    _curStepIndex = _sorterSteps.length-1;
  }

  void goToStep(int stepIndex)
  {
    if(stepIndex > swapStepsNumber || stepIndex < 0)
    {
      print('Error, step must be in range [0,$swapStepsNumber]');
      return;
    }

    final steps = _sorterSteps.whereType<_SwapStep>().toList();
    if(_curSwapStepIndex<stepIndex)
    {
      for (var i = _curSwapStepIndex; i < stepIndex; i++) {
        final curStep = steps[i];
        curStep.execute();        
      }
    }
    else if(_curSwapStepIndex>stepIndex)
    {
      for (var i = _curSwapStepIndex-1; i >= stepIndex; i--) {
        final curStep = steps[i];
        curStep.reverse();        
      }
    }    
    else
    {
      //nothing
    }
    _curSwapStepIndex = stepIndex;
    _curStepIndex = _sorterSteps.indexWhere((step) => step == _swapSteps[_curSwapStepIndex]);
  }

  void sortWithoutAnimation()
  {          
    bool didASwap = false;
    do {
      _sorterSteps.add(_AnimationUpdateLastSortedIndexValueStep(this,_lastSortedIndex));
      didASwap = false;
      for (var i = 0; i < _lastSortedIndex-1; i++) 
      {
        final curNum = numbers[i];
        final nextNum = numbers[i+1];
        _sorterSteps.add(_AnimationHighlightSelectionStep(this,i));
        if(curNum>nextNum) 
        {
          _sorterSteps.add(_AnimationSwapStep(this));
          _sorterSteps.add(_SwapStep(this,i));
          _swap(numbers,i,i+1);
          didASwap = true;
        }
      }
      _lastSortedIndex--;
    } while (didASwap);
    _curStepIndex = _sorterSteps.length-1;
    _curSwapStepIndex = swapStepsNumber;
  }

  void _swap(List<int> arr,int i1,int i2)
  {
    var t1 = arr[i1];
    var t2 = arr[i2];
    arr[i1] = t2;
    arr[i2] = t1;
  }

}
