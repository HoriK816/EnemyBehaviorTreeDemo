enum NodeStatus{
  SUCCESS, FAILURE, RUNNING;
}


class BehaviorTreeNode{

  String name;
  NodeStatus status;

  BehaviorTreeNode(String node_name){
    name = node_name;
  }

  // for debug 
  void printName(){
    println("the name of this node is ", name); 
  }

  // deribative classes should override this method
  NodeStatus evalNode(){
    return null;
  }

}


class ControlNode extends BehaviorTreeNode{

  ArrayList<BehaviorTreeNode> children;

  ControlNode(String node_name){
    super(node_name);
    children = new ArrayList<BehaviorTreeNode>();
  }

  void addChild(BehaviorTreeNode new_node){
    children.add(new_node);  
  }

  void printAllChildren(){
    int len = children.size();
    for(int i=0; i<len; i++){
      children.get(i).printName();
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

  NodeStatus executeAllChildren(){

    NodeStatus sequence_status = null;

    number_children = this.children.size();

    if(number_executed == number_children){
      sequence_status = NodeStatus.SUCCESS;
    }else{

      // check the child node currently being processed
      BehaviorTreeNode process_node = children.get(number_executed);
      NodeStatus process_result = process_node.evalNode();
  
      switch(process_result){
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

  @Override
  NodeStatus evalNode(){
    NodeStatus result;
    result = this.executeAllChildren();
    return result;
  }

}


class SelectorNode extends ControlNode{

  int number_children;
  int number_executed;
    
  SelectorNode(String node_name){
    super(node_name);
    number_executed = 0;
  }

  NodeStatus executeChildren(){

    NodeStatus selector_status = null;

    BehaviorTreeNode process_node = children.get(number_executed);
    NodeStatus node_result = process_node.evalNode();
 
    number_children = this.children.size();

    if(number_executed == number_children){
      // reaching the final node means that no node returns SUCCESS
      selector_status = NodeStatus.FAILURE;

    }else{

      switch(node_result){
        case SUCCESS:
          selector_status = NodeStatus.SUCCESS;
          break;
        case FAILURE:
          number_executed++;
          selector_status = NodeStatus.RUNNING;
          break;
        case RUNNING:
          selector_status = NodeStatus.RUNNING;
          break;
        }
    }
    return selector_status;
  }

  @Override
  NodeStatus evalNode(){
    NodeStatus result;
    result = executeChildren();
    return result;
  }

}


class DecoratorNode extends BehaviorTreeNode{

  BehaviorTreeNode child;

  DecoratorNode(String node_name){
    super(node_name);
  }

  void setChild(BehaviorTreeNode new_node){
    this.child = new_node;
  }

}


class InverterNode extends DecoratorNode{

  InverterNode(String node_name){
    super(node_name);

  }

  @Override
  NodeStatus evalNode(){
    NodeStatus result;
    result = child.evalNode();

    switch(result){
      case SUCCESS:
        result = NodeStatus.FAILURE; 
        break;
      case FAILURE:
        result = NodeStatus.SUCCESS;
        break;
      case RUNNING:
        result = NodeStatus.RUNNING;
        break;
    }
    return result;
  }

}


class RepeaterNode extends DecoratorNode{

  int repeat_times;

  RepeaterNode(String node_name, int repeat_times){
    super(node_name);
    this.repeat_times = repeat_times;
  }

  @Override
  NodeStatus evalNode(){
    NodeStatus result;
    result = child.evalNode();

    switch(result){
      case SUCCESS:
        result = NodeStatus.RUNNING;
        repeat_times--;
        break;
      case FAILURE:
        result = NodeStatus.FAILURE;
        break;
      case RUNNING:
        result = NodeStatus.RUNNING;
        break;
    }

    if(repeat_times == 0){
      result = NodeStatus.SUCCESS;
    }

    return result;

  }

}


class RetryUntilSuccessfulNode extends DecoratorNode{
  
  RetryUntilSuccessfulNode(String node_name){
    super(node_name);
  }
}


class KeepRunningUntilFailureNode extends DecoratorNode{

  KeepRunningUntilFailureNode(String node_name){
    super(node_name);
  }
}

class LeafNode extends BehaviorTreeNode{ 

  NodeStatus status;
  
  LeafNode(String node_name){
    super(node_name);
  }

  NodeStatus evalNode(){
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
  NodeStatus evalNode(){
    checkCondition();
    return this.status; 
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
  NodeStatus evalNode(){
    NodeStatus result;
    result = this.Action();
    return result;

  }

}

