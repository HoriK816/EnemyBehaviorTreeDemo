enum Direction{
  UP, LEFT, RIGHT, DOWN;
}

/* The class calculate the path to the destination. */
class MovePath{

  ArrayList<Direction> move_direction;
  ArrayList<Integer> move_speed;
  int number_of_movement;

  MovePath(){
    move_direction = new ArrayList<Direction>();
    move_speed     = new ArrayList<Integer>();
    number_of_movement = 0;
  }

  void addPath(Direction direction, int speed){
    this.move_direction.add(direction); 
    this.move_speed.add(speed); 
    number_of_movement++;
  }

  // for debugging
  void printAllPath(){
    println("printAllPath()");
    println("list size : ", move_direction.size());

    for(int i = 0; i<move_direction.size(); i++){

      Direction direction = move_direction.get(i);
      int speed = move_speed.get(i);

      println("(", direction, ", ", speed,")");
    }
  }
}


class RouteCalculator{

  MovePath path;

  RouteCalculator(MovePath path){
    this.path = path;
  }

  MovePath calcPath(PVector destination, PVector source, int max_speed){
    int diff_x = (int)destination.x - (int)source.x;
    path = calcHorizontalPath(diff_x, max_speed, path); 

    int diff_y = (int)destination.y - (int)source.y;
    path = calcVerticalPath(diff_y, max_speed, path);

    return path;
  }

  MovePath calcHorizontalPath(int diff_x, int max_speed, MovePath path){
    while(true){
      if(diff_x == 0){ // no need to move
        break;

      }else if(0 < diff_x){ // move to right
        if(abs(diff_x) < max_speed){ // move in one frame
          path.addPath(Direction.RIGHT, (int)abs(diff_x));
          break;

        }else{
          path.addPath(Direction.RIGHT, max_speed);
          diff_x -= max_speed;
        }

      }else{ // move to left
        if(abs(diff_x) < max_speed){ // move in one frame
          path.addPath(Direction.LEFT, (int)abs(diff_x));
          break;

        }else{
          path.addPath(Direction.LEFT, max_speed);
          diff_x += max_speed;
        }
      }
    }
    return path;
  }

  MovePath calcVerticalPath(int diff_y, int max_speed, MovePath path){
    while(true){
      if(diff_y == 0){
        break;

      }else if(0 < diff_y){ // move to down
        if((int)abs(diff_y) < max_speed){ // move in one frame
          path.addPath(Direction.DOWN, (int)abs(diff_y));
          break;

        }else{
          path.addPath(Direction.DOWN, max_speed);
          diff_y -= max_speed;
        }

      }else{ // move to up
        if((int)abs(diff_y)< max_speed){ // move in one frame
          path.addPath(Direction.UP, (int)abs(diff_y));
          break;

        }else{
          path.addPath(Direction.UP,  max_speed);
          diff_y += max_speed;
        }
      }
    }
    return path;
  }

}



