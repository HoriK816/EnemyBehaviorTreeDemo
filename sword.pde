class Sword{

  public PVector start_point; // two dimensions. (x, y)
  public PVector end_point;   // two dimensions. (x, y)
  
  // object rotation
  float rotation_angle;
  float redius; 
  float angular_velocity;

  color sword_color;

  boolean is_active;


  Sword(){
    // these are tentative values
    redius = 100;

    start_point = new PVector(0,0);
    end_point = new PVector(0, 0);

    sword_color = color(255, 255, 255); // white
    // it's a test value. is_active must be false at the start.
    is_active = false;

    angular_velocity = 0.2;

  }

  void rotate_sword(PVector center_point){
    float distance_x = redius * cos(rotation_angle);
    float distance_y = redius * sin(rotation_angle);

    // update end_point besides the object has this sword.
    this.end_point.x = center_point.x + distance_x;
    this.end_point.y = center_point.y + distance_y;
  }
  
  void move(PVector character_position, int character_width, int character_height){
    start_point.x = character_position.x + character_width/2; 
    start_point.y = character_position.y + character_height/2;

    if(is_active){
        rotate_sword(start_point);
        rotation_angle += angular_velocity;

        if(2*3.14 < rotation_angle){
            inactivate();
        }
    }

  }

  void draw(){
    if(is_active){
        stroke(sword_color);
        line(start_point.x, start_point.y, end_point.x, end_point.y); 
        
        color reset_color = color(0,0,0); // black
        stroke(reset_color);
    }
  }

  void activate(){
    // reset angle
    rotation_angle = 0;

    this.is_active = true;
  }

  void inactivate(){
    this.is_active = false;
  }
}
