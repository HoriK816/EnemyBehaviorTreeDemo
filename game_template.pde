static int WINDOW_HEIGHT = 1200;
static int WINDOW_WIDTH = 900;
static int FRAME_RATE = 60;

// x = 250, y = 400
// There are temporary position.
Player player = new Player(250, 400);

// x = 250, y = 100
// There are temporary position.
Enemy enemy = new Enemy(250, 100);


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
  move_bullets();   
  remove_hit_bullets();
  remove_frameout_bullets();
  player.checkHit(enemy_bullets);
  enemy.checkHit(player_bullets);

  /*---------- player turn ----------*/
  player.move();

  /*---------- enemy turn ----------*/
  enemy.takeAction();

  /*---------- draw phase ----------*/
  player.draw();
  enemy.draw();
  draw_bullets();

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
