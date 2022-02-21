// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';


class BubbleSorter
{
  BubbleSorter(this._numbers)
  :
  _originalNumbersList = List.from(_numbers);
  
  int fps = 60;
  final List<int> _originalNumbersList;
  List<int> _numbers;
  List<int> get numbers => _numbers;
  final _currentSelectionStream = StreamController<List<int>>();
  Stream<List<int>> get currentSelectionStream =>  _currentSelectionStream.stream;
  
  void startAnimation()
  {    
    sortWithAnimation();
  }

  void stopAnimation()
  {

  }

  void reset()
  {
    _numbers = List.from(_originalNumbersList);
  }

  void sortWithAnimation() async
  {
    double deltaTime = 0;
    double frameTime = fps/1000;
    bool didASwap = false;
    do {
      //not enough time has passed between frames
      if(deltaTime<frameTime)
      {
        didASwap = true;
        continue;
      }
      else    
        deltaTime = 0;  
      
      didASwap = false;
      for (var i = 0; i < numbers.length-1; i++) {
        final curNum = numbers[i];
        final nextNum = numbers[i+1];
        _currentSelectionStream.add([i,i+1]);
        if(curNum>nextNum) 
        {
          _swap(numbers,i,i+1);
          didASwap = true;
        }
      }
    } while (didASwap);
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