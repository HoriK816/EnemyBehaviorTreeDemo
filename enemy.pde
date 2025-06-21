class Enemy{

  int width = 20;
  int height = 25;
  color enemy_color = color(255, 255, 0); // purple 

  PVector position; // two dimensions. (x, y).
  int max_speed = 10;

  int hp;
  int max_hp;
  int attack_power;
  int defence_power;

  ControlNode root;

  Enemy(float x, float y){
    position = new PVector(x, y);

    hp = 100;
    max_hp = 100;
    attack_power = 5; // now, it's a dummy value.
    defence_power = 5; // now, it's a dummy value.

    // create a root node of behavior tree
    root = new SequenceNode("root");
  }

  void takeAction(){
    NodeStatus root_status = root.evalNode();

    if(root_status == NodeStatus.SUCCESS){
      this.root = new SequenceNode("root");
      createBehaviorTree();
    }else if(root_status == NodeStatus.FAILURE){
      this.root = new SequenceNode("root");
      createBehaviorTree();
    }
  }

  void createBehaviorTree(){
    RandomNumberStack r_stack = new RandomNumberStack();


    /*SelectorNode     b = new SelectorNode("b");*/
    /*InverterNode     c = new InverterNode("c");*/
    /*IsShortRange     d = new IsShortRange(300, player, enemy);*/
    /*SequenceNode     e = new SequenceNode("e");*/
    /*CloseToPlayer    f = new CloseToPlayer("close to player", 30, enemy, player);*/
    /*EnemyMeleeAttack g = new EnemyMeleeAttack("melee", 10, enemy, enemy_sword);*/
    /*c.setChild(d);*/
    /*e.addChild(f);*/
    /*e.addChild(g);*/
    /*b.addChild(c);*/
    /*b.addChild(e);*/
    /*root.addChild(b); */

    /*SelectorNode    h = new SelectorNode("h");*/
    /*IsShortRange    i = new IsShortRange(300, player, enemy);*/
    /*h.addChild(i);*/

    /*SequenceNode    j = new SequenceNode("j"); */
    /*RandomGenerator k = new RandomGenerator(r_stack);*/
    /*j.addChild(k);*/

    /*SelectorNode                l = new SelectorNode("l");   */
    /*InverterNode                m = new InverterNode("m");    */
    /*IsRandomNumberOverThreshold n = new IsRandomNumberOverThreshold(50, r_stack);*/
    /*SequenceNode                o = new SequenceNode("o");*/
    /*RandomEnemyWalk             p = new RandomEnemyWalk("p", 300, enemy);*/
    /*m.setChild(n);*/
    /*o.addChild(p);*/
    /*l.addChild(m);*/
    /*l.addChild(o);*/
    /*j.addChild(l);*/
   
    /*SelectorNode                 q = new SelectorNode("q");*/
    /*IsRandomNumberOverThreshold rs = new IsRandomNumberOverThreshold(50, r_stack);*/
    /*EnemyAttack                  t = new EnemyAttack("t", 1, enemy, player);*/
    /*q.addChild(rs);*/
    /*q.addChild(t);*/
    /*j.addChild(q);*/
    /*h.addChild(j);*/
    /*root.addChild(h);*/

    RandomGenerator u = new RandomGenerator(r_stack);
    root.addChild(u);

    SelectorNode                w = new SelectorNode("w");
    InverterNode                x = new InverterNode("x");
    IsRandomNumberOverThreshold y = new IsRandomNumberOverThreshold(90, r_stack);
    x.setChild(y);
    w.addChild(x);

    SequenceNode       z = new SequenceNode("z");
	  RepeaterNode      aa = new RepeaterNode("aa", 2);	
    SequenceNode      ab = new SequenceNode("ab");
    EnemyAllRangeShot ac = new EnemyAllRangeShot("ac", 10, enemy);
	  RepeaterNode      ad = new RepeaterNode("aa", 3);	
		EnemyNWayShot     ae = new EnemyNWayShot("enemy nway", 20, enemy, player);
    ad.setChild(ae);
    ab.addChild(ac);
    ab.addChild(ad);
    aa.setChild(ab);
    z.addChild(aa);
    w.addChild(w);
    
    

    root.addChild(w);
		
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

	void all_range_shot(ArrayList<Bullet> bullets){
			int ways = 50;
			for(float d=0; d<2*PI; d+=2*PI/ways){
					Bullet bullet = new Bullet(position.x, position.y, 5, d);
					bullets.add(bullet);
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

	void random_spread_shot(ArrayList<Bullet> bullets){
			int number_of_bullets = 5;
			for(int i =0; i < number_of_bullets; i++){

					float random_direction = random(-(HALF_PI/2), HALF_PI/2);

					Bullet bullet = new Bullet(position.x + width/2,
																		 position.y + height,
																		 5, random_direction);
					bullets.add(bullet);
			}

	}

	void nway_shot(ArrayList<Bullet> bullets, Player player){
			float ways = 5;
			float shot_degree = HALF_PI;
			PVector target = player.position;
			int target_width = player.width;
			int target_height = player.height;

			float pivot = atan2(target.y + target_width/2 - position.y - width/2,
													target.x + target_height/2 - position.x - height) 
													- HALF_PI;
 

			// pivot 
			Bullet bullet = new Bullet(position.x + width/2,
																 position.y + height,
																 5, pivot);
			bullets.add(bullet);


			// clockwise direction
			float degree = pivot; 
			for(float i=1; i<ways/2; i++){
					degree -=  shot_degree/ways;
					bullet = new Bullet(position.x + width/2,
															position.y + height,
															5, degree);
					bullets.add(bullet);
			}

			// counterclockwise direction
			degree = pivot; 
			for(float i=1; i<ways/2; i++){
					degree += shot_degree/ways;
					bullet = new Bullet(position.x + width/2,
															position.y + height,
															5, degree);
					bullets.add(bullet);
			}
	}


  void melleAttack(Sword sword){
    if(!sword.is_active)
      sword.activate();
  }

  void checkMeleeHit(Sword sword){
   PVector sword_start_point = sword.start_point;
   PVector sword_end_point   = sword.end_point;
    
    boolean is_top_crossed    = false;
    boolean is_bottom_crossed = false;
    boolean is_left_crossed   = false;
    boolean is_right_crossed  = false;

   // check if two lines cross over about four lines.
   // top line
   PVector top_line_start = new PVector(position.x, position.y); 
   PVector top_line_end   = new PVector(position.x + width, position.y); 

   is_top_crossed = isCrossOverTwoLines(sword_start_point, sword_end_point,
                                    top_line_start, top_line_end);
 

   // bottom line
   PVector bottom_line_start = new PVector(position.x, position.y + height);
   PVector bottom_line_end   = new PVector(position.x + width, position.y + height);
 
   is_bottom_crossed = isCrossOverTwoLines(sword_start_point, sword_end_point,
                                    bottom_line_start, bottom_line_end);

   // left line
   PVector left_line_start = new PVector(position.x, position.y); 
   PVector left_line_end   = new PVector(position.x, position.y + height); 

   is_left_crossed = isCrossOverTwoLines(sword_start_point, sword_end_point,
                                    left_line_start, left_line_end);

   // right line
   PVector right_line_start = new PVector(position.x + width, position.y); 
   PVector right_line_end   = new PVector(position.x + width, position.y + height); 

   is_right_crossed = isCrossOverTwoLines(sword_start_point, sword_end_point,
                                    right_line_start, right_line_end);

    if(is_top_crossed || is_bottom_crossed || is_left_crossed || is_right_crossed){
        // println("crossed");
        if(sword.is_active)
            takeDamage();

    }

  }

  // you must set sword as a line 1
  boolean isCrossOverTwoLines(PVector line1_start, PVector line1_end,
                              PVector line2_start, PVector line2_end)
  {
    if((line1_start.x == line1_end.x) && (line2_start.x == line2_end.x)){
        if(line1_start.x == line2_start.x){
            return true;
        }
        return false; 
    }

    if(line2_start.x == line2_end.x){
        float a = (line1_start.y - line1_end.y) / (line1_start.x - line1_end.x);
        float b = line1_start.y - a * line1_start.x;

        float x = line2_start.x;
        float y = a * x + b;

        if((line1_start.x <= x) && (x <= line1_end.x) && (line2_start.x <= x) && (x <= line2_end.x)
           && (line1_start.y <= y) && ( y <= line1_end.y) && (line2_start.y <= y) && (y<= line2_end.y))
        {
            return true;
        }else{
            return false;
        }
    }

    if(line1_start.x == line1_end.x){
        float c = (line2_start.y - line2_end.y) / (line2_start.x - line2_end.x);
        float d = line2_start.y - c * line2_start.x;

        float x = line1_start.x;
        float y = c * x + d;

        if((line1_start.x <= x) && (x <= line1_end.x) && (line2_start.x <= x) && (x <= line2_end.x)
           && (line1_start.y <= y) && ( y <= line1_end.y) && (line2_start.y <= y) && (y<= line2_end.y))
        {
            return true;
        }else{
            return false;
        }
    }

    float a = (line1_start.y - line1_end.y) / (line1_start.x - line1_end.x);
    float b = line1_start.y - a * line1_start.x;
    float c = (line2_start.y - line2_end.y) / (line2_start.x - line2_end.x);
    float d = line2_start.y - c * line2_start.x;

    /*println(" y=", a, "x+", b);*/
    /*println(" y=", c, "x+", d);*/
    float x=0;
    float y=0;
    if( a != c ){
        x = (d - b) / (a - c);
        y = (a * d - b * c) / (a - c);
        /*println("solved : (", x, ", ", y, ")");*/
    }else if(b == d){
        return true;
    }else{
        return false;
    }

    /*println("x range of line1 [", line1_start.x, ",", line1_end.x,"]");*/
    /*println("y range of line1 [", line1_start.y, ",", line1_end.y,"]");*/
    /*println("x range of line2 [", line2_start.x, ",", line2_end.x,"]");*/
    /*println("y range of line2 [", line2_start.y, ",", line2_end.y,"]");*/

    if(line1_start.x <= line1_end.x && line1_start.y <= line1_end.y){
    // sword, first quadrant
        if((line1_start.x <= x) && (x <= line1_end.x) && (line2_start.x <= x) && (x <= line2_end.x)
           && (line1_start.y <= y) && ( y <= line1_end.y) && (line2_start.y <= y) && (y<= line2_end.y))
           {
             return true;
           }
    }else if(line1_end.x < line1_start.x && line1_start.y <= line1_end.y){
    // sword, second quadrant
        if((line1_end.x <= x) && (x <= line1_start.x) && (line2_start.x <= x) && (x <= line2_end.x)
           && (line1_start.y <= y) && ( y <= line1_end.y) && (line2_start.y <= y) && (y<= line2_end.y))
           {
             return true;
           }
    }else if(line1_start.x <= line1_end.x && line1_end.y <= line1_start.y){
    // sword, third quadrant
        if((line1_start.x <= x) && (x <= line1_end.x) && (line2_start.x <= x) && (x <= line2_end.x)
           && (line1_end.y <= y) && ( y <= line1_start.y) && (line2_start.y <= y) && (y<= line2_end.y))
           {
             return true;
           }
    }else if(line1_end.x < line1_start.x && line1_end.y < line1_start.y){
    // sword, forth quadrant
        if((line1_end.x <= x) && (x <= line1_start.x) && (line2_start.x <= x) && (x <= line2_end.x)
           && (line1_end.y <= y) && ( y <= line1_start.y) && (line2_start.y <= y) && (y<= line2_end.y))
           {
             return true;
           }
    }

    return false;
  }
}
