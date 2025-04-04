// this is a test method for the Behavior Tree
void testBehaviorTree(){
  root.printName();

  // tree test (debug)
  /*
   
  BehaviorTreeNode left_child = new BehaviorTreeNode("left");
  BehaviorTreeNode right_child = new BehaviorTreeNode("right");
  root.addChild(left_child);
  root.addChild(right_child);

  root.printAllChildren();

  */

  // leaf node test (debug)
  DummyAction action_1 = new DummyAction("dummy 1", 10);
  DummyAction action_2 = new DummyAction("dummy 2", 10);
  root.addChild(action_1);
  root.addChild(action_2);

  // action node test (debug)
  Walk walk = new Walk();
  Attack attack = new Attack();
  root.addChild(walk);
  root.addChild(attack);

  // condition node test (debug)
  DummyCondition dummy_condition = new DummyCondition("sum checker");
  root.addChild(dummy_condition);

  root.printAllChildren();

}


// this is a test method for the Sequence Tree
void testSequenceTree(){
  if(is_finished){
    return;
  }
  
  println("execute something");
  NodeStatus result = root.evalNode();
 
  if(result == NodeStatus.SUCCESS){
    is_finished = true;
  }

}

// this is a test method for the Selecter Tree
void testSelectorTree(){
  if(is_finished){
    return;
  }

  NodeStatus result = root.evalNode();

  if(result == NodeStatus.SUCCESS){
    is_finished = true;
  }

}

void testInverter(){

  root.printName();

  DummyAction action_1 = new DummyAction("dummy 1", 0);

  InverterNode inv1 = new InverterNode("inverter 1");
  InverterNode inv2 = new InverterNode("inverter 2");

  root.addChild(inv1);
  inv1.setChild(inv2);
  inv2.setChild(action_1);

  NodeStatus result = root.evalNode();
  if(result == NodeStatus.SUCCESS){
    println("inverter is worked!");
  }else{
    println("inverter is not worked...");
  }
  return;
}


// for debug
void setupRepeater(){
  root.printName();

  DummyAction action_1 = new DummyAction("dummy 1", 1);

  RepeaterNode rep1 = new RepeaterNode("repeater 1", 5);  
  
  root.addChild(rep1);
  rep1.setChild(action_1);

  is_finished = false;
}

void testRepeater(){
  
  if(is_finished){
    return;
  }

  NodeStatus result = root.evalNode();

  if(result == NodeStatus.SUCCESS){
    is_finished = true;
  }

}

void setupRetryUntilSuccessfulNode(){
  root.printName();

  DummyRandomFailureAction action_1 = new DummyRandomFailureAction("dummy 1", 1);

  RetryUntilSuccessfulNode retry = new RetryUntilSuccessfulNode("retry until success", 5);

  root.addChild(retry);
  retry.setChild(action_1);

  is_finished = false;
}

void testRetryUntilSucessfulNode(){
  
  if(is_finished){
    return;
  }
  
  NodeStatus result = root.evalNode();

  if(result == NodeStatus.SUCCESS){
    println("SUCCESS!");
    is_finished = true;
  }else if(result == NodeStatus.FAILURE){
    println("FAILURE!");
    is_finished = true;
  }
}


void setupKeepRunningUntilFailureNode(){
  root.printName();

  DummyRandomFailureAction action_1 = new DummyRandomFailureAction("dummy 1", 1);

  KeepRunningUntilFailureNode until_failure = new KeepRunningUntilFailureNode("keep until failure");

  root.addChild(until_failure);
  until_failure.setChild(action_1);

  is_finished = false;
}


void testKeepRunnningUntilFailureNode(){
  
  if(is_finished){
    return;
  }
  
  NodeStatus result = root.evalNode();

  if(result == NodeStatus.RUNNING){
    println("RUNNING!");
  }else if(result == NodeStatus.FAILURE){
    println("FAILURE!");
    is_finished = true;
  }
}
