enum NodeStatus{
  SUCCESS, FAILURE, RUNNING;
}

enum Direction{
  UP, LEFT, RIGHT, DOWN;
}


class BehaviorTreeNode{
  int id; // do you use it?
  String name;
  NodeStatus status;

  BehaviorTreeNode(String node_name){
    name = node_name;
  }

  // for debug 
  void printName(){
    println("the name of this node is ", name); 
  }

}

class ControlNode extends BehaviorTreeNode{

  ArrayList<BehaviorTreeNode> children;
  ArrayList<LeafNode> leaf_children;

  ControlNode(String node_name){
    super(node_name);

    // TODO : should be unified into one ... 
    children = new ArrayList<BehaviorTreeNode>();
    leaf_children = new ArrayList<LeafNode>();
  }

  void addChild(BehaviorTreeNode new_node){
    children.add(new_node);  
  }

  void addLeafChildren(LeafNode new_leaf){
    leaf_children.add(new_leaf);
  } 

  void printAllChildren(){
    int len = children.size();
    for(int i=0; i<len; i++){
      children.get(i).printName();
    }
  }

  void executeAllLeaf(){
    int len = leaf_children.size();

    for(int i=0; i<len; i++){
      leaf_children.get(i).evalLeaf();
    }
  }
}

class SequenceNode extends ControlNode{

  int number_children;
  int number_executed;

  SequenceNode(String node_name){

    super(node_name);
    number_executed  = 0;


  }
 
  // TODO : handle the case the target includes control node 
  // this implementation cannot handle those cases...
  NodeStatus executeAllChildren(){

    number_children = this.leaf_children.size();

    NodeStatus sequence_status = null;

    if(number_executed == number_children){
      sequence_status = NodeStatus.SUCCESS;

    }else{

      // check the leaf currently being processed
      LeafNode process_leaf = leaf_children.get(number_executed);
      NodeStatus leaf_result = process_leaf.evalLeaf();
  
      switch(leaf_result){
          case SUCCESS:
            number_executed++;
            sequence_status = NodeStatus.RUNNING;
            break;
          case FAILURE:
            sequence_status = NodeStatus.FAILURE;
            break;
          case RUNNING:
            sequence_status = NodeStatus.RUNNING;
            break;
      }
    }

    return sequence_status;
  }

}


class LeafNode{
  int id; // do you use it?
  String name;
  NodeStatus status;
  
  LeafNode(String node_name){
    name = node_name;
  }

  NodeStatus evalLeaf(){
    // println("evalleaf() was called on LeafNode");
    return null;
  }
}


class ConditionNode extends LeafNode{
  
  boolean is_met;
  NodeStatus status;

  ConditionNode(String node_name){
    super(node_name);
    this.is_met = false;
  }

  void checkCondition(){
    if(is_met){
      status =  NodeStatus.SUCCESS;
    }else{
      status =  NodeStatus.FAILURE;
    }
  }

  @Override
  NodeStatus evalLeaf(){
    // println("evalLeaf() was called on ConditionNode");
    checkCondition();
    return this.status;
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


class ActionNode extends LeafNode{

  int required_time;

  ActionNode(String node_name, int required_time){
    super(node_name);
    this.required_time = required_time;
  }
 
  NodeStatus Action(){
    if(0 < required_time){
      required_time--;
      println("required time : ", required_time);
      return NodeStatus.RUNNING;
    }
    else{
      return NodeStatus.SUCCESS;
    }
  }

  @Override
  NodeStatus evalLeaf(){
    // println("evalLeaf() was called on ActionNode");
    NodeStatus status;
    status = this.Action();
    return status;
  }

}


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
  
class Walk extends ActionNode{
  
  Walk(){
    // set action name
    super("Walk",30);

  }

  @Override
  NodeStatus Action(){
    println("this is ", name);
    println("I'm walking!!");

    // decrement required time
    NodeStatus status = super.Action(); 
    return status;
  }

}

class Attack extends ActionNode{

  Attack(){
    // set action name
    super("Attack", 10);
  }

  @Override
  NodeStatus Action(){
    println("this is ", name);
    println("I'm Attacking!!");

    NodeStatus status = super.Action(); 
    return status;
  }

}

