class IsRandomNumberOverThreshold extends ConditionNode{

  int threshold; 
  RandomNumberStack random_stack;

  IsRandomNumberOverThreshold(int threshold, RandomNumberStack stack){
    super("is_random_number_over_threshold"); 
    this.threshold = threshold;
    this.random_stack = stack;
  }

  void checkRandomNumber(){
    // random_stack.dmpStack();
    int random_number = random_stack.refferStackTop();
    println("reffer -> ", random_number);
    if(threshold < random_number){
      this.is_met = true;
    }else{
      this.is_met = false;
    }
  }

  @Override
  NodeStatus evalNode(){
    checkRandomNumber();
    dumpResult();
    NodeStatus status = super.evalNode();
    // super.printName();
    return status;
  }

  // for debugging
  void dumpResult(){
    if(this.is_met){
      println("It's over! Threshold : ", threshold);
    }else{
      println("It's not over! Threshold : ", threshold);
    }
  }

}

