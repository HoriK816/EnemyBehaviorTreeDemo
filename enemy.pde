class Enemy{

  int width = 20;
  int height = 25;
  color enemy_color = color(255, 255, 0); // purple 

  PVector position; // two dimensions. (x, y).
  int max_speed = 10;

  int hp;
  int attack_power;
  int defence_power;

  ControlNode root;

  Enemy(float x, float y){
    position = new PVector(x, y);

    hp = 100;
    attack_power = 5; // now, it's a dummy value.
    defence_power = 5; // now, it's a dummy value.

    // create a root node of behavior tree
    root = new SequenceNode("root");
  }

  void takeAction(){
    if(!(root.evalNode() == NodeStatus.RUNNING)){
      root = new SequenceNode("root");
      createBehaviorTree();
    }
  }

  void createBehaviorTree(){
    SequenceNode mover = new SequenceNode("Mover");
    root.addChild(mover);

    EnemyWalk enemy_walk1 = new EnemyWalk("let enemy walk", 100, enemy);
    EnemyWalk enemy_walk2 = new EnemyWalk("let enemy walk", 15, enemy);
    EnemyWalk enemy_walk3 = new EnemyWalk("let enemy walk", 15, enemy);
    EnemyAttack enemy_attack1 = new EnemyAttack("attack player", 15,
                                               enemy, player);
    EnemyAttack enemy_attack2 = new EnemyAttack("attack player", 15,
                                               enemy, player);
    EnemyAttack enemy_attack3 = new EnemyAttack("attack player", 10,
                                               enemy, player);
    EnemyAttack enemy_attack4 = new EnemyAttack("attack player", 10,
                                               enemy, player);
    mover.addChild(enemy_walk1);
    mover.addChild(enemy_attack1);
    mover.addChild(enemy_attack2);
    mover.addChild(enemy_walk2);
    mover.addChild(enemy_attack3);
    mover.addChild(enemy_walk3);
    mover.addChild(enemy_attack4);
  }

  void move(Direction direction, int speed){
    switch(direction){
      case UP:
        position.y -= speed;
        break;
      case LEFT:
        position.x -= speed;
        break;
      case RIGHT:
        position.x += speed;
        break;
      case DOWN:
        position.y += speed;
        break;
    }

  }

  void draw(){
    fill(enemy_color);
    rect(position.x, position.y, width, height);
  }

  void takeDamage(){
    this.hp -= 5;
    println("hp : ", this.hp);
  }
    
  void checkHit(ArrayList<Bullet> bullets){
    
    for(int i=0; i<bullets.size(); i++){

      boolean is_hit_x = false;
      boolean is_hit_y = false;

      Bullet bullet = bullets.get(i);
      PVector bullet_position =  bullet.position;

      if((position.x < bullet_position.x) &&
         (bullet_position.x < position.x + width)){
          is_hit_x = true;
      }
      if((position.y < bullet_position.y) && 
         (bullet_position.y < position.y + height)){
          is_hit_y = true; 
      }

      if(is_hit_x && is_hit_y){
          bullet.is_hit = true;
          takeDamage();
      }
    }
  }


  void normal_shot(ArrayList<Bullet> bullets){
    int bullet_speed = 10;
    float direction = 0;
    Bullet bullet = new Bullet(position.x + (width/2), position.y + height,
                               bullet_speed, direction);
    bullets.add(bullet);
  }

	void aim_shot(ArrayList<Bullet> bullets, Player player){
		PVector target = player.position;
		int target_width = player.width;
		int target_height = player.height;

		float theta = atan2(target.y + target_width/2 - position.y - height,
							target.x + target_height/2 - position.x - width/2);

		Bullet bullet = new Bullet(position.x + (width/2),
								   position.y + (height),
								   5, theta-HALF_PI);
		bullets.add(bullet);
	}

}
