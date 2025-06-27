/* This class implements the action that enemy walks to random destination  */ 
class RandomEnemyWalk extends ActionNode {
    MovePath path        = new MovePath();
    boolean  isRouteSet  = false;
    int      movingCount = 0;
    Enemy    enemy;    

    RandomEnemyWalk(String node_name, int requiredTotalFrames, Enemy enemy) {
        super(node_name, requiredTotalFrames);
        this.enemy = enemy;
    }

    /* 
    * the character moves to destination according to the calculated path
    */
    @Override
    NodeStatus Action(){
        NodeStatus status;

        /* set random destination at a first */
        if(!isRouteSet){
            PVector dest = decideDestination(); 
            calcPath(dest, enemy.position, enemy.maxSpeed);
        }

        /* when the character reaches the destination */
        if (movingCount == path.numberOfMovement) {
            remainedFrames = 0;

        /* move to destination */
        } else {
            Direction movingDirection; 
            int movingSpeed;
            
            /* get path information */
            movingDirection = path.movingDirection.get(this.movingCount);
            movingSpeed     = path.movingSpeed.get(this.movingCount);

            /* move the character (enemy)*/
            enemy.move(movingDirection, movingSpeed);
        }
        this.movingCount++;

        /* execute process related to the remains frames at the method 
         * in the super class, mainly */
        status = super.Action(); 
        return status;
    }

    PVector decideDestination() {
        float   dest_x;
        float   dest_y;
        PVector dest;

        /* decide the destination randomly */
        dest_x = random(0, WINDOW_WIDTH);
        dest_y = random(0, WINDOW_HEIGHT);
        dest   = new PVector(dest_x, dest_y);
        return dest;
    }

    void calcPath(PVector dest, PVector source, int maxSpeed) {
        PathCalculator pathCalculator = new PathCalculator(path);

        path       = pathCalculator.calcPath(dest, source, maxSpeed);
        isRouteSet = true;
    }
}


/* This class implements the action that enemy close to the player */
class CloseToPlayer extends ActionNode {
    MovePath path        = new MovePath();
    boolean  isRouteSet  = false;
    int      movingCount = 0;
    Enemy    enemy;  
    Player   player; // FIXME: it's not good. you must minimal access to fields.

    CloseToPlayer(String node_name, int requiredTotalFrames,
                  Enemy enemy, Player player) {
        super(node_name, requiredTotalFrames);
        this.enemy  = enemy;
        this.player = player;
    }

    /* 
    * the character moves to destination according to the calculated path
    */
    @Override
    NodeStatus Action(){
        NodeStatus status;

        /* set random destination at a first */
        if(!isRouteSet){
            PVector dest = decideDestination(); 
            calcPath(dest, enemy.position, enemy.maxSpeed);
        }

        /* when the character reaches the destination */
        if (movingCount == path.numberOfMovement) {
            remainedFrames = 0;

        /* move to destination */
        } else {
            Direction movingDirection; 
            int movingSpeed;
            
            /* get path information */
            movingDirection = path.movingDirection.get(this.movingCount);
            movingSpeed     = path.movingSpeed.get(this.movingCount);

            /* move the character (enemy)*/
            enemy.move(movingDirection, movingSpeed);
        }
        this.movingCount++;

        /* execute process related to the remains frames at the method 
         * in the super class, mainly */
        status = super.Action(); 
        return status;
    }

    PVector decideDestination() {
        float   dest_x;
        float   dest_y;
        PVector dest;

        dest_x = player.position.x; 
        dest_y = player.position.y;
        dest   = new PVector(dest_x, dest_y);
        return dest;
    }

    void calcPath(PVector dest, PVector source, int maxSpeed) {
        PathCalculator pathCalculator = new PathCalculator(path);

        path       = pathCalculator.calcPath(dest, source, maxSpeed);
        isRouteSet = true;
    }
}


class EnemyRangeAttack extends ActionNode{
    Enemy enemy; // FIXME: it's not good. you must minimal access to fields.
    Player player; // FIXME: it's not good. you must minimal access to fields.
    ArrayList<Bullet> bullet;
   
    EnemyRangeAttack(String node_name, int requiredTotalFrames,
                     Enemy enemy, Player player) {
        super(node_name, requiredTotalFrames);
        this.player = player;
        this.enemy  = enemy;
        this.bullet = enemy_bullets;
        this.enableRepeat = true;
    };

    @Override
    NodeStatus Action() {
        NodeStatus status; 

        if (!isFinished) {
            enemy.aim_shot(bullet, player);
            isFinished = true;
        }

        status = super.Action(); 
        return status;
    }
}


class EnemyAllRangeShot extends ActionNode{
    Enemy enemy; // FIXME: it's not good. you must minimal access to fields.
    Player player; // FIXME: it's not good. you must minimal access to fields.
    ArrayList<Bullet> bullet;
   
    EnemyAllRangeShot(String node_name, int requiredTotalFrames, Enemy enemy) {
        super(node_name, requiredTotalFrames);

        this.player = player;
        this.enemy = enemy;
        this.bullet = enemy_bullets;
        this.enableRepeat = true;
    };

    @Override
    NodeStatus Action() {
        NodeStatus status;

        if (!isFinished) {
            enemy.all_range_shot(bullet);
            isFinished = true;
        }

        status = super.Action(); 
        return status;
    }
}

 
class EnemyNWayShot extends ActionNode{
    Enemy enemy; 
    Player player; // FIXME: it's not good. you must minimal access to fields.
    ArrayList<Bullet> bullet;
   
    EnemyNWayShot(String node_name, int requiredTotalFrames,
                  Enemy enemy, Player player) {
        super(node_name, requiredTotalFrames);
        this.player = player;
        this.enemy = enemy;
        this.bullet = enemy_bullets;
        this.enableRepeat = true;
    };

    @Override
    NodeStatus Action() {
      NodeStatus status;

      if (!isFinished) {
          enemy.nway_shot(bullet, player);
          isFinished = true;
      }

      status = super.Action(); 
      return status;
    }
}


class EnemyMeleeAttack extends ActionNode{
    Enemy enemy;
    Sword sword;
 
    EnemyMeleeAttack(String node_name, int requiredTotalFrames,
                     Enemy enemy, Sword sword) {
        super(node_name, requiredTotalFrames);
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

        if (this.requiredTotalFrames != 0) {
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

        if (this.requiredTotalFrames != 0) {
            this.releaseRandomNumber(); 
        }
        status = super.Action();
        return status;
    }
}

