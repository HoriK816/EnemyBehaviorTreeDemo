enum Direction {
   UP, LEFT, RIGHT, DOWN;
}


/* The class calculate the path to the destination. */
class MovePath {
    ArrayList<Direction> movingDirection = new ArrayList<Direction>();
    ArrayList<Integer>   movingSpeed     = new ArrayList<Integer>();;
    int numberOfMovement                 = 0;

    MovePath() { }

    void addPath(Direction direction, int speed) {
        this.movingDirection.add(direction); 
        this.movingSpeed.add(speed); 
        numberOfMovement++;
    }
}


class PathCalculator {
    MovePath path;

    PathCalculator(MovePath path) {
      this.path = path;
    }

    /* calculate path to eliminate gaps from source to destination */
    MovePath calcPath(PVector destination, PVector source, int maxSpeed) {
        int distX;
        int distY;

        /* add paths to eliminate gap in x direction */
        distX = (int)destination.x - (int)source.x;
        path = calcHorizontalPath(distX, maxSpeed, path); 

        /* add paths to eliminate gaps in y direction */
        distY = (int)destination.y - (int)source.y;
        path = calcVerticalPath(distY, maxSpeed, path);

        return path;
    }

    /* calculate path to eliminate gaps in x(horizontal) direction */
    MovePath calcHorizontalPath(int distX, int maxSpeed, MovePath path) {
        while (true) {

            /* no need to move */
            if (distX == 0) {
                break;

            /* move to right */ 
            } else if (0 < distX) {

                /* A character can reach the destination at one frame. */
                if (abs(distX) < maxSpeed) { 
                    path.addPath(Direction.RIGHT, (int)abs(distX));
                    break;

                /* A character has to move to destination some times. */
                } else {
                    path.addPath(Direction.RIGHT, maxSpeed);
                    distX -= maxSpeed;
                }

            /* move to left */
            } else {

                /* A character can reach the destination at one frame. */
                if (abs(distX) < maxSpeed) {
                    path.addPath(Direction.LEFT, (int)abs(distX));
                    break;

                /* A character has to move to destination some times. */
                } else {
                      path.addPath(Direction.LEFT, maxSpeed);
                      distX += maxSpeed;
                }
            }
        }
        return path;
    }

    /* calculate path to eliminate gaps in y(vertical) direction */
    MovePath calcVerticalPath(int distY, int maxSpeed, MovePath path){
        while(true){

            /* no need to move */
            if (distY == 0) {
                break;

            /* move to down */ 
            } else if(0 < distY) {

                /* A character can reach the destination at one frame. */
                if ((int)abs(distY) < maxSpeed) {
                    path.addPath(Direction.DOWN, (int)abs(distY));
                    break;

                /* A character has to move to destination some times. */
                } else {
                    path.addPath(Direction.DOWN, maxSpeed);
                    distY -= maxSpeed;
                }

            /* move to up */ 
            } else { 

                /* A character can reach the destination at one frame. */
                if ((int)abs(distY)< maxSpeed) {
                    path.addPath(Direction.UP, (int)abs(distY));
                    break;

                /* A character has to move to destination some times. */
                } else {
                    path.addPath(Direction.UP,  maxSpeed);
                    distY += maxSpeed;
                }
            }
        }
        return path;
    }
}
