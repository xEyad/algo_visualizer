part of bubble_sorter;

abstract class _Step
{
  final BubbleSorter sorter;
  _Step(this.sorter);
  void execute();
  void reverse();
}

class _SwapStep extends _Step
{
  final int curStepIndex;
  _SwapStep(BubbleSorter sorter,this.curStepIndex):super(sorter);

  @override
  void execute() {
    sorter._swap(sorter._numbers, curStepIndex,curStepIndex+1);
  }

  @override
  void reverse() {
    // TODO: implement reverse
  }
  
}

class _AnimationHighlightSelectionStep extends _Step
{
  final int curStepIndex;
  _AnimationHighlightSelectionStep(BubbleSorter sorter,this.curStepIndex):super(sorter);

  @override
  void execute() {
    sorter._currentSelectionStream.add([curStepIndex,curStepIndex+1]);
  }

  @override
  void reverse() {
    // TODO: implement reverse
  }
  
}

class _AnimationSwapStep extends _Step
{
  _AnimationSwapStep(BubbleSorter sorter):super(sorter);

  @override
  void execute() {
    sorter._willSwapSelectionStream.add(true);
  }

  @override
  void reverse() {
    // TODO: implement reverse
  }
  
}

class _AnimationUpdateLastSortedIndexValueStep extends _Step
{
  final int lastSortedIndex;
  _AnimationUpdateLastSortedIndexValueStep(BubbleSorter sorter,this.lastSortedIndex):super(sorter);

  @override
  void execute() {
    sorter._lastSortedIndex = lastSortedIndex;
  }

  @override
  void reverse() {
    // TODO: implement reverse
  }
  
}

