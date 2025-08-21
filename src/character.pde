class Character {
    protected int width        = 20;
    protected int height       = 20;
    protected int hp           = 100;
    protected int maxHp        = 100; 
    protected int attackPower  = 5;                      // i don't use it, now
    protected int defencePower = 5;                      // i don't use it, now
    protected PVector position;                           // two dimensions. (x, y).

    Character (float x, float y) {
        position = new PVector(x, y);
    }

    protected void draw () {
        rect(position.x, position.y, width, height);
    }

    public void takeDamage() {
        this.hp -= 5;
    }

    public void checkHit(ArrayList<Bullet> bullets){
        Bullet bullet;
        PVector bulletPosition;
        boolean isHitX = false;
        boolean isHitY = false;
        
        for (int i=0; i<bullets.size(); i++) {
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

            if(isHitX && isHitY) {
                bullet.is_hit = true;
                takeDamage();
            }
        }
    }

    public void checkMeleeHit (Sword sword) {
        PVector swordStartPoint = sword.startPoint;
        PVector swordEndPoint   = sword.endPoint;
        
        boolean isTopCrossed    = false;
        boolean isBottomCrossed = false;
        boolean isLeftCrossed   = false;
        boolean isRightCrossed  = false;

        /* 
         * check if two lines cross over about four lines.
         */

        /* Top line  */
        PVector topLineStart = new PVector(position.x,
                                           position.y); 
        PVector topLineEnd   = new PVector(position.x + width,  
                                           position.y); 
        isTopCrossed = isCrossOverTwoLines(swordStartPoint,
                                           swordEndPoint,
                                           topLineStart,
                                           topLineEnd);

        /* Bottom line  */
        PVector bottomLineStart = new PVector(position.x,
                                              position.y + height);
        PVector bottomLineEnd   = new PVector(position.x + width,
                                              position.y + height);
        isBottomCrossed = isCrossOverTwoLines(swordStartPoint,
                                              swordEndPoint,
                                              bottomLineStart,
                                              bottomLineEnd);

        /* Left line  */ 
        PVector leftLineStart = new PVector(position.x,
                                            position.y); 
        PVector leftLineEnd   = new PVector(position.x,
                                            position.y + height); 
        isLeftCrossed = isCrossOverTwoLines(swordStartPoint,
                                            swordEndPoint,
                                            leftLineStart,
                                            leftLineEnd);

        /* Right line  */ 
        PVector rightLineStart = new PVector(position.x + width,
                                             position.y); 
        PVector rightLineEnd   = new PVector(position.x + width,
                                             position.y + height); 
        isRightCrossed = isCrossOverTwoLines(swordStartPoint,
                                             swordEndPoint,
                                             rightLineStart,
                                             rightLineEnd);

        if (isTopCrossed || isBottomCrossed
                || isLeftCrossed || isRightCrossed) {
            if (sword.isActive) {
                takeDamage();
            }
        }
    }

    boolean isCrossOverTwoLines(PVector swordStartPoint, PVector swordEndPoint,
                                PVector line_start, PVector line_end){
        float y,x; 
        float a,b; // y = ax + b
        float c,d; // y = cx + d 


        if ((swordStartPoint.x == swordEndPoint.x)
                && (line_start.x == line_end.x)) {
            if (swordStartPoint.x == line_start.x) {
                return true;
            }
            return false; 
        }

        if (line_start.x == line_end.x) {
            a = (swordStartPoint.y - swordEndPoint.y) 
                  / (swordStartPoint.x - swordEndPoint.x);
            b = swordStartPoint.y - a * swordStartPoint.x;

            x = line_start.x;
            y = a * x + b;

            if((swordStartPoint.x <= x) && (x <= swordEndPoint.x) 
                   && (line_start.x <= x) && (x <= line_end.x)
                   && (swordStartPoint.y <= y) && ( y <= swordEndPoint.y)
                   && (line_start.y <= y) && (y<= line_end.y)){
                return true;
            }else{
                return false;
            }
        }

        if (swordStartPoint.x == swordEndPoint.x) {
            c = (line_start.y - line_end.y) / (line_start.x - line_end.x);
            d = line_start.y - c * line_start.x;

            x = swordStartPoint.x;
            y = c * x + d;

            if((swordStartPoint.x <= x) && (x <= swordEndPoint.x)
                   && (line_start.x <= x) && (x <= line_end.x)
                   && (swordStartPoint.y <= y) && ( y <= swordEndPoint.y)
                   && (line_start.y <= y) && (y<= line_end.y)){
                return true;
            }else{
                return false;
            }
        }

        a = (swordStartPoint.y - swordEndPoint.y) / (swordStartPoint.x - swordEndPoint.x);
        b = swordStartPoint.y - a * swordStartPoint.x;
        c = (line_start.y - line_end.y) / (line_start.x - line_end.x);
        d = line_start.y - c * line_start.x;

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


        if (swordStartPoint.x <= swordEndPoint.x 
                && swordStartPoint.y <= swordEndPoint.y) {

            /* The sword is in first quadrant  */
            if ((swordStartPoint.x <= x) && (x <= swordEndPoint.x)
                   && (line_start.x <= x) && (x <= line_end.x)
                   && (swordStartPoint.y <= y) && ( y <= swordEndPoint.y) 
                   && (line_start.y <= y) && (y<= line_end.y)){
                return true;
            }
        }else if(swordEndPoint.x < swordStartPoint.x 
                    && swordStartPoint.y <= swordEndPoint.y){

            /* The sword is in second quadrant  */
            if((swordEndPoint.x <= x) && (x <= swordStartPoint.x)
                   && (line_start.x <= x) && (x <= line_end.x)
                   && (swordStartPoint.y <= y) && ( y <= swordEndPoint.y)
                   && (line_start.y <= y) && (y<= line_end.y)){
                 return true;
            }
        }else if(swordStartPoint.x <= swordEndPoint.x 
                    && swordEndPoint.y <= swordStartPoint.y){

            /* The sword is in third quadrant  */
            if((swordStartPoint.x <= x) && (x <= swordEndPoint.x)
                   && (line_start.x <= x) && (x <= line_end.x)
                   && (swordEndPoint.y <= y) && ( y <= swordStartPoint.y)
                   && (line_start.y <= y) && (y<= line_end.y)){
                 return true;
               }
        }else if(swordEndPoint.x < swordStartPoint.x 
                    && swordEndPoint.y < swordStartPoint.y){

            /* The sword is in forth quadrant  */ 
            if((swordEndPoint.x <= x) && (x <= swordStartPoint.x) 
                   && (line_start.x <= x) && (x <= line_end.x)
                   && (swordEndPoint.y <= y) && ( y <= swordStartPoint.y) 
                   && (line_start.y <= y) && (y<= line_end.y)){
                 return true;
               }
        }
        return false;
    }
}
