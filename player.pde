class Player{
    int width          = 20;
    int height         = 25;
    int hp             = 100;
    int maxHp         = 100;
    int attackPower    = 5;                   // i don't use it, now
    int defencePower   = 5;                   // i don't use it, now 
    color player_color = color(0, 255, 0);    // green
    PVector position;                         // two dimensions. (x, y).
    int moveAmmount  = 10;    
    boolean isMovingLeft  = false;
    boolean isMovingRight = false;
    boolean isMovingUp    = false; 
    boolean isMovingDown  = false;

    Player(float x, float y){
      position = new PVector(x, y);
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
  
    void draw(){
        fill(player_color);
        rect(position.x, position.y, width, height);
    }

    void shot(ArrayList<Bullet> bullets){
        int bullet_speed = 10;
        float direction  = PI;

        Bullet bullet    = new Bullet(position.x + (width/2),
                                      position.y,
                                      bullet_speed,
                                      direction);
        bullets.add(bullet);
    }

    void takeDamage(){
        this.hp -= 5;
    }

    void checkHit(ArrayList<Bullet> bullets){
        Bullet bullet;
        PVector bulletPosition;
        boolean isHitX = false;
        boolean isHitY = false;
        
        for(int i=0; i<bullets.size(); i++){
            isHitX = false;
            isHitY = false;

            bullet = bullets.get(i);
            bulletPosition =  bullet.position;

            if ((position.x < bulletPosition.x)
                    &&(bulletPosition.x < position.x + width)) {
                isHitX = true;
            }
            if ((position.y < bulletPosition.y)
                    && (bulletPosition.y < position.y + height)) {
                isHitY = true; 
            }

            if(isHitX && isHitY){
                bullet.is_hit = true;
                takeDamage();
            }
        }
    }

    void checkMeleeHit(Sword sword){
        PVector sword_start_point = sword.startPoint;
        PVector sword_end_point   = sword.endPoint;
        
        boolean is_top_crossed    = false;
        boolean is_bottom_crossed = false;
        boolean is_left_crossed   = false;
        boolean is_right_crossed  = false;

        /* check if two lines cross over about four lines. */

        // top line
        PVector top_line_start = new PVector(position.x,
                                             position.y); 
        PVector top_line_end   = new PVector(position.x + width,  
                                             position.y); 
        is_top_crossed = isCrossOverTwoLines(sword_start_point,
                                             sword_end_point,
                                             top_line_start,
                                             top_line_end);

         // bottom line
        PVector bottom_line_start = new PVector(position.x,
                                                position.y + height);
        PVector bottom_line_end   = new PVector(position.x + width,
                                                position.y + height);
        is_bottom_crossed = isCrossOverTwoLines(sword_start_point,
                                                sword_end_point,
                                                bottom_line_start,
                                                bottom_line_end);

         // left line
        PVector left_line_start = new PVector(position.x,
                                              position.y); 
        PVector left_line_end   = new PVector(position.x,
                                              position.y + height); 
        is_left_crossed = isCrossOverTwoLines(sword_start_point,
                                              sword_end_point,
                                              left_line_start,
                                              left_line_end);

         // right line
        PVector right_line_start = new PVector(position.x + width,
                                               position.y); 
        PVector right_line_end   = new PVector(position.x + width,
                                               position.y + height); 
        is_right_crossed = isCrossOverTwoLines(sword_start_point,
                                               sword_end_point,
                                               right_line_start,
                                               right_line_end);

        if(is_top_crossed || is_bottom_crossed
               || is_left_crossed || is_right_crossed){
            if(sword.isActive){
                takeDamage();
            }
        }
    }

    // NOTE: you must set sword as a line 1
    boolean isCrossOverTwoLines(PVector line1_start, PVector line1_end,
                              PVector line2_start, PVector line2_end){
        float y,x; 
        float a,b; // y = ax + b
        float c,d; // y = cx + d 


        if ((line1_start.x == line1_end.x) && (line2_start.x == line2_end.x)) {
            if (line1_start.x == line2_start.x) {
                return true;
            }
            return false; 
        }

        if (line2_start.x == line2_end.x) {
            a = (line1_start.y - line1_end.y) / (line1_start.x - line1_end.x);
            b = line1_start.y - a * line1_start.x;

            x = line2_start.x;
            y = a * x + b;

            if((line1_start.x <= x) && (x <= line1_end.x) 
                && (line2_start.x <= x) && (x <= line2_end.x)
                && (line1_start.y <= y) && ( y <= line1_end.y)
                && (line2_start.y <= y) && (y<= line2_end.y)){
                return true;
            }else{
                return false;
            }
        }

        if (line1_start.x == line1_end.x) {
            c = (line2_start.y - line2_end.y) / (line2_start.x - line2_end.x);
            d = line2_start.y - c * line2_start.x;

            x = line1_start.x;
            y = c * x + d;

            if((line1_start.x <= x) && (x <= line1_end.x)
                && (line2_start.x <= x) && (x <= line2_end.x)
                && (line1_start.y <= y) && ( y <= line1_end.y)
                && (line2_start.y <= y) && (y<= line2_end.y)){
                return true;
            }else{
                return false;
            }
        }

        a = (line1_start.y - line1_end.y) / (line1_start.x - line1_end.x);
        b = line1_start.y - a * line1_start.x;
        c = (line2_start.y - line2_end.y) / (line2_start.x - line2_end.x);
        d = line2_start.y - c * line2_start.x;

        x=0;
        y=0;
        if (a != c) {
            x = (d - b) / (a - c);
            y = (a * d - b * c) / (a - c);
        } else if (b == d) {
            return true;
        } else {
            return false;
        }


        if (line1_start.x <= line1_end.x && line1_start.y <= line1_end.y) {

            // sword is in first quadrant
            if ((line1_start.x <= x) && (x <= line1_end.x)
                   && (line2_start.x <= x) && (x <= line2_end.x)
                   && (line1_start.y <= y) && ( y <= line1_end.y) 
                   && (line2_start.y <= y) && (y<= line2_end.y)){
                return true;
            }
        }else if(line1_end.x < line1_start.x && line1_start.y <= line1_end.y){

            // sword is in second quadrant
            if((line1_end.x <= x) && (x <= line1_start.x)
                   && (line2_start.x <= x) && (x <= line2_end.x)
                   && (line1_start.y <= y) && ( y <= line1_end.y)
                   && (line2_start.y <= y) && (y<= line2_end.y)){
                 return true;
            }
        }else if(line1_start.x <= line1_end.x && line1_end.y <= line1_start.y){

            // sword is in third quadrant
            if((line1_start.x <= x) && (x <= line1_end.x)
                   && (line2_start.x <= x) && (x <= line2_end.x)
                   && (line1_end.y <= y) && ( y <= line1_start.y)
                   && (line2_start.y <= y) && (y<= line2_end.y)){
                 return true;
               }
        }else if(line1_end.x < line1_start.x && line1_end.y < line1_start.y){

            // sword is in forth quadrant
            if((line1_end.x <= x) && (x <= line1_start.x) 
                   && (line2_start.x <= x) && (x <= line2_end.x)
                   && (line1_end.y <= y) && ( y <= line1_start.y) 
                   && (line2_start.y <= y) && (y<= line2_end.y)){
                 return true;
               }
        }
        return false;
    }
  
}
