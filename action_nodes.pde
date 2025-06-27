/* This class implements the action that enemy walks to random destination  */ 
class RandomEnemyWalk extends ActionNode {
    Enemy enemy;
    MovePath path = new MovePath();
    boolean isRouteSet = false;
    PVector dest;

    int move_count = 0;

    RandomEnemyWalk(String node_name, int required_time, Enemy enemy) {
        super(node_name, required_time);
        this.enemy = enemy;
    }

    @Override
    NodeStatus Action(){
        NodeStatus status;

        /* set random destination at a first */
        if(!isRouteSet){
            PVector dest = decideDestination(); 
            calcPath(dest, enemy.position, enemy.max_speed);
        }

        /* move character according to the calculated path */
        if (this.move_count == path.numberOfMovement) {
            remained_time = 0;
        } else {
          Direction move_dir = path.movingDirection.get(this.move_count);
          int move_speed = path.movingSpeed.get(this.move_count);
          enemy.move(move_dir, move_speed);
        }
        this.move_count++;

        status = super.Action(); 
        return status;
    }

    PVector decideDestination() {
        float dest_x = random(0, WINDOW_WIDTH);
        float dest_y = random(0, WINDOW_HEIGHT);

        dest = new PVector(dest_x, dest_y);
        return dest;
    }

    void calcPath(PVector dest, PVector current_position, int max_speed) {
        PathCalculator path_calculator = new PathCalculator(path);

        path = path_calculator.calcPath(dest, current_position, max_speed);
        isRouteSet = true;
    }
}


class CloseToPlayer extends ActionNode {
    Enemy enemy;
    Player player;
    boolean route_calc_done = false;
    PVector dest;
    MovePath path = new MovePath();
    int move_count = 0;

    CloseToPlayer(String node_name, int required_time, Enemy enemy, Player player){
        super(node_name, required_time);
        this.enemy  = enemy;
        this.player = player;
    }

    @Override
    NodeStatus Action(){
      if(!route_calc_done){
        PVector dest = decideDestination(); 
        calcPath(dest, enemy.position, enemy.max_speed);
      }

      // move character
      if(this.move_count == path.numberOfMovement){
        remained_time = 0;
      }else{
        Direction move_dir = path.movingDirection.get(this.move_count);
        int move_speed = path.movingSpeed.get(this.move_count);
        enemy.move(move_dir, move_speed);
      }
      this.move_count++;

      NodeStatus status = super.Action(); 
      return status;
    }

    PVector decideDestination(){
        float dest_x = player.position.x; 
        float dest_y = player.position.y;
        dest = new PVector(dest_x, dest_y);
        return dest;
    }

    void calcPath(PVector dest, PVector current_position, int max_speed){
        PathCalculator path_calculator = new PathCalculator(path);
        path = path_calculator.calcPath(dest, current_position, max_speed);
        route_calc_done = true;
    }
  }
   
class EnemyRangeAttack extends ActionNode{
    Enemy enemy;
    Player player;
    ArrayList<Bullet> bullet;
   
    EnemyRangeAttack(String node_name, int required_time,
                     Enemy enemy, Player player) {
        super(node_name, required_time);
        this.player = player;
        this.enemy  = enemy;
        this.bullet = enemy_bullets;
        this.enable_repeat = true;
    };

    @Override
    NodeStatus Action() {
        NodeStatus status; 

        if (!is_finished) {
            enemy.aim_shot(bullet, player);
            is_finished = true;
        }

        status = super.Action(); 
        return status;
    }
}

class EnemyAllRangeShot extends ActionNode{
    Enemy enemy;
    Player player;
    ArrayList<Bullet> bullet;
   
    EnemyAllRangeShot(String node_name, int required_time, Enemy enemy) {
        super(node_name, required_time);

        this.player = player;
        this.enemy = enemy;
        this.bullet = enemy_bullets;
        this.enable_repeat = true;
    };

    @Override
    NodeStatus Action() {
        NodeStatus status;

        if (!is_finished) {
            enemy.all_range_shot(bullet);
            is_finished = true;
        }

        status = super.Action(); 
        return status;
    }
}

 
class EnemyNWayShot extends ActionNode{
    Enemy enemy;
    Player player;
    ArrayList<Bullet> bullet;
   
    EnemyNWayShot(String node_name, int required_time,
                  Enemy enemy, Player player) {
        super(node_name, required_time);
        this.player = player;
        this.enemy = enemy;
        this.bullet = enemy_bullets;
        this.enable_repeat = true;
    };

    @Override
    NodeStatus Action() {
      NodeStatus status;

      if (!is_finished) {
          enemy.nway_shot(bullet, player);
          is_finished = true;
      }

      status = super.Action(); 
      return status;
    }
}


class EnemyMeleeAttack extends ActionNode{
  Enemy enemy;
  Sword sword;
 
    EnemyMeleeAttack(String node_name, int required_time,
                     Enemy enemy, Sword sword) {
        super(node_name, required_time);
        this.enemy = enemy;
        this.sword = sword;
    }

    @Override
    NodeStatus Action(){
        NodeStatus status;

        enemy.melleAttack(sword);
        status = super.Action(); 
        return status;
    }
}


class RandomNumberStack {
    int random_number_stack[];
    int stack_top; 

    RandomNumberStack() {
        this.random_number_stack = new int[100];
        this.stack_top = 0;
    }
    
    int refferStackTop() {
        return random_number_stack[this.stack_top-1];
    }

    void push(int random_number) {
        this.random_number_stack[stack_top] = random_number;
        this.stack_top++;
    }

    void removeStackTop() {
        stack_top--;
    }
}

class RandomGenerator extends ActionNode {
    RandomNumberStack stack;

    RandomGenerator(RandomNumberStack stack) {
        super("RandomGenerator", 1);
        this.stack = stack;
    }

    void generateRandomNumber() {
        int random_number = (int)random(0,100);
        stack.push(random_number);
    }

    @Override
    NodeStatus Action() {
        NodeStatus status;

        if (this.required_time != 0) {
            this.generateRandomNumber();
        }

        status = super.Action();
        return status;
    }
}


class ReleaseRandomStackTop extends ActionNode{
    RandomNumberStack stack;

    ReleaseRandomStackTop(RandomNumberStack stack) {
        super("ReleaseRandomStackTop", 1);
        this.stack = stack;
    }

    void releaseRandomNumber() {
        stack.removeStackTop();
    }

    @Override
    NodeStatus Action() {
        NodeStatus status;

        if (this.required_time != 0) {
            this.releaseRandomNumber(); 
        }
        status = super.Action();
        return status;
    }
}

