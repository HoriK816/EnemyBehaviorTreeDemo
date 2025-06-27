class Sword{
    public PVector startPoint = new PVector(0,0);   // two dimensions. (x, y)
    public PVector endPoint   = new PVector(0, 0);  // two dimensions. (x, y)
    public boolean isActive   = false;
    float rotationAngle       = 0;     // object rotation
    float redius              = 100;   // it's a length of the sword, actually. 
    float angularVelocity     = 0.2;   // the moving speed of the sword. 
    color sword_color         = color(255, 255, 255); // white
                                                      
    Sword(){}

    void rotate_sword(PVector centerPoint){
        float distanceX = redius * cos(rotationAngle);
        float distanceY = redius * sin(rotationAngle);

        // update endPoint besides the object has this sword.
        this.endPoint.x = centerPoint.x + distanceX;
        this.endPoint.y = centerPoint.y + distanceY;
    }
  
    void move(PVector charaPosition, int charaWidth, int charaHeight){
        startPoint.x = charaPosition.x + charaWidth/2; 
        startPoint.y = charaPosition.y + charaHeight/2;

        if(isActive) {
            rotate_sword(startPoint);
            rotationAngle += angularVelocity;

            if (2*3.14 < rotationAngle) {
                inactivate();
            }
        }
    }

    void draw(){
        if(isActive){
            color colorToReset = color(0,0,0); // black
                                              
            /* draw the sword */
            stroke(sword_color);
            line(startPoint.x, startPoint.y, endPoint.x, endPoint.y); 

            /*
             * In Processing, the effect of stroke is remaining. Therefore, 
             * other object also be drawn with the sword color, if you don't 
             * reset it.
             * */
            stroke(colorToReset);
        }
    }

    void activate(){
        this.isActive = true;

        // reset angle
        rotationAngle = 0;
    }

    void inactivate(){
        this.isActive = false;
    }
}
