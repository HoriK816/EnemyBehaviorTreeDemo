static int WINDOW_HEIGHT = 900;
static int WINDOW_WIDTH = 1200;
static int FRAME_RATE = 60;

enum GamePhase{
    OPENING, GAME, CLEAR, GAMEOVER; 
}

enum Participant{  
    PLAYER, ENEMY, BOTH;
}

/* Player */
Player player = new Player(250, 400);    // (250, 400) is a initial position

/* Enemy */
Enemy enemy = new Enemy(250, 100);     // (250, 100) is a initial position

/* HP Bar */
PVector positionPlayerHP = new PVector(10,10);
PVector positionEnemyHP  = new PVector(600,10);
HPBar playerHpBar = new HPBar(player.hp, player.maxHp, positionPlayerHP);
HPBar enemyHpBar  = new HPBar(enemy.hp, enemy.maxHp, positionEnemyHP);

/* Melee weapon (sword) */
Sword playerSword = new Sword(); 
Sword enemySword  = new Sword();

/* Behavior Tree to decide enemy's action */
ControlNode root = new SequenceNode("root");

/* Game phase to Control Game */
GamePhase phase = GamePhase.OPENING;

void setup() {
    /* NOTE: cannot use variables to specify the window size on size()... */
    size(1200,900);
    frameRate(FRAME_RATE);
}

void draw() {
    printGameText();
    switch (phase) {
        case GAME:

            /* check if the game is finished */
            if (isEnded(player, enemy)) {
                finishGame();
            }

            updateGameObject();

            /* take action */
            player.move();
            enemy.takeAction();

            /* draw game objects */
            drawBullets();
            player.draw();
            enemy.draw();
            playerSword.draw(); 
            enemySword.draw(); 
            playerHpBar.draw(player.hp);
            enemyHpBar.draw(enemy.hp);

            break; 

        case OPENING: 
            break;

        case CLEAR:
            break;

        case GAMEOVER:
            break;
      }
}

void keyPressed() {

    /* reset game */ 
    if (phase != GamePhase.GAME) {
        /* push space key to retry */
        if(keyCode == ' '){
            phase = GamePhase.GAME;
            resetGame();
        }
    }

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
            if(!playerSword.isActive){
                playerSword.activate();
            }
    }
}

void keyReleased() {
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

void updateGameObject() {

    /* update bullets */
    moveBullets();   
    removeHitBullets();
    removeFrameoutBullets();

    /* update player */
    player.checkHit(enemy_bullets);
    player.checkMeleeHit(enemySword);

    /* update enemy */
    enemy.checkHit(player_bullets);
    enemy.checkMeleeHit(playerSword);

    /* update melee weapon(sword) */
    playerSword.move(player.position, player.width, player.height); 
    enemySword.move(enemy.position, enemy.width, enemy.height);

}

void printGameText() {
    int center_x = WINDOW_WIDTH / 2;
    int center_y = WINDOW_HEIGHT / 2;

    switch (phase) {
        case OPENING:
            background(0,0,0);
            text("push space key to retry", center_x, center_y);
            break;
        case GAME:
            background(0,0,0);
            break;
        case CLEAR:
            background(0,0,0);
            text("GAME CLEAR!!!", center_x, center_y);
            text("push space key to retry", center_x, center_y + 50);
            break;
        case GAMEOVER:
            background(0,0,0);
            text("GAME OVER!!!", center_x, center_y);
            text("push space key to retry", center_x, center_y + 50);
            break;
        
    }
}

boolean isEnded(Player player, Enemy enemy){
    boolean is_ended = false;

    if (player.hp <= 0) {
        is_ended = true;        
    }
    
    if (enemy.hp <= 0) {
        is_ended = true;
    }

    return is_ended;
}

void finishGame() {
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

Participant checkWinner(Player player, Enemy enemy) {
    if (enemy.hp <= 0 && 0 < player.hp) {
        return Participant.PLAYER;
    } else if(player.hp <= 0 && 0 < enemy.hp) {
        return Participant.ENEMY;
    } else {
        return Participant.BOTH;
    }
}

void resetGame() {
    player  = new Player(250, 400);    // (250, 400) is a initial position
    enemy   = new Enemy(250, 100);     // (250, 100) is a initial position
}
