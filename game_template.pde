static int WINDOW_HEIGHT = 900;
static int WINDOW_WIDTH = 1200;
static int FRAME_RATE = 60;

// x = 250, y = 400
// There are temporary position.
Player player = new Player(250, 400);

// x = 250, y = 100
// There are temporary position.
Enemy enemy = new Enemy(250, 100);

PVector player_hp_bar_position = new PVector(10,10);
PVector enemy_hp_bar_position = new PVector(600,10);

// FIXME: don't access to class variables directly!
HPBar player_hp_bar = new HPBar(player.hp, player.maxHp, player_hp_bar_position);
HPBar enemy_hp_bar  = new HPBar(enemy.hp, enemy.maxHp, enemy_hp_bar_position);

// melee weapon
// FIXME: I don't want to definition them. Originally, the player object 
// or the enemy object generates them when they are going to attack.
Sword player_sword = new Sword(); 
Sword enemy_sword  = new Sword();

enum GamePhase{
    OPENING, GAME, CLEAR, GAMEOVER; 
}

enum Participant{  
    PLAYER, ENEMY, BOTH;
}


GamePhase phase = GamePhase.OPENING;

boolean pressedAnyKey = false;

// test node for BT
// SequenceNode root = new SequenceNode("root"); 
ControlNode root = new SequenceNode("root");

boolean is_finished = false;

void setup(){
  // cannot use variables to specify the window size on size() 
  size(1200,900);
  frameRate(FRAME_RATE);

}

void draw(){

  int center_x = WINDOW_WIDTH / 2;
  int center_y = WINDOW_HEIGHT / 2;

  switch(phase){
      case OPENING: 
        background(0,0,0);
        text("PRESS ANY KEY!!!", center_x, center_y);

        if(pressedAnyKey)
            phase = GamePhase.GAME;

        break;

      case GAME:

        background(0,0,0);

        /*---------- finish decision ----------*/
        if(isEnded(player, enemy)){
            Participant winner = checkWinner(player, enemy);
            
            switch(winner){
                case PLAYER:
                    phase = GamePhase.CLEAR;  
                    break;
                case ENEMY:
                    phase = GamePhase.GAMEOVER;
                    break;
                case BOTH:
                    phase = GamePhase.CLEAR;
                    break;
            }

        }

        /*---------- calculate phase ----------*/
        move_bullets();   
        remove_hit_bullets();
        remove_frameout_bullets();
        player.checkHit(enemy_bullets);
        player.checkMeleeHit(enemy_sword);
        enemy.checkHit(player_bullets);
        enemy.checkMeleeHit(player_sword);
        player_sword.move(player.position, player.width, player.height); 
        enemy_sword.move(enemy.position, enemy.width, enemy.height);

        /*---------- UI  ----------*/
        player_hp_bar.draw(player.hp);
        enemy_hp_bar.draw(enemy.hp);


        /*---------- player turn ----------*/
        player.move();

        /*---------- enemy turn ----------*/
        enemy.takeAction();

        /*---------- draw phase ----------*/
        player.draw();
        enemy.draw();
        draw_bullets();
        player_sword.draw(); 
        enemy_sword.draw(); 

        break; 

      case CLEAR:
        background(0,0,0);
        text("GAME CLEAR!!!", center_x, center_y);
        break;

      case GAMEOVER:
        background(0,0,0);
        text("GAME OVER!!!", center_x, center_y);
        break;

    }

}

void keyPressed(){
  pressedAnyKey = true;

  switch(keyCode){
    case UP:
      player.isMovingUp = true;
      break;
    case DOWN:
      player.isMovingDown = true;
      break;
    case LEFT:
      player.isMovingLeft = true;
      break;
    case RIGHT:
      player.isMovingRight = true;
      break;
    case 'Z': 
      player.shot(player_bullets);
      break;
    case 'X':
      if(!player_sword.isActive){
        player_sword.activate();
      }
  }
}

void keyReleased(){
  pressedAnyKey = false;

  switch(keyCode){
    case UP:
      player.isMovingUp    = false;
      break;
    case DOWN:
      player.isMovingDown  = false;
      break;
    case LEFT:
      player.isMovingLeft  = false;
      break;
    case RIGHT:
      player.isMovingRight = false;
      break;
  }
}

boolean isEnded(Player player, Enemy enemy){
    
    boolean is_ended = false;

    if(player.hp <= 0)
        is_ended = true;        
    
    if(enemy.hp <= 0)
        is_ended = true;

    return is_ended;
}

Participant checkWinner(Player player, Enemy enemy){

    if(enemy.hp <= 0 && 0 < player.hp){
        return Participant.PLAYER;
    }else if(player.hp <= 0 && 0 < enemy.hp){
        return Participant.ENEMY;
    }else{
        return Participant.BOTH;
    }

}
