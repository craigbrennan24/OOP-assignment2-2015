//Blocks
class Block
{
  int xPos, yPos;
  int type;
  /*type = Block color, 0-7 values
  0 - orange
  1 - darkblue
  2 - green
  3 - yellow
  4 - red
  5 - pink
  6 - blue
  7 - grey
  */
  boolean inPlay;
  color c;
  
  Block()
  {
    xPos = 0;
    yPos = 0;
    type = -1;
    inPlay = false;
  }
  
  Block( int x, int y )
  {
    xPos = x;
    yPos = y;
    blickGrid[xPos][yPos].isOccupied = true;
    inPlay = false;
    type = int(random(7));
    c = setColour(type);
  }
  
  Block( int x, int y, int type )
  {
    xPos = x;
    yPos = y;
    blickGrid[xPos][yPos].isOccupied = true;
    inPlay = false;
    this.type = type;
    c = setColour(type);
  }
  
  void draw()
  {
    rectMode(CENTER);
    fill(c);
    stroke(190);
    rect(xPositions[xPos], yPositions[yPos], blockSize, blockSize);
    if( DEBUG_showConnectedBlocks )
    {
      findShapesTest();
    }
  }
  
  void findShapesTest()
  {
    if( blockTypeNearby( new Block( xPos, yPos, type ) ) )
    {
      fill(255);
      rect( xPositions[xPos], yPositions[yPos], testBlockIndicator, testBlockIndicator);
    }
  }
  
  void update()
  {
    if( yPos != 0 )
    {
      if( blickGrid[xPos][(yPos-1)].isOccupied == false )
      {
        blickGrid[xPos][yPos].isSettled = false;
        fall();
      }
      else
      {
        blickGrid[xPos][yPos].isSettled = true;
        updateBlick();
      }
    }
    else
    {
      blickGrid[xPos][yPos].isSettled = true;
      updateBlick();
    }
    if( inPlay == true && blickGrid[xPos][yPos].isSettled == true )
    {
      inPlay = false;
      blockInPlay = false;
    }
  }
  
  void updateBlick()
  {
    blickGrid[xPos][yPos].isOccupied = true;
  }
  
  void fall()
  {
    if( blockInPlay == true )
    {
      if( activeBlockDrop_flag == true )
      { 
        blockFall( xPos, yPos );
        activeBlockDrop_flag = false;
        activeBlockDrop = millis();
      }
    }
    else
    {
      blockFall( xPos, yPos );
    }
  }

}

//Virtual grid of spaces on board that blocks can occupy
class Blick
{
  boolean isOccupied, isSettled;
  
  Blick()
  {
    isOccupied = false;
    isSettled = false;
  }
}

class Points
{
  int i, j, l, o, s, t, z;
  
  Points()
  {
    i = 5;
    o = 7;
    t = 7;
    l = 8;
    j = 8;
    s = 9;
    z = 9;
  }
}

class PointMessage extends Points
{
  int type;
  int xPos, yPos, yPosUpper, yOffset;
  //type - 0 = i, 1 = j, 2 = l, 3 = o, 4 = s, 5 = t, 6 = z
  String message;
  float duration;
  float start;
  color c;
  
  PointMessage(char type, int x, int y)
  {
    this.type = type;
    xPos = x;
    yPos = y;
    yPosUpper = y-50;
    yOffset = 0;
    c = color( 255, 255, 255, 255 );
    switch( type )
    {
      case 'i':
        type = 0;
        message = "+5";
        break;
       
      case 'o':
        type = 3;
        message = "+7";
        break;
        
      case 't':
        type = 5;
        message = "+7";
        break;
        
      case 'l':
        type = 2;
        message = "+8";
        break;
        
      case 'j':
        type = 1;
        message = "+8";
        break;
        
      case 's':
        type = 4;
        message = "+9";
        break;
        
      case 'z':
        type = 6;
        message = "+9";
        break;
    }
    start = millis();
    duration = 1000;
  }
  
  void draw()
  {
    textAlign(CENTER);
    textSize(20);
    fill(c);
    text( message, xPositions[xPos], ( (yPositions[yPos]) - yOffset ) );
    update();
  }
  
  void update()
  {
    if( (millis() - start) <= duration )
    {
      float timeRemaining = duration - (millis() - start);
      float perc = ( (timeRemaining/duration) * 100 );
      float fullOpacity = 255;
      float percInvis;
      if( perc <= 10 )
      {
        percInvis = 0;
      }
      else
      {
        percInvis = int((fullOpacity/100) * perc);
      }
      c = color( 0, 0, 0, percInvis );
      if( (yPos-yOffset) >= yPosUpper )
      {
        yOffset++;
      }
    }
    else
    {
      delete();
    }
  }
  
  void delete()
  {
    for( int i = 0; i < pointMessages.size(); i++ )
    {
      PointMessage msg = pointMessages.get(i);
      if( msg.xPos == xPos && msg.yPos == yPos )
      {
        pointMessages.remove(i);
      }
    }
  }
  
}
