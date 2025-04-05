static int WINDOW_HEIGHT = 1200;
static int WINDOW_WIDTH = 900;
static int FRAME_RATE = 60;

// x = 250, y = 400
// There are temporary position.
Player player = new Player(250, 400);

// x = 250, y = 100
// There are temporary position.
Enemy enemy = new Enemy(250, 100);

ArrayList<Bullet> enemy_bullets = new ArrayList<Bullet>();
ArrayList<Bullet> player_bullets = new ArrayList<Bullet>();

// test node for BT
// SequenceNode root = new SequenceNode("root"); 
ControlNode root = new SequenceNode("root");

boolean is_finished = false;

void setup(){
  // cannot use variables to specify the window size on size() 
  size(900,1200);
  frameRate(FRAME_RATE);

}


void draw(){
  background(0,0,0);

  /*---------- calculate phase ----------*/
  player.move();
  // enemy.move();
  move_bullets();   
  remove_bullets();

  /*---------- enemy turn ----------*/
  enemy.takeAction();


  /*---------- draw phase ----------*/
  player.draw();
  enemy.draw();
  draw_bullets();

}




class Bullet{
  
  int width = 5;
  int height = 5;
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

void remove_bullets(){
  for(int i = player_bullets.size()-1; i>=0; i--){
    if(player_bullets.get(i).is_out())
      player_bullets.remove(i);
  }

  for(int i = enemy_bullets.size()-1; i>=0; i--){
    if(enemy_bullets.get(i).is_out())
      enemy_bullets.remove(i);
  }
}


void keyPressed(){
  switch(keyCode){
    case UP:
      player.move_up = true;
      break;
    case DOWN:
      player.move_down = true;
      break;
    case LEFT:
      player.move_left = true;
      break;
    case RIGHT:
      player.move_right = true;
      break;
    case ' ': 
      player.shot(player_bullets);
  }

}

void keyReleased(){
  switch(keyCode){
    case UP:
      player.move_up = false;
      break;
    case DOWN:
      player.move_down = false;
      break;
    case LEFT:
      player.move_left = false;
      break;
    case RIGHT:
      player.move_right = false;
      break;
  }
}
