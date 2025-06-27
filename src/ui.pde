class HPBar {
    int hp;
    int maxHp;
    int width  = 400;      // the width of hp box  
    int height = 50;       // the height of hp box
    PVector position;
    color hpColor         = color(255, 140, 0);        // dark orange
    color backgroundColor = color(255, 255, 255);      // black

    HPBar(int hp, int maxHp, PVector position) {
        this.hp       = hp;
        this.maxHp    = maxHp;
        this.position = position;
    }

    void draw(int hp) {
        int hpLength;

        /* draw the frame of hp box */
        fill(backgroundColor);   
        rect(position.x, position.y, width, height);

        /* paint hp color depend on the given hp value */
        hpLength = calcHPLength();
        fill(hpColor);
        rect(position.x, position.y, hpLength, height); 

        /* update hp*/
        this.hp = hp;
    }

    int calcHPLength() {
        float  leftRatio = (float)hp / (float)maxHp;
        int    hpLength  = (int)(leftRatio * width);
        return hpLength;
    }
}
