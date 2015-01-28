//***************************************
//Bryan - Change this flag to true to let game run on arcade machine
boolean arcadeControls = false;
//***************************************

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
ArrayList<Block> helpScreenBlocks;
boolean[] keys = new boolean[526];
int startingLines = 2;
float gameTime = 0;
float gameTimeBuffer = 0;
Points points = new Points();
float score = 0;
float test = 0;

//Misc flags
boolean blockInPlay = false;
boolean gameOver = false;
boolean paused = false;
boolean inGame = false;
boolean titleScreen = true;
boolean helpScreen = false;
boolean finishedRemovingBlocks = true;

//DEBUG FLAGS
boolean DEBUG_showDebugConsole = false;
boolean DEBUG_showOccupiedIndicators = false;
boolean DEBUG_showConnectedBlocks = false;
boolean DEBUG_showNumberGrid = false;

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

//Controllers
char up;
char down;
char left;
char right;
char start;
char button1;
char button2;


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
   helpScreenBlocks = new ArrayList<Block>();
   helpScreenBlocks = setupHelpScreenShapes();
   randomizeStart();
   removeFinishedShapes();//Run once at start to remove finished shapes if they appear in starting pile
}

void draw()
{
  if( !gameOver )
  {
    if( inGame )
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
        //drawClock(); /*Had problem with clock, prioritizing on completing game first*/
        if( DEBUG_showDebugConsole )
        {
          drawDebugConsole();
        }
        fill(0);
        textSize( 20 );
        text( "Score - " + str(int(score)), (width/5), height/2 );
        updateTimers();
      }
      else
      {
        drawPauseMessage();
      }
    }
    else if( titleScreen )
    {
      background(225);
      drawTitleScreen();
    }
    else if( helpScreen )
    {
      background(225);
      drawHelpScreen();
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

void drawTitleScreen()
{
  String title = "BlockBlick";
  String msg = "PRESS START";
  String msg1 = "Help - Button 1";
  if( !arcadeControls ) 
  {
    msg = "PRESS SPACE";
    msg1 = "Help - H ";
  }
  
  textSize( 100 );
  textAlign( CENTER, CENTER );
  fill( 0 );
  text( title, width/2, height/3 );
  textSize( 45 );
  text( msg, width/2, ((height/3)*2) );
  textSize( 25 );
  fill( 0 );
  text( msg1, ((width/9)*8), (height-45) );
  
}

void drawHelpScreen()
{
  String s1 = "BlockBlick is like Tetris, reversed.";
  String s2 = "While in Tetris the objective is to use certain falling shapes to fill a line of blocks..";
  String s3 = "..in BlockBlick the objective is to use singular falling blocks to create the shapes of classic Tetris blocks";
  String s4 = "Block Shapes";
  String s5 = "Space to return";
  if( arcadeControls )
  {
    s5 = "Button1 to return";
  }
  int textS = 18;
  textSize(textS);
  textAlign( CENTER, CENTER);
  fill(0);
  text( s1, width/2, (textS+3) );
  text( s2, width/2, ((textS+3)*2) );
  text( s3, width/2, ((textS+3)*3) );
  textSize(20);
  text( s4, width/2, height/6 );
  fill(0);
  stroke(190);
  line( (screenCenterX - 100), ((height/6) + 25 ),
  (screenCenterX + 100), ((height/6) + 25 ));
  for( int i = 0; i < helpScreenBlocks.size(); i++ )
  {
    helpScreenBlocks.get(i).draw();
  }
  line( (screenCenterX - 100), ((height/8)*6),
  (screenCenterX + 100), ((height/8)*6) );
  fill(0);
  text( s5, width/2, (height/8)*7 );
  
}

ArrayList<Block> setupHelpScreenShapes()
{
  //Set up shapes for instructions screen
  ArrayList<Block> shapes = new ArrayList<Block>();
  int shapeX = width/4;
  int shapeY = height/4;
  int blockType;
  //O block
  blockType = 4;
  shapes.add( new Block( int((shapeX + (blockSize/2))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX - (blockSize/2))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX + (blockSize/2))), int((shapeY+(blockSize))), blockType, true ) );
  shapes.add( new Block( int((shapeX - (blockSize/2))), int((shapeY+(blockSize))), blockType, true ) );
  //T block
  shapeX = width/2;
  blockType = 6;
  shapes.add( new Block( int(shapeX - blockSize), shapeY, blockType, true ) );
  shapes.add( new Block( shapeX, shapeY, blockType, true ) );
  shapes.add( new Block( int(shapeX + blockSize), shapeY, blockType, true ) );
  shapes.add( new Block( shapeX, int(shapeY + blockSize), blockType, true ) );
  //I block
  shapeX = (width/4)*3;
  blockType = 3;
  shapes.add( new Block( int((shapeX - ((blockSize/2)*3))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX - (blockSize/2))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX + (blockSize/2))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX + ((blockSize/2)*3))), shapeY, blockType, true ) );
  //Next line
  //S block
  shapeX = width/4;
  shapeY += (blockSize*3);
  blockType = 1;
  shapes.add( new Block( int((shapeX + ((blockSize/2)*3))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX + (blockSize/2))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX + (blockSize/2))), int((shapeY+(blockSize))), blockType, true ) );
  shapes.add( new Block( int((shapeX - (blockSize/2))), int((shapeY+(blockSize))), blockType, true ) );
  //J block
  shapeX = width/2;
  blockType = 0;
  shapes.add( new Block( int(shapeX - blockSize), int(shapeY + blockSize), blockType, true ) );
  shapes.add( new Block( shapeX, int(shapeY + blockSize), blockType, true ) );
  shapes.add( new Block( int(shapeX + blockSize), int(shapeY + blockSize), blockType, true ) );
  shapes.add( new Block( int(shapeX - blockSize), shapeY, blockType, true ) );
  //Z block
  shapeX = (width/4*3);
  blockType = 5;
  shapes.add( new Block( int((shapeX - ((blockSize/2)*3))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX - (blockSize/2))), shapeY, blockType, true ) );
  shapes.add( new Block( int((shapeX - (blockSize/2))), int((shapeY+(blockSize))), blockType, true ) );
  shapes.add( new Block( int((shapeX + (blockSize/2))), int((shapeY+(blockSize))), blockType, true ) );
  //Next line
  //L block
  shapeX = width/2;
  shapeY += (blockSize*3);
  blockType = 2;
  shapes.add( new Block( int(shapeX - blockSize), shapeY, blockType, true ) );
  shapes.add( new Block( shapeX, shapeY, blockType, true ) );
  shapes.add( new Block( int(shapeX + blockSize), shapeY, blockType, true ) );
  shapes.add( new Block( int(shapeX - blockSize), int(shapeY + blockSize), blockType, true ) );
  
  
  return shapes;
}

void setupKeyBindings()
{
  //Load keybinds from XML file for arcade machine
  XML xml = loadXML("arcade.xml");
  XML[] children = xml.getChildren("player");
  up = buttonNameToKey( xml, "up" );
  down = buttonNameToKey( xml, "down" );
  left = buttonNameToKey( xml, "left" );
  right = buttonNameToKey( xml, "right" );
  start = buttonNameToKey( xml, "start" );
  button1 = buttonNameToKey ( xml, "button1");
  button2 = buttonNameToKey( xml, "button2" );
}
