void clearBoard()
{
  blockInPlay = false;
  activeBlocks.clear();
  for( int i = 0; i < cols; i++ )
  {
    for( int j = 0; j < rows; j++ )
    {
      blickGrid[i][j].isOccupied = false;
      blickGrid[i][j].isSettled = false;
    }
  } 
}

void randomizeStart()
{
  //Blocks have 50% less chance to be next to the same colour
  //than new colours
  int i, j;
  boolean newChain = true;
  
  for( i = 0; i < startingLines; i++)
  {
    for( j = 0; j < 8; j++)
    {
      if( newChain == false )
      {
        //if starting new block placement without consideration of
        //previous block colours
        activeBlocks.add(new Block(j, i));
        blickGrid[j][i].isSettled = true;
        blickGrid[j][i].isOccupied = true;
      }
      else
      {
        Block temp;
        int previousType = 0;
        int newType;
        for( int k = 0; k < activeBlocks.size(); k++ )
        {
          temp = activeBlocks.get(k);
          if( temp.xPos == (j-1) && temp.yPos == i )
          {
            previousType = temp.type;
            break;
          }
        }
        newType = int(random(7));
        if( previousType == newType )
        {
          newType = weightedColourChoice( previousType );
        }
        activeBlocks.add( new Block( j, i, newType ) );
        blickGrid[j][i].isSettled = true;
        blickGrid[j][i].isOccupied = true;
      }
    }
  }
  removeFinishedShapes();
}

int weightedColourChoice( int previousType )
{
  int[] colours = new int[] { 0, 1, 2, 3, 4, 5, 6, 7 };
  int[] chance = new int[] { 10, 10, 10, 10, 10, 10, 10 };
  chance[previousType] -= 5;
  int choose;
  int total = 0;
  for( int i = 0; i < chance.length; i++ )
  {
    total += chance[i];
  }
  
  choose = int(random(total))+1;
  int type = 0;
  int holder = 0;
  for( int i = 0; i < chance.length; i++ )
  {
    holder += chance[i];
    if( choose <= holder )
    {
      type = colours[i];
      break;
    }
  }
  return type;
}

void dropBlock()
{
  int x, y;
  x = 0;
  y = rows-1;
  
  boolean spawnPointEmpty = false;
  boolean spawnPointExists = false;
  
  //Check if there are any places the spawn, if not, the game ends
  while( spawnPointExists == false )
  {
    for( int i = 0; i < cols; i++ )
    {
      if( blickGrid[i][rows-1].isOccupied == false )
      {
        spawnPointExists = true;
      }
    }
    if( spawnPointExists == false )
    {
      gameOver = true;
      return;
    }
  }
  //Check if block spawning point is empty, find a new point if not.
  while( spawnPointEmpty == false )
  {
    x = int(random(8));
    if( blickGrid[x][y].isOccupied == false )
    {
      spawnPointEmpty = true;
    }
  }
  
  activeBlocks.add(new Block(x, y));
  blockInPlay = true;
  for( int i = (activeBlocks.size()-1); i >= 0; i--)
  {
    Block block = activeBlocks.get(i);
    if( block.xPos == x && block.yPos == y )
    {
      block.inPlay = true;
    }
  }
  activeBlockDrop_flag = false;
  activeBlockDrop = millis();
  blocksSinceLastPush++;
}

void blockFall( int x, int y )
{
  for( int i = (activeBlocks.size()-1); i >= 0; i--)
  {
    Block block = activeBlocks.get(i);
    if( block.xPos == x && block.yPos == y )
    {
      blickGrid[x][y].isOccupied = false;
      block.yPos--;
      blickGrid[x][y-1].isOccupied = true;
    }
  }
}

void drawBlocks()
{
  if( !activeBlocks.isEmpty() )
  {
    if( activeBlocks.size() > 1 && blockInPlay == false )
    {
      bubbleSortBlocks(1);
    }
    for( int i = (activeBlocks.size()-1); i >= 0; i-- )
    {
      Block block = activeBlocks.get(i);
      block.update();
      block.draw();
    }
  }
}

void drawClock()
{
  textSize(24);
  fill(0);
  
  String minutes = "0";
  String divider = ":";
  String seconds = "0";
  String clock = "";
  
  int secs = 0;
  int mins = 0;
  int millis = int(gameTime);
  if( millis >= 1000 )
  {
    secs = millis/1000;
    if( secs >= 60 )
    {
      mins = secs/60;
      for( int i = 0; i < mins; i++ )
      {
        secs -= 60;
      }
    }
  }
  
  minutes = str(mins);
  if( secs < 10 )
  {
    seconds += str(secs);
  }
  else
  {
    seconds = str(secs);
  }
  
  clock = minutes+divider+seconds;
  text( clock, 60, 600);
}

void drawPauseMessage()
{
  fill(0);
  String s = "PAUSED !";
  textSize(50);
  text( s, (width/2), 200 );
  String s1 = "";
  if( !arcadeControls )
  {
    s1 = "P to continue\nSpace to quit";
  }
  else
  {
    s1 = "Button2 to continue\nStart to quit";
  }
  textSize( 20 );
  text( s1, 150, 50 );
}

void controlBlock( int type )
{
  //****Interprets player input and moves block accordingly****
  //Int value passed in determines which direction player wishes to move block
  //type 0 = move left
  //type 1 = move right
  //type 2 = move down
    
  for( int i = 0; i < activeBlocks.size(); i++ )
  {
    Block temp = activeBlocks.get(i);
    if( temp.inPlay )
    {
      if( type == 0 )
      {
        if( temp.xPos != 0 && blickGrid[temp.xPos-1][temp.yPos].isOccupied == false )
        {
          blickGrid[temp.xPos][temp.yPos].isOccupied = false;
          temp.xPos--;
        }
      }
      else if( type == 1 )
      {
        if( temp.xPos != (cols-1) && blickGrid[temp.xPos+1][temp.yPos].isOccupied == false )
        {
          blickGrid[temp.xPos][temp.yPos].isOccupied = false;
          temp.xPos++;
        }
      }
      else if( type == 2 )
      {
        if( !blockDown_flag )
        {
          blockDown_flag = true;
          blockDropSpeed = fastDropSpeed;
        }
      }
      break;
    }
  }
}



void setupBlicks()
{
  for( int i = 0; i < cols; i++ )
  {
    for( int j = 0; j < rows; j++ )
    {
      blickGrid[i][j] = new Blick();
    }
  }
}

//type = 0 for sorting x, 1 for sorting y
void bubbleSortBlocks( int type )
{
  Block temp1, temp2;
  boolean flag = true;
  int i;
  
  //Split block array
  while( flag )
  {
    flag = false;
    if( type == 0 )
    {
      //if sorting x
      for( i = 0; i < activeBlocks.size()-1; i++ )
      {
        temp1 = activeBlocks.get(i);
        temp2 = activeBlocks.get(i+1);
        if( temp1.xPos > temp2.xPos )
        {
          activeBlocks.set( i, temp2 );
          activeBlocks.set( i+1, temp1 );
          flag = true;
        }
      }
    }
    else
    {
      //if sorting y
      for( i = 0; i < activeBlocks.size()-1; i++ )
      {
        temp1 = activeBlocks.get(i);
        temp2 = activeBlocks.get(i+1);
        if( temp1.yPos < temp2.yPos )
        {
          activeBlocks.set( i, temp2 );
          activeBlocks.set( i+1, temp1 );
          flag = true;
        }
      }
    }
  }
}

void drawGameOverScreen()
{
  textSize(100);
  textAlign(CENTER);
  fill(0);
  text( "GAME OVER", width/2, height/2 );
  textSize( 45 );
  text( "Score = " + str(int(score)), width/2, (height/3)*2 );
  textSize( 25 );
  if( !arcadeControls )
  {
    text( "Press Enter", width/2, ((height/7)*6) );
  }
  else
  {
    text( "Press Start", width/2, ((height/7)*6) );
  }
}

boolean allBlocksSettled()
{
  boolean settled = true;
  Block temp = new Block();
  for( int i = (activeBlocks.size()-1); i >= 0; i-- )
  {
    temp = activeBlocks.get(i);
    if( !blickGrid[temp.xPos][temp.yPos].isSettled )
    {
      settled = false;
      break;
    }
  }
  return settled;
}

void drawFallIndicator()
{
  if( blockInPlay )
  {
    int x = -1;
    int y = -1;
    for( int i = 0; i < activeBlocks.size(); i++ )
    {
      Block temp = activeBlocks.get(i);
      if( temp.inPlay == true )
      {
        x = temp.xPos;
        y = temp.yPos;
        break;
      }
    }
    if( x >= 0 && y >= 0 )
    {
      rectMode(CORNERS);
      fill(220);
      noStroke();
      rect( (xPositions[x] - (blockSize/2)), (yPositions[y] + (blockSize/2)), (xPositions[x] + (blockSize/2)), height );
    }
  }
}

void settleBlocks()
{
  while( !allBlocksSettled() )
  {
    for( int i = 0; i < activeBlocks.size(); i++ )
    {
      Block temp = activeBlocks.get(i);
      if( !blickGrid[temp.xPos][temp.yPos].isSettled )
      {
         temp.update();
         break;
      }
    }
  }
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

void addBlockLevel()
{
  //check top row for blocks
  if( blocksSinceLastPush > blockPushDelay )
  {
    blocksSinceLastPush = 0;
    boolean doPush = true;
    for( int i = 0; i < activeBlocks.size(); i++ )
    {
      Block temp = activeBlocks.get(i);
      if( temp.yPos == (rows-1) )
      {
        doPush = false;
        break;
      }
    }
    if( doPush )
    {
      //If there are no blocks in the top row
      //Move all blocks up one position
      bubbleSortBlocks(1);
      for( int i = activeBlocks.size()-1; i >= 0; i-- )
      {
        Block temp = activeBlocks.get(i);
        blickGrid[temp.xPos][temp.yPos].isSettled = false;
        blickGrid[temp.xPos][temp.yPos].isOccupied = false;
        temp.yPos++;
        blickGrid[temp.xPos][temp.yPos].isSettled = true;
        blickGrid[temp.xPos][temp.yPos].isOccupied = true;
      }
      //Add new blocks in empty row beneath
      for( int i = 0; i < cols; i++ )
      {
        Block newBlock = new Block( i, 0 );
        blickGrid[newBlock.xPos][newBlock.yPos].isSettled = true;
        activeBlocks.add( newBlock );
      }
      bubbleSortBlocks(1);
    }
    else
    {
      //If there are blocks in the top row, end the game.
    }
  }
}
