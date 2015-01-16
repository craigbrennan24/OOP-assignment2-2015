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

boolean findI_block( Block block )
{
  //Returns true if block shape was found and removed, false if not
  //Only find vertical blocks at first
  boolean found = false;
  if( blockTypeNearby( block ) )
  {
    int connections = 0;
    Block current = new Block(), next = new Block();
    current = block;
    boolean finished = false;
    while( !finished )
    {
      if( current.yPos < (rows-1) )
      {
        if( blickGrid[current.xPos][current.yPos+1].isOccupied )
        {
          //if there is a block above current
          for( int i = 0; i <= activeBlocks.size(); i++ )
          {
            //Get the block above current into next
            Block temp = activeBlocks.get(i);
            if( temp.xPos == current.xPos && temp.yPos == (current.yPos+1) )
            {
              next = temp;
              break;
            }
          }
          if( current.type == next.type )
          {
            //If current and next are same block type, move onto next set
            connections++;
            current = next;
          }
          else
          {
            //If block above current is different type
            finished = true;
          }
        }
        else
        {
          //If there is no block above current
          finished = true;
        }
      }
      else
      {
        //If at the top of the gameboard
        finished = true;
      }
    }
    if( connections == 3 )
    {
      found = true;
      //Delete the blocks
      current = block;
      for( int i = 0; i < 4; i++ )
      {
        if( i < 3 )
        {
          for( int j = 0; j < activeBlocks.size(); j++ )
          {
            Block temp = activeBlocks.get(j);
            if( temp.xPos == current.xPos && temp.yPos == (current.yPos+1) )
            {
              next = temp;
              break;
            }
          }
        }
        for( int j = 0; j < activeBlocks.size(); j++ )
        {
          Block temp = activeBlocks.get(j);
          if( temp.xPos == current.xPos && temp.yPos == current.yPos )
          {
            finishedRemovingBlocks = false;
            blickGrid[temp.xPos][temp.yPos].isOccupied = false;
            blickGrid[temp.xPos][temp.yPos].isSettled = false;
            activeBlocks.remove(j);
            bubbleSortBlocks(1);
            break;
          }
        }
        current = next;
      }
    }
  }
  return found;
}

void removeFinishedShapes()
{
  if( !blockInPlay )
  {
    finishedRemovingBlocks = false;
    while( !finishedRemovingBlocks )
    {
      finishedRemovingBlocks = true;
      if( activeBlocks.isEmpty() == false )
      {
        Block temp;
        int x = activeBlocks.size() - 1;
        for( int i = x; i >= 0; i-- )
        {
          if( activeBlocks.size() < x ) 
          {
            break;
          }
          temp = activeBlocks.get(i);
          if( findI_block( temp ) )
          {
            score += points.i;
            pointMessages.add( new PointMessage( 0, temp.xPos, temp.yPos ) );
          }
        }
      }
    }
  }
}
