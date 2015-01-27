//NOTES
//Add a mechanic where after X blocks, push all blocks up 1

//Predefined Values
float blockSize = 40.0;
float testBlockIndicator = (blockSize/10)*2;
float gameBoardWidth = blockSize*8;
float screenSizeX = 1024;
float screenSizeY = 680;
float screenCenterX = screenSizeX/2;
float screenCenterY = screenSizeY/2;
int cols = 8;
int rows = 17;
float xPositions[] = new float[cols];
float yPositions[] = new float[rows];
color orange, darkBlue, green, yellow, red, pink, blue, grey;
Blick blickGrid[][] = new Blick[cols][rows];
ArrayList<Block> activeBlocks;
ArrayList<PointMessage> pointMessages;
boolean[] keys = new boolean[526];
int startingLines = 2;
float gameTime = 0;
float gameTimeBuffer = 0;
Points points = new Points();
float score = 0;
float test = 0;

//Timers
float activeBlockDrop = 0;
boolean activeBlockDrop_flag = false;
float normalDropSpeed = 0.25;
float blockDropSpeed = normalDropSpeed;
float fastDropSpeed = 0;
float dropNext = 0;
float dropNextDelay = 500;
float blockDown = 0;
boolean blockDown_flag = false;
boolean dropNext_flag = false;

//Misc flags
boolean blockInPlay = false;
boolean gameOver = false;
boolean paused = false;
boolean finishedRemovingBlocks = true;

//DEBUG FLAGS
boolean DEBUG_showOccupiedIndicators = false;
boolean DEBUG_showConnectedBlocks = false;
boolean DEBUG_showNumberGrid = false;
boolean DEBUG_foundL = false;



void setup()
{
   size( 1024, 680 );
   frameRate(60);
   noStroke();
   setupBlicks();
   setupColors();
   setupPositions();
   activeBlocks = new ArrayList<Block>();
   pointMessages= new ArrayList<PointMessage>();
   randomizeStart();
   removeFinishedShapes();//Run once at start to remove finished shapes if they appear
}

void draw()
{
  if( !gameOver )
  {
    if( !paused )
    {
      background(225);
      timeDropNext();
      drawGameBoard();
      drawFallIndicator();
      drawBlocks();
      drawPointMessages();
      removeFinishedShapes();
      if(DEBUG_showOccupiedIndicators)
      {
        drawOccupiedIndicators();
      }
      gameTime = millis();
      drawClock();
      drawDebugConsole();
      updateTimers();
    }
    else
    {
      drawPauseMessage();
    }
  }
  else
  {
    background(225);
    drawGameOverScreen();
  }
}

void drawOccupiedIndicators()
{
  for( int i = 0; i < cols; i++ )
  {
    for( int j = 0; j < rows; j++ )
    {
      rectMode(CENTER);
      fill(0, 0, 0, 77);
      if( blickGrid[i][j].isOccupied)
      {
        rect(xPositions[i], yPositions[j], blockSize/2.5, blockSize/2.5);
      }
    }
  }
}

void drawPointMessages()
{
  if( !pointMessages.isEmpty() )
  {
    for( int i = 0; i < pointMessages.size(); i++ )
    {
      PointMessage msg = pointMessages.get(i);
      msg.draw();
    }
  }
}

void drawGameBoard()
{
  fill(0);
  stroke(190);
  line( (screenCenterX - (gameBoardWidth/2)), 0,
  (screenCenterX - (gameBoardWidth/2)), screenSizeY);
  line( (screenCenterX + (gameBoardWidth/2)), 0,
  (screenCenterX + (gameBoardWidth/2)), screenSizeY);
}
