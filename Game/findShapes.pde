boolean blockTypeNearby( Block block )
{
  //Checks 4 surrounding horizontal and vertical blocks for same colour types,
  //returns true if at least 1 found, false if 0 found.
  
  boolean blockNearby = false;
  Block blockLeft = new Block(), blockRight = new Block(), blockUp = new Block(), blockDown = new Block(), tempBlock = new Block();
  boolean checkLeft = false, checkRight = false, checkUp = false, checkDown = false;
  //Did not put in a boolean "downExists" because as long is the block is not at 0 there will always be a block beneath it
  boolean leftExists = false, rightExists = false, topExists = false;
  //Check to see if there are blocks in the blicks being checked
  if( block.xPos != 0 )
  {
    if( blickGrid[ block.xPos-1 ][block.yPos].isOccupied )
    {
      leftExists = true;
    }
  }
  if( block.xPos != (cols-1) )
  {
    if( blickGrid[ block.xPos+1 ][block.yPos].isOccupied )
    {
      rightExists = true;
    }
  }
  if( block.yPos != (rows-1) )
  {
    if( blickGrid[block.xPos][block.yPos+1].isOccupied )
    {
      topExists = true;
    }
  }
  //Check four surrounding blocks (above, below, left, right) for same colour types
  for( int i = 0; i < activeBlocks.size(); i++ )
  {
    //Collect nearby blocks into Block datatypes
    tempBlock = activeBlocks.get(i);
    if( block.xPos != 0 )
    {
      if( leftExists )
      {
        if( tempBlock.xPos == (block.xPos-1) && tempBlock.yPos == block.yPos )
        {
          blockLeft = tempBlock;
          checkLeft = true;
        }
      }
    }
    if( block.xPos != (cols-1) )
    {
      if( rightExists )
      {
        if( tempBlock.xPos == (block.xPos+1) && tempBlock.yPos == block.yPos )
        {
          blockRight = tempBlock;
          checkRight = true;
        }
      }
    }
    if( block.yPos != (rows-1) )
    {
      if( topExists )
      {
        if( tempBlock.yPos == (block.yPos+1) && tempBlock.xPos == block.xPos )
        {
          blockUp = tempBlock;
          checkUp = true;
        }
      }
    }
    if( block.yPos != 0 )
    {
      if( tempBlock.yPos == block.yPos-1 && tempBlock.xPos == block.xPos )
      {
        blockDown = tempBlock;
        checkDown = true;
      }
    }
  }
  //Check for same colour types in collected blocks
  boolean continueCheck = true;
  if( checkLeft )
  {
    if( blockLeft.type == block.type )
    {
      blockNearby = true;
      continueCheck = false;
    }
  }
  if( continueCheck )
  {
    if( checkRight )
    {
      if( blockRight.type == block.type )
      {
        blockNearby = true;
        continueCheck = false;
      }
    }
  }
  if( continueCheck )
  {
    if( checkUp )
    {
      if( blockUp.type == block.type )
      {
        blockNearby = true;
        continueCheck = false;
      }
    }
  }
  if( continueCheck )
  {
    if( checkDown )
    {
      if( blockDown.type == block.type ) 
      {
        blockNearby = true;
      }
    }
  }
  return blockNearby;
}

void removeFinishedShapes()
{
  if( !blockInPlay )
  {
    finishedRemovingBlocks = false;
    while( !finishedRemovingBlocks )
    {
      finishedRemovingBlocks = true;
      if( !activeBlocks.isEmpty() )
      {
        Block temp;
        int x = activeBlocks.size() - 1;
        for( int i = x; i >= 0; i-- )
        {
          boolean continueSearch = true; //Dont keep checking every shape if one was found and removed
          if( activeBlocks.size() < x ) 
          {
            break;
          }
          temp = activeBlocks.get(i);
          int search = findBlock_I( temp );//Search for an I block (horizontal+vertical)
          if( search != -1 )
          {
            //If an I block was found
            continueSearch = false;
            score += points.i;
            if( search == 0 )
            {
              //If found a vertical I block
              pointMessages.add( new PointMessage( 'i', temp.xPos, (temp.yPos+1) ) );
            }
            else if( search == 1 )
            {
              //If found a horizontal I block
              pointMessages.add( new PointMessage( 'i', (temp.xPos+1), temp.yPos ) );
            }
            finishedRemovingBlocks = false;
          }
          if( continueSearch )
          {
            search = findBlock_S( temp );
            if( search != -1 )
            {
              //If an S block was found
              continueSearch = false;
              score += points.s;
              if( search == 0 )
              {
                //If found a vertical S block
                pointMessages.add( new PointMessage( 's', temp.xPos, (temp.yPos+1) ) );
              }
              else if( search == 1 )
              {
                //If found a horizontal S block
                pointMessages.add( new PointMessage( 's', (temp.xPos+1), (temp.yPos+1) ) );
              }
              finishedRemovingBlocks = false;
            }
          }
          if( continueSearch )
          {
            search = findBlock_Z( temp );
            if( search != -1 )
            {
              //If a Z block was found
              continueSearch = false;
              score += points.z;
              if( search == 0 )
              {
                //If found a vertical Z block
                pointMessages.add( new PointMessage( 'z', temp.xPos, (temp.yPos+1) ) );
              }
              else if( search == 1 )
              {
                //If found a horizontal Z block
                pointMessages.add( new PointMessage( 'z', (temp.xPos+1), (temp.yPos+1) ) );
              }
              finishedRemovingBlocks = false;
            }
          }
          if( continueSearch )
          {
            search = findBlock_L( temp );
            if( search != -1 )
            {
              continueSearch = false;
              score += points.l;
              if( search == 0 )
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos-1), (temp.yPos+1) ) );
              }
              else if( search == 1 )
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos+1), (temp.yPos+1) ) );
              }
              else if( search == 2 )
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos+1), (temp.yPos-2) ) );
              }
              else if( search == 3 ) 
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos-1), (temp.yPos-1) ) );
              }
              finishedRemovingBlocks = false;
            }
          }
          if( continueSearch )
          {
            search = findBlock_J( temp );
            if( search != -1 )
            {
              continueSearch = false;
              score += points.j;
              if( search == 0 )
              {
                pointMessages.add( new PointMessage( 'j', (temp.xPos+1), (temp.yPos+1) ) );
              }
              else if( search == 1 )
              {
                pointMessages.add( new PointMessage( 'j', (temp.xPos+1), (temp.yPos-1) ) );
              }
              else if( search == 2 )
              {
                pointMessages.add( new PointMessage( 'j', (temp.xPos-1), (temp.yPos-1) ) );
              }
              else if( search == 3 ) 
              {
                pointMessages.add( new PointMessage( 'j', (temp.xPos-2), (temp.yPos+1) ) );
              }
              finishedRemovingBlocks = false;
            }
          }
          if( continueSearch )
          {
            search = findBlock_O( temp );
            if( search != -1 )
            {
              continueSearch = false;
              score += points.o;
              if( search == 0 )
              {
                pointMessages.add( new PointMessage( 'o', (temp.xPos+1), (temp.yPos+1) ) );
              }
              else if( search == 1 )
              {
                pointMessages.add( new PointMessage( 'o', (temp.xPos+1), (temp.yPos-1) ) );
              }
              else if( search == 2 )
              {
                pointMessages.add( new PointMessage( 'o', (temp.xPos-1), (temp.yPos-1) ) );
              }
              else if( search == 3 ) 
              {
                pointMessages.add( new PointMessage( 'o', (temp.xPos-2), (temp.yPos+1) ) );
              }
              finishedRemovingBlocks = false;
            }
          }
          if( continueSearch )
          {
            search = findBlock_T( temp );
            if( search != -1 )
            {
              continueSearch = false;
              score += points.t;
              if( search == 0 )
              {
                pointMessages.add( new PointMessage( 't', (temp.xPos+1), (temp.yPos+1) ) );
              }
              else if( search == 1 )
              {
                pointMessages.add( new PointMessage( 't', (temp.xPos+1), (temp.yPos-1) ) );
              }
              else if( search == 2 )
              {
                pointMessages.add( new PointMessage( 't', (temp.xPos-1), (temp.yPos-1) ) );
              }
              else if( search == 3 ) 
              {
                pointMessages.add( new PointMessage( 't', (temp.xPos-2), (temp.yPos+1) ) );
              }
              finishedRemovingBlocks = false;
            }
          }
          if( !continueSearch )
          {
            settleBlocks();
            bubbleSortBlocks(1);
          }
        }
      }
    }
    if( !allBlocksSettled() )
    {
      settleBlocks();
      bubbleSortBlocks(1);
    }
  }
}

Block getAdjacentBlock( Block current, int direction )
{
  //NOTE: Use this method only if you know for certain a block does exist in the space you are trying to take from
  // 0 - UP
  // 1 - RIGHT
  // 2 - DOWN
  // 3 - LEFT
  Block block = null;
  int xDir = 0;
  int yDir = 0;
  switch( direction )
  {
    case 0:
      yDir = 1;
      break;
      
    case 1:
      xDir = 1;
      break;
      
    case 2:
      yDir = -1;
      break;
      
    case 3:
      xDir = -1;
      break;
  }
  
  for( int i = 0; i < activeBlocks.size(); i++ )
  {
    Block temp = activeBlocks.get(i);
    if( temp.xPos == (current.xPos+xDir) && temp.yPos == (current.yPos+yDir) )
    {
      block = temp;
      break;
    }
  }
  return block;
}

boolean sameBlockType( Block current, Block next )
{
  boolean same = false;
  if( current.type == next.type )
  {
    same = true;
  }
  return same;
}

boolean nearbyBlockExists( Block block, int direction )
{
  boolean blockExists = false;
  // 0 - UP
  // 1 - RIGHT
  // 2 - DOWN
  // 3 - LEFT
  int xDir = 0;
  int yDir = 0;
  switch( direction )
  {
    case 0:
      yDir = 1;
      xDir = 0;
      break;
    
    case 1:
      yDir = 0;
      xDir = 1;
      break;
      
    case 2:
      yDir = -1;
      xDir = 0;
      break;
      
    case 3:
      yDir = 0;
      xDir = -1;
      break;
  }
  
  if( blickGrid[(block.xPos+xDir)][(block.yPos+yDir)].isOccupied )
  {
    blockExists = true;
  }
  
  return blockExists;
  
}
