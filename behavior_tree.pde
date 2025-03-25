enum NodeStatus{
  SUCCESS, FAILURE, RUNNING;
}

enum Direction{
  UP, LEFT, RIGHT, DOWN;
}

class MovePath{

  ArrayList<Direction> move_direction;
  ArrayList<int> move_speed;

  MovePath(){
    move_direction = new ArrayList<Direction>();
    move_speed = new ArrayList<int>();
  }

  void addPath(Direction direction, int speed){
    this.move_direction.add(direction); 
    this.move_speed.add(speed); 
  }

  // for debugging
  void printAllPath(){
    for(int i = 0; i<move_direction.size(); i++){

      Direction direction = move_direction.get(i);
      int speed = move_speed.get(i);

      println("(", direction, ", ", speed,")");
    }
  }

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
  NodeStatus evalNode(){
    NodeStatus result;
    result = this.Action();
    return result;

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

class EnemyWalk extends ActionNode{

  Enemy enemy;
  boolean route_calc_done = false;

  MovePath path = new MovePath();


  EnemyWalk(String action_name, int required_time, Enemy enemy){
    this.enemy = enemy;
    super("walk",30);
  }


  @Override
  NodeStatus Action(){
    if(!route_calc_done){
      PVecotr dest = decideDestination(); 
      
      // are these parameter appropriate??? 
      calcPath(dest, enemy.position, enemy.speed);

      this.printPath();
    }

    
    // for debugging
    NodeStatus status = NodeStatus.SUCCESS;

    // it's correct behavior that calls super.
    /* 
    NodeStatus status = super.Action(); 
    */


    return status;
  }


  PVector decideDestination(){

    dest_x = random(0, WINDOW_WIDTH);
    dest_y = random(0, WIDNWO_HEIGHT);

    dest = new PVector(dest_x, dest_y);
    return dest;

  }


  void printPath(){
    this.path.printAllPath();
  }


  void calcPath(PVector dest, PVector current_position, int max_speed){

    boolean move_x_done = false;
    boolean move_y_done = false;
     
    diff_x = dest.x - current_position.x;
    diff_y = dest.y - current_position.y;
  
    // x direction
    while(move_x_done){

        if(dif_x == 0){ // no need to move
          move_x_done = true;

        }else if(0 < diff_x){ // move to right

          if(abs(diff_x) < max_speed){ // move in one frame
            path.addPath(Direction.RIGHT, abs(diff_x));
            move_x_done = true;

          }else{
            path.addPath(Direction.RIGHT, max_speed);
          }

        }else{ // move to left

          if(abs(diff_x) < max_speed){ // move in one frame
            path.addPath(Direction.LEFT, abs(diff_x));
            move_x_done = true;

          }else{
            path.addPath(Direction.Left, max_speed);
          }

        }
    }

    // y direction
    while(move_y_done){

        if(dif_y == 0){
          move_y_done = true;

        }else if(0 < diff_y){ // move to down

          if(abs(diff_y) < max_speed){ // move in one frame
            path.addPath(Direction.DOWN, abs(diff_y));
            move_y_done = true;

          }else{
            path.addPath(Direction.DOWN, max_speed);
          }

        }else{ // move to up
      
          if(abs(diff_y)< max_speed){ // move in one frame
            path.addPath(Direction.UP, abs(diff_y));
            move_y_done = true;

          }else{
            path.addPath(Direction.UP,  max_speed);
          }

        }

    }
  
    route_calc_done = true;
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

