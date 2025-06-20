class Player{

  int width  = 20;
  int height = 25;
  color player_color = color(0, 255, 0); // green

  PVector position; // two dimensions. (x, y).

  boolean move_left;
  boolean move_right;
  boolean move_up;
  boolean move_down;

  int moving_amount = 10;    

  int hp;
  int max_hp;
  int attack_power; 
  int defence_power;

  Player(float x, float y){
    position = new PVector(x, y);
    hp            = 100;
    max_hp        = 100;
    attack_power  = 5;   // now, it's a dummy value.
    defence_power = 5;   // now, it's a dummy value.
  }

  void move(){
    PVector move_vector = new PVector(0, 0);

    if(move_up && position.y > 0)
      move_vector.y = -1; 

    if(move_down && position.y < (WINDOW_HEIGHT - height))
      move_vector.y = 1; 

    if(move_left && position.x > 0)
      move_vector.x = -1;

    if(move_right && position.x < (WINDOW_WIDTH - width))
      move_vector.x = 1;
  
    move_vector.normalize();
    move_vector.mult(moving_amount);

    position.add(move_vector);
  }
  
  void draw(){
    fill(player_color);
    rect(position.x, position.y, width, height);
  }

  void shot(ArrayList<Bullet> bullets){
    int bullet_speed = 10;
    float direction  = PI;

    Bullet bullet    = new Bullet(position.x + (width/2), position.y,
                                  bullet_speed, direction);
    bullets.add(bullet);
  }

  void melee(){
     // activate a sword object

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
