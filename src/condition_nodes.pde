class IsShortRange extends ConditionNode{
    Player player;
    Enemy enemy;
    int threshold;

    IsShortRange(int threshold, Player player, Enemy enemy) {
        super("is_short_ragnge");
        this.player = player;
        this.enemy = enemy;
        this.threshold = threshold;
    }

    @Override
    NodeStatus evalNode() {
        float distance;
        NodeStatus status;

        distance = calcDistance(player.position, enemy.position);
        judgeDistance(distance);
        status = super.evalNode();
        return status;
    }

   float calcDistance(PVector dest, PVector src) {
       float diff_x = dest.x - src.x;
       float diff_y = dest.y - src.y;

       float distance = pow(pow(diff_x, 2) + pow(diff_y, 2), 0.5);
       return distance;
   }

   void judgeDistance(float distance) {
      if (distance < threshold) {
          isMet = true;
      } else {
          isMet = false;
      }
   }
}

class IsRandomNumberOverThreshold extends ConditionNode{
    int threshold; 
    RandomNumberStack random_stack;

    IsRandomNumberOverThreshold(int threshold, RandomNumberStack stack){
        super("is_random_number_over_threshold"); 
        this.threshold = threshold;
        this.random_stack = stack;
    }

    void checkRandomNumber(){
        int random_number = random_stack.refferStackTop();

        if (threshold < random_number) {
            this.isMet = true;
        }else{
            this.isMet = false;
        }
    }

    @Override
    NodeStatus evalNode(){
        NodeStatus status;

        checkRandomNumber();
        status = super.evalNode();
        return status;
    }
}

class IsRandomNumberBetweenAandB extends ConditionNode {
    int min_a;
    int max_b;
    RandomNumberStack random_stack;

    IsRandomNumberBetweenAandB(int min_a, int max_b, RandomNumberStack stack) {
        super("is_random_number_over_threshold"); 
        this.min_a = min_a;
        this.max_b = max_b;
        this.random_stack = stack;
    }

    void checkRandomNumber(){
        int random_number = random_stack.refferStackTop();

        if (min_a <= random_number && random_number < max_b) {
            this.isMet = true;
        } else {
            this.isMet = false;
        }
    }

    @Override
    NodeStatus evalNode(){
        NodeStatus status;

        checkRandomNumber();
        status = super.evalNode();
        return status;
    }
}
