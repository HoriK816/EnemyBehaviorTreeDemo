ArrayList<Bullet> enemy_bullets = new ArrayList<Bullet>();
ArrayList<Bullet> player_bullets = new ArrayList<Bullet>();

class Bullet{
  
  int width = 5;
  int height = 5;
  boolean is_hit = false;
  color bullet_color = color(255, 255, 255); // white
                                                 
  PVector position;
  PVector move_vector;

  Direction move_direction;


  Bullet(float px, float py, float speed, float angle){
    position = new PVector(px, py);
    move_vector = new PVector(0, speed);
    move_vector.rotate(angle);
  }

  void move(){
    position.add(move_vector);
  }

  void draw(){
    fill(bullet_color);
    ellipse(position.x, position.y, width, height); 
  }

  boolean is_out(){
    if(position.x < 0 || WINDOW_WIDTH < position.x)
      return true;
    
    if(position.y < 0 || WINDOW_HEIGHT < position.y)
      return true;

    return false;
  }

}


void move_bullets(){
  for(int i=0; i<player_bullets.size(); i++){
    player_bullets.get(i).move();
  }

  for(int i=0; i<enemy_bullets.size();i++){
    enemy_bullets.get(i).move();
  }
}

void draw_bullets(){
  for(int i=0; i<player_bullets.size(); i++){
    player_bullets.get(i).draw();
  }

  for(int i=0; i<enemy_bullets.size();i++){
    enemy_bullets.get(i).draw();
  }
}

void remove_frameout_bullets(){
  for(int i = player_bullets.size()-1; i>=0; i--){
    if(player_bullets.get(i).is_out())
      player_bullets.remove(i);
  }

  for(int i = enemy_bullets.size()-1; i>=0; i--){
    if(enemy_bullets.get(i).is_out())
      enemy_bullets.remove(i);
  }
}

void remove_hit_bullets(){

  for(int i = player_bullets.size()-1; i>=0; i--){
    if(player_bullets.get(i).is_hit)
      player_bullets.remove(i);
  }

  for(int i = enemy_bullets.size()-1; i>=0; i--){
    if(enemy_bullets.get(i).is_hit)
      enemy_bullets.remove(i);
  }
}

