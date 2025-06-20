class IsShortRange extends ConditionNode{
  Player player;
  Enemy enemy;
  int threshold;

  IsShortRange(int threshold, Player player, Enemy enemy){
    super("is_short_ragnge");
    this.player = player;
    this.enemy = enemy;
    this.threshold = threshold;
  }

  @Override
  NodeStatus evalNode(){
    float distance = calcDistance(player.position, enemy.position);
    judgeDistance(distance);
    // dumpResult(distance);
    NodeStatus status = super.evalNode();
    return status;
  }

 float calcDistance(PVector dest, PVector src){
   float diff_x = dest.x - src.x;
   float diff_y = dest.y - src.y;

   float distance = pow(pow(diff_x, 2) + pow(diff_y, 2), 0.5);
   /*println("distance" , distance);*/
   return distance;
 }

 void judgeDistance(float distance){
    if(distance < threshold)
      is_met = true;
    else
      is_met = false;
 }

  // for debugging
 void dumpResult(float distance){
   if(this.is_met){
     println("It's short range. distance : ", distance);
   }else{
     println("It's not short range. distance :  ", distance);
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

