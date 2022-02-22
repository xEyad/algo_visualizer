// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';


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
  
  //animation Variables
  int get _animationSpeedInMs => 100;
  late Timer animationTimer;
  int _curStepIndex = 0;
  bool _isSwapHappenedInFullLoop = false;
  int _stepsPerformed = 0;
  int _lastSortedIndex;
  int get lastSortedIndex => _lastSortedIndex;

  void startAnimation()
  {        
    animationTimer = Timer.periodic(
      Duration(milliseconds:_animationSpeedInMs ),(timer){

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
          animationTimer.cancel();
          print('Animation completed');
        }
      }
    );
  }

  void pauseAnimation()
  {
    animationTimer.cancel();
    print('Animation paused');
  }

  void stopAnimation()
  {
    animationTimer.cancel();
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
      _currentSelectionStream.add([_curStepIndex,_curStepIndex+1]);
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