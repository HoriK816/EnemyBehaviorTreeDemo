class Player{

  int width = 20;
  int height = 25;
  color player_color = color(0, 255, 0); // green

  PVector position; // two dimensions. (x, y).

  boolean move_left;
  boolean move_right;
  boolean move_up;
  boolean move_down;

  int moving_amount = 10;    

  int hp;
  int attack_power; 
  int defence_power;

  Player(float x, float y){
    position = new PVector(x, y);
    hp = 100;
    attack_power = 5; // now, it's a dummy value.
    defence_power = 5; // now, it's a dummy value.
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
    float direction = PI;
    Bullet bullet = new Bullet(position.x + (width/2), position.y,
                               bullet_speed, direction);
    bullets.add(bullet);
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



}
