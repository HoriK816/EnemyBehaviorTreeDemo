class Player extends Character{
    color   player_color  = color(0, 255, 0);    // green
    int     moveAmmount   = 10;    
    boolean isMovingLeft  = false;
    boolean isMovingRight = false;
    boolean isMovingUp    = false; 
    boolean isMovingDown  = false;

    Player(float x, float y){
      super(x, y);
    }

    void move() {
        PVector moveingVector = new PVector(0, 0);

        if (isMovingUp && position.y > 0) {
            moveingVector.y = -1; 
        }

        if (isMovingDown && position.y < (WINDOW_HEIGHT - height)) {
            moveingVector.y = 1; 
        }

        if (isMovingLeft && position.x > 0) {
            moveingVector.x = -1;
        }

        if (isMovingRight && position.x < (WINDOW_WIDTH - width)) {
            moveingVector.x = 1;
        }
      
        moveingVector.normalize();
        moveingVector.mult(moveAmmount);

        position.add(moveingVector);
    }
  
    @Override
    public void draw(){
        fill(player_color);
        super.draw();
    }

    public void shot(ArrayList<Bullet> bullets){
        int bullet_speed = 10;
        float direction  = PI;

        Bullet bullet    = new Bullet(position.x + (width/2),
                                      position.y,
                                      bullet_speed,
                                      direction);
        bullets.add(bullet);
    }
}
