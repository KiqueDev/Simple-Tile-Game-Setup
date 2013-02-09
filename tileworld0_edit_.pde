int min_x = 0;
int min_y = 0;
int max_x = 400;
int max_y = 600;
int grid_size = 10;
int numItems =5;

char[][] occ_grid;
ArrayList trackX;
ArrayList trackY;

PVector agent;
PVector[] obstacles;
PVector[] holes;
PVector[] tiles;

// agent state variables
int STOPPED = 0;
int RUNNING = 1;
int agentState = STOPPED;

int x=0;

/**
 * setup()
 * this function is called once, when the sketch starts up.
 */
void setup() {
  trackX = new ArrayList();
  trackY = new ArrayList();
  
  occ_grid = new char[max_x][max_y];
  agent = getRandomLoc();
  
  obstacles = new PVector[numItems];
  holes = new PVector[numItems];
  tiles = new PVector[numItems];
  
  for(int i=0; i < numItems; i ++){
    obstacles[i]= getRandomLoc();
    holes[i] = getRandomLoc();
    tiles[i] = getRandomLoc();
  }
  
  size( max_x, max_y );
  ellipseMode( CORNER );
  agentState = RUNNING;
  
  for(int i=0; i< max_y/10; i++){
    for(int j=0; j <max_x/10; j++){
      while(x<numItems){
        if(obstacles[x].x == (j*10) && obstacles[x].y == (i*10)){
          occ_grid[i][j]='o';
        }else if(holes[x].x == (j*10) && holes[x].y == (i*10)){
          occ_grid[i][j]='h';
        }else if(tiles[x].x == (j*10) && tiles[x].y == (i*10)){
          occ_grid[i][j]='t';
        }else
          occ_grid[i][j]='-';
        x++;
      }
    }
  }
  

  for(int i=0; i< max_y/10; i++){
    for(int j=0; j <max_x/10; j++){
      print(occ_grid[i][j]);
    }
    println();
  }
} // end of setup()



/**
 * draw()
 * this function is called by the Processing "draw" loop,
 * i.e., every time the display window refreshes.
 */
void draw() {
  // draw grid for TileWorld
  background( #ffffff );
  stroke( #cccccc );
  for ( int x=min_x; x<=max_x; x+=grid_size ) {
    line( x,min_y,x,max_y );
  }
  for ( int y=min_y; y<=max_y; y+=grid_size ) {
    line( min_x,y,max_x,y );
  }
  

  for(int i=0; i < numItems; i++){
    // draw obstacle(Gray)
    stroke( #cccccc );
    fill( #cccccc );
    rect( obstacles[i].x, obstacles[i].y, grid_size, grid_size );
    
    // draw hole(Black)
    stroke( #cccccc );
    fill( #000000 );
    rect( holes[i].x, holes[i].y, grid_size, grid_size );
    
    // draw tile(Pink)
    stroke( #cccccc );
    fill( #cc00cc );
    rect( tiles[i].x, tiles[i].y, grid_size, grid_size );
  }
  
  noFill();
 
  
  // draw agent
  if ( agentState == RUNNING ) {
    makeRandomMove();
  }
  stroke( #0000ff );
  fill( #0000ff );
  ellipse( agent.x, agent.y, grid_size, grid_size );
  
} // end of draw()

/**
 * mouseClicked()
 * this function responds to "mouse click" events.
 */
void mouseClicked() {
  if ( agentState == STOPPED ) {
    agentState = RUNNING;
  }
  else {
    agentState = STOPPED;
  }
} // end of mouseClicked()


/**
 * getRandomLoc()
 * this function returns a new PVector set to a random discrete location
 * in the grid.
 */
PVector getRandomLoc(){
  PVector v = new PVector( ((int)random(min_x,max_x)/grid_size)*grid_size,
  ((int)random(min_y,max_y)/grid_size)*grid_size );
  //Check if already in Arraylist to see  if used
  trackX.add(v.x);
  trackY.add(v.y);
  
  while(trackX.indexOf(v.x) != -1 && trackY.indexOf(v.y) != -1){
    v = new PVector( ((int)random(min_x,max_x)/grid_size)*grid_size,
      ((int)random(min_y,max_y)/grid_size)*grid_size );
  }
  
  trackX.add(v.x);
  trackY.add(v.y);

  
  return( v );
  
} // end of getRandomLoc()


/**
 * makeRandomMove()
 * this function causes the agent to move randomly (north, south, east or west).
 * if the agent reaches the edge of its world, it wraps around.
 */
void makeRandomMove() {
  int direction = (int)random( 0,3 );
  switch( direction ) {
  case 0: // north
    agent.y -= grid_size;
    if ( agent.y < min_y ) {
      agent.y = max_y - grid_size;
    }
    break;
  case 1: // west
    agent.x -= grid_size;
    if ( agent.x < min_x ) {
      agent.x = max_x - grid_size;
    }
    break;
  case 2: // south
    agent.y += grid_size;
    if ( agent.y > max_y ) {
      agent.y = min_y;
    }
    break;
  case 3: // east
    agent.x += grid_size;
    if ( agent.x > max_x ) {
      agent.x = min_x;
    }
    break;
  } // end of switch
} // end of makeRandomMove()

