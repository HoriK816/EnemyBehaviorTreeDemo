// test action (debug)
class DummyAction extends ActionNode{

  DummyAction(String node_name, int required_time){
    super(node_name, required_time);
  }

  @Override
  NodeStatus Action(){
    println("this is ", name);
    println("I have finished something!");

    // decrement required time
    NodeStatus status = super.Action(); 
    return status;
  }

}

class DummyRandomFailureAction extends ActionNode{
  
  DummyRandomFailureAction(String node_name, int required_time){
    super(node_name, required_time);
  }

  @Override
  NodeStatus Action(){
    
    NodeStatus result; 
    int coin = (int)random(0,10);

    if(coin < 8){
      println("I did it!");
      result = NodeStatus.SUCCESS;
    }else{
      println("oh!, I made a mistake!!");
      result = NodeStatus.FAILURE;

    }

    return result;
  }

}


class DummyCondition extends ConditionNode{
  
  DummyCondition(String node_name){
    super(node_name);
  }

  void checkSumAnswer(){
    int sum = 0;

    for(int i = 0; i<= 10; i++){
      sum += i;
    }

    if(sum == 55){
      println("correct! sum is ", 55);

    }

    is_met = true;
  }

  @Override
  void checkCondition(){
    checkSumAnswer();
    super.checkCondition();
  }

}
