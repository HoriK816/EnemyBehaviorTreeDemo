/* The class is the base class of attack actions.*/
class Attack extends ActionNode{

  Attack(){ // set action name
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

class Walk extends ActionNode{
  
  Walk(){
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


/* This class implements that enemy walks to the specified destination */ 
class EnemyWalk extends ActionNode{

  Enemy enemy;
  boolean route_calc_done = false;
  PVector dest;

  MovePath path = new MovePath();
  int move_count = 0;

  EnemyWalk(String node_name, int required_time, Enemy enemy){
    super(node_name, required_time);
    this.enemy = enemy;
  }

  @Override
  NodeStatus Action(){
    if(!route_calc_done){
      PVector dest = decideDestination(); 
      calcPath(dest, enemy.position, enemy.max_speed);
    }

    // move character
    if(this.move_count == path.number_of_movement){
      required_time = 0;
    }else{
      Direction move_dir = path.move_direction.get(this.move_count);
      int move_speed = path.move_speed.get(this.move_count);
      enemy.move(move_dir, move_speed);
    }
    this.move_count++;

    NodeStatus status = super.Action(); 
    return status;
  }

  PVector decideDestination(){
    float dest_x = random(0, WINDOW_WIDTH);
    float dest_y = random(0, WINDOW_HEIGHT);
    dest = new PVector(dest_x, dest_y);
    return dest;
  }

  void calcPath(PVector dest, PVector current_position, int max_speed){
    RouteCalculator route_calculator = new RouteCalculator(path);
    path = route_calculator.calcPath(dest, current_position, max_speed);
    route_calc_done = true;
    this.printPath();
  }

  void printPath(){
    println("printPath()");
    this.path.printAllPath();
  }
}


class EnemyAttack extends ActionNode{
	Enemy enemy;
	Player player;
	ArrayList<Bullet> bullet;
 
  EnemyAttack(String node_name, int required_time, Enemy enemy, Player player){
    super(node_name, required_time);
		this.player = player;
		this.enemy = enemy;
		this.bullet = enemy_bullets;
  };

  @Override
  NodeStatus Action(){
	  enemy.aim_shot(bullet, player);
    NodeStatus status = super.Action(); 
		return status;
  }
}

class RandomNumberStack{
  int random_number_stack[];
  int stack_top; 

  RandomNumberStack(){
    this.random_number_stack = new int[100];
    this.stack_top = 0;
  }
  
  int refferStackTop(){
    return random_number_stack[this.stack_top];
  }

  void push(int random_number){
    this.random_number_stack[stack_top] = random_number;
    this.stack_top++;
    println("---pushed -------");
    this.dumpStack();
    println("-----------------");
  }

  void removeStackTop(){
    stack_top--;
    println("---remove stack top-------");
    this.dumpStack();
    println("-----------------");
  }

  // for debugging
  void dumpStack(){
    for(int i=0; i<stack_top; i++){
      print("| ", random_number_stack[i]," ");
    }
    println("");
  }
}

class RandomGenerator extends ActionNode{

  RandomNumberStack stack;

  RandomGenerator(RandomNumberStack stack){
    super("RandomGenerator", 1);
    this.stack = stack;
  }

  void generateRandomNumber(){
    int random_number = (int)random(0,100);
    stack.push(random_number);
  }

  @Override
  NodeStatus Action(){
    this.generateRandomNumber();
    NodeStatus status = super.Action();
    // super.printName();
    return status;
  }
}


class ReleaseRandomStackTop extends ActionNode{
  
  RandomNumberStack stack;

  ReleaseRandomStackTop(RandomNumberStack stack){
    super("ReleaseRandomStackTop", 1);
    this.stack = stack;
  }

  void releaseRandomNumber(){
    stack.removeStackTop();
  }

  @Override
  NodeStatus Action(){
    this.releaseRandomNumber(); 
    NodeStatus status = super.Action();
    // super.printName();
    return status;
  }
}

