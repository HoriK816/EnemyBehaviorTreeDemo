class HPBar{

    int hp;
    int max_hp;
    PVector position;

    int width = 400; 
    int height = 50;

    color background_color = color(255, 255, 255); // black
    color hp_color = color(255, 140, 0); // dark orange

    HPBar(int hp, int max_hp, PVector position){
        this.hp = hp;
        this.max_hp = max_hp;
        this.position = position;
    }

    void draw(int hp){
        fill(background_color);   
        rect(position.x, position.y, width, height);

        int hp_length = calcHPLength();
        this.hp = hp;
        fill(hp_color);
        rect(position.x, position.y, hp_length,height); 
    }

    int calcHPLength(){
        float left_ration = (float)hp / (float)max_hp;
        return (int)(left_ration * width);
    }

}
