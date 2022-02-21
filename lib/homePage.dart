// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// ignore_for_file: avoid_print

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> numbers = [3,38,5,44,15,36,26,27,2,46,4,19,47,50,48];

  void bubbleSort(){
    bool didASwap = false;
    do {
      didASwap = false;
      for (var i = 0; i < numbers.length-1; i++) {
        final curNum = numbers[i];
        final nextNum = numbers[i+1];
        if(curNum>nextNum) 
        {
          swap(numbers,i,i+1);
          didASwap = true;
        }
      }
    } while (didASwap);
  }

  void swap(List<int> arr,int i1,int i2)
  {
    var t1 = arr[i1];
    var t2 = arr[i2];
    arr[i1] = t2;
    arr[i2] = t1;
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
          children: <Widget>[
            barsList(),
            actionBtns()
          ],
        ),
      ),
    );
  }

  Widget actionBtns()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: (){
                  setState(() {
                    numbers = [3,38,5,44,15,36,26,27,2,46,4,19,47,50,48];
                  });
                  print(numbers);
                },child: Text('Reset'),),
                SizedBox(width: 20,),
        ElevatedButton(onPressed: (){
                  bubbleSort();
                  setState(() {});
                  print(numbers);
                },child: Text('bubble sort'),),
      ],
    );
  }

  Widget barsList()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: numbers.map((e) => Padding(
        padding: const EdgeInsets.symmetric(horizontal:2.0),
        child: bar(e),
      )).toList(),);
  }

  Widget bar(int value)
  {
    if(value < 20)
    {
      return Column(
        children: [
          Text('$value',style: TextStyle(color: Colors.black),),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomCenter,
            height: value.toDouble(),
            color: Colors.black,
            width: 30,
          ),
        ],
      );
    }
    else
    {
      return Container(
        padding: EdgeInsets.only(bottom: 5),
        alignment: Alignment.bottomCenter,
        height: value.toDouble(),
        color: Colors.black,
        width: 30,
        child: Text('$value',style: TextStyle(color: Colors.white),),
      );
    }
  }
}
