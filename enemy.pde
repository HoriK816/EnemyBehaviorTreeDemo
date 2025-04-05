class Enemy{

  int width = 20;
  int height = 25;
  color enemy_color = color(255, 255, 0); // purple 

  PVector position; // two dimensions. (x, y).
  int max_speed = 10;

  Enemy(float x, float y){
    position = new PVector(x, y);
  }

  void move(Direction direction, int speed){
    switch(direction){
      case UP:
        position.y -= speed;
        break;
      case LEFT:
        position.x -= speed;
        break;
      case RIGHT:
        position.x += speed;
        break;
      case DOWN:
        position.y += speed;
        break;
    }

  }

  void draw(){
    fill(enemy_color);
    rect(position.x, position.y, width, height);
  }

  void normal_shot(ArrayList<Bullet> bullets){
    int bullet_speed = 10;
    float direction = 0;
    Bullet bullet = new Bullet(position.x + (width/2), position.y + height,
                               bullet_speed, direction);
    bullets.add(bullet);
  }

	void aim_shot(ArrayList<Bullet> bullets, Player player){
		PVector target = player.position;
		int target_width = player.width;
		int target_height = player.height;

		float theta = atan2(target.y + target_width/2 - position.y - height,
												target.x + target_height/2 - position.x - width/2);

		Bullet bullet = new Bullet(position.x + (width/2),
															 position.y + (height),
															 5, theta-HALF_PI);
		bullets.add(bullet);
	}

}
