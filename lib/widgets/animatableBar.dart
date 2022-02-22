// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';

///either add contr
class AnimatableBar extends StatefulWidget {
  
  AnimatableBar(this.controller,{Key? key,}) : super(key: key);
  final AnimatableBarController? controller;
  
  @override
  State<AnimatableBar> createState() => _AnimatableBarState();
}

class _AnimatableBarState extends State<AnimatableBar> {
  int get value=>controller.value;
  late AnimatableBarController controller;
  bool get isHighlighted => controller.isHighlighted;
  bool get isSorted => controller.isSorted;

  @override
  void initState() {
    controller = widget.controller!;
    
    controller.addListener(_onNotify);
    super.initState();
  }

  _onNotify()
  {
    setState(() {});
  }
  
  @override
  void dispose() {
    controller.removeListener(_onNotify);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(child: bar(),offset: controller.offset,);
  }

  Widget bar() {
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
}

class AnimatableBarController extends ChangeNotifier 
{
  AnimatableBarController(this.value,{Offset offset=Offset.zero,bool isHighlighted=false,bool isSorted=false})
  :
  _isHighlighted = isHighlighted,
  _isSorted = isSorted,
  _offset = offset;
  
  final int value;  
  Offset _offset;
  bool _isHighlighted;
  bool _isSorted;

  Offset get offset => _offset;
  bool get isHighlighted => _isHighlighted;
  bool get isSorted => _isSorted;

  set offset(Offset val){
    _offset = val;
    notifyListeners();
  }
  set isHighlighted(bool val){
    _isHighlighted = val;
    notifyListeners();
  }
  set isSorted(bool val){
    _isSorted = val;
    notifyListeners();
  }
  
  reset()
  {
    _offset = Offset.zero;
    _isHighlighted = false;
    _isSorted = false;
    notifyListeners();
  }
}