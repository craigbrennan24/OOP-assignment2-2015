void keyPressed()
{
  if( !gameOver )
  {
    if( key == 'p' || key == 'P' )
    {
      paused = !paused;
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
  else
  {
    if( key == ENTER )
    {
      gameOver = false;
      setup();
    }
  }
  
}

void mousePressed()
{
  if( mouseButton == LEFT )
  {
    clearBoard();
  }
  else if( mouseButton == RIGHT )
  {
    if( activeBlocks.isEmpty() )
    {
      randomizeStart();
    }
  }
}
