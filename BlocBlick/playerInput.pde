void keyPressed()
{
  keys[keyCode] = true;
  if( !arcadeControls )
  {
    //If playing on PC
    if( !gameOver )
    {
      if( inGame ) 
      {
        /* PC CONTROLS */
        if( key == 'p' || key == 'P' )
        {
          paused = !paused;
        }
        if( paused )
        {
          if( key == ' ' )
          {
            inGame = false;
            titleScreen = true;
            paused = false;
          }
        }
        if( blockInPlay )
        {
          if( key == CODED )
          {
            if( keyCode == LEFT )
            {
              controlBlock( 0 );
            }
            else if( keyCode == RIGHT )
            {
              controlBlock( 1 );
            }
            else if( keyCode == DOWN )
            {
              controlBlock( 2 );
            }
          }
          else
          {
            if( key == 'a' || key == 'A' )
            {
              controlBlock( 0 );
            }
            else if( key == 'd' || key == 'D' )
            {
              controlBlock( 1 );
            }
            else if( key == 's' || key == 'S' )
            {
              controlBlock( 2 );
            }
            else if( key == ' ' )
            {
              dropNextDelay = 0;
            }
          }
        }
        else
        {
          if( key == ENTER )
          {
            dropBlock();
          }
        }
      }
      else if( titleScreen )
      {
        if( key == ' ' )
        {
          titleScreen = false;
          score = 0;
          clearBoard();
          randomizeStart();
          inGame = true;
        }
        else if( key == 'h' || key == 'H' )
        {
          titleScreen = false;
          helpScreen = true;
        }
      }
      else if( helpScreen )
      {
        if( key == ' ' )
        {
          helpScreen = false;
          titleScreen = true;
        }
      }
    }
    else
    {
      if( key == ENTER )
      {
        gameOver = false;
        score = 0;
        setup();
        inGame = false;
        titleScreen = true;
      }
    }
  }
  else
  {
    //If playing on arcade machine
    if( !gameOver )
    {
      if( inGame ) 
      {
        /* ARCADE CONTROLS */
        if( checkKey(button2) )
        {
          paused = !paused;
        }
        if( paused )
        {
          if( checkKey(start) )
          {
            inGame = false;
            titleScreen = true;
            paused = false;
          }
        }
        if( blockInPlay )
        {
          if( checkKey(left) )
          {
            controlBlock( 0 );
          }
          else if( checkKey(right) )
          {
            controlBlock( 1 );
          }
          else if( checkKey(down) )
          {
            controlBlock( 2 );
          }
        }
      }
      else if( titleScreen )
      {
        if( checkKey( start ) )
        {
          titleScreen = false;
          score = 0;
          clearBoard();
          randomizeStart();
          inGame = true;
        }
        else if( checkKey( button1 ) )
        {
          titleScreen = false;
          helpScreen = true;
        }
      }
      else if( helpScreen )
      {
        if( checkKey( button2 ) )
        {
          helpScreen = false;
          titleScreen = true;
        }
      }
    }
    else
    {
      if( checkKey(start) )
      {
        gameOver = false;
        score = 0;
        setup();
      }
    }
  }
  
}

void keyReleased()
{
  keys[keyCode] = false;
}

boolean checkKey(char theKey)
{
  return keys[Character.toUpperCase(theKey)];
}

char buttonNameToKey(XML xml, String buttonName)
{
  String value = xml.getChild(buttonName).getContent();
  if ("LEFT".equalsIgnoreCase(value))
  {
    return LEFT;
  }
  if ("RIGHT".equalsIgnoreCase(value))
  {
    return RIGHT;
  }
  if ("UP".equalsIgnoreCase(value))
  {
    return UP;
  }
  if ("DOWN".equalsIgnoreCase(value))
  {
    return DOWN;
  }
  return value.charAt(0);
}
