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

int findI_block( Block block )
{
  //Returns -1 if I block was not found
  //Returns 0 if I block was found and I block is vertical
  //Returns 1 if I block was found and I block is horizontal
  boolean found = false;
  int blockSearchResult = -1;
  if( blockTypeNearby( block ) )
  {
    int connections = 0;
    Block current = new Block(), next = new Block();
    current = block;
   
//---------VERTICAL 'I' BlOCK --------- 

    //search for and remove vertical block
    boolean finished = false;
    while( !finished )
    {
      if( current.yPos < (rows-1) )
      {
        if( blickGrid[current.xPos][current.yPos+1].isOccupied )
        {
          //if there is a block above current
          for( int i = 0; i < activeBlocks.size(); i++ )
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
      blockSearchResult = 0;
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
    
//---------HORIZONTAL 'I' BLOCK--------- 
    
    if( !found )//If no vertical block was found
    {
      //Search and remove horizontal block
      current = new Block();
      next = new Block();
      current = block;
      connections = 0;
      finished = false;
      while( !finished )
      {
        if( current.xPos < (cols-1) )
        {
          if( blickGrid[current.xPos+1][current.yPos].isOccupied )
          {
            //if there is a block to the right of current
            for( int i = 0; i < activeBlocks.size(); i++ )
            {
              //Get the block to the right of current into next
              Block temp = activeBlocks.get(i);
              if( temp.xPos == (current.xPos+1) && temp.yPos == current.yPos )
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
              //If block to the right of current is different type
              finished = true;
            }
          }
          else
          {
            //If there is no block to the right of current
            finished = true;
          }
        }
        else
        {
          //If at the right edge of the gameboard
          finished = true;
        }
      }
      if( connections == 3 )
      {
        found = true;
        //Delete the blocks
        blockSearchResult = 1;
        current = block;
        for( int i = 0; i < 4; i++ )
        {
          if( i < 3 )
          {
            for( int j = 0; j < activeBlocks.size(); j++ )
            {
              Block temp = activeBlocks.get(j);
              if( temp.xPos == (current.xPos+1) && temp.yPos == current.yPos )
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
  }
  return blockSearchResult;
}

int findS_block( Block block )
{
  //Returns -1 if S block was not found
  //Returns 0 if S block was found and S block is vertical
  //Returns 1 if S block was found and S block is horizontal
  boolean found = false;
  int blockSearchResult = -1;
  if( blockTypeNearby( block ) )
  {
    int connections = 0;
    Block current = new Block(), next = new Block();
    current = block;
   
//---------VERTICAL 'S' BlOCK --------- 

    //search for and remove vertical S block
    boolean finished = false;
    boolean checkVert = true;
    while( !finished )
    {
      if( current.yPos < (rows-1) )
      {
        if( checkVert )
        {
          if( blickGrid[current.xPos][current.yPos+1].isOccupied )
          {
            for( int i = 0; i < activeBlocks.size(); i++ )
            {
              Block temp = activeBlocks.get(i);
              if( temp.xPos == current.xPos && temp.yPos == (current.yPos+1) )
              {
                next = temp;
                break;
              }
            }
            if( current.type == next.type )
            {
              connections++;
              current = next;
              checkVert = !checkVert;
            }
            else
            {
              finished = true;
            }
          }
          else
          {
            finished = true;
          }
        }
        else
        {
          if( current.xPos > 0 )
          {
            if( blickGrid[current.xPos-1][current.yPos].isOccupied )
            {
              //if there is a block to the left of current
              for( int i = 0; i < activeBlocks.size(); i++ )
              {
                //Get the block to the left of current into next
                Block temp = activeBlocks.get(i);
                if( temp.xPos == (current.xPos-1) && temp.yPos == current.yPos )
                {
                  next = temp;
                  break;
                }
              }
              if( current.type == next.type )
              {
                //If current and next are same block type, move onto next set
                connections++;
                checkVert = !checkVert;
                current = next;
              }
              else
              {
                //If block to the left of current is different type
                finished = true;
              }
            }
            else
            {
              //If there is no block to the left of current
              finished = true;
            }
          }
          else
          {
            //If too close to left side of the board
            finished = true;
          }
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
      blockSearchResult = 0;
      //Delete the blocks
      current = block;
      checkVert = true;
      for( int i = 0; i < 4; i++ )
      {
        if( i < 3 )//Don't move next above current on last block, nothing will be there
        {
          for( int j = 0; j < activeBlocks.size(); j++ )
          {
            Block temp = activeBlocks.get(j);
            if( checkVert )
            {
              if( temp.xPos == current.xPos && temp.yPos == (current.yPos+1) )
              {
                next = temp;
                checkVert = !checkVert;
                break;
              }
            }
            else
            {
              if( temp.xPos == (current.xPos-1) && temp.yPos == current.yPos )
              {
                next = temp;
                checkVert = !checkVert;
                break;
              }
            }
          }
        }
        for( int j = 0; j < activeBlocks.size(); j++ )
        {
          Block temp = activeBlocks.get(j);
          if( temp.xPos == current.xPos && temp.yPos == current.yPos )
          {
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
    
//---------HORIZONTAL 'S' BLOCK---------
    
    if( !found )//If no vertical block was found
    {
      //Search and remove horizontal block
      current = new Block();
      next = new Block();
      current = block;
      connections = 0;
      finished = false;
      checkVert = false;
      while( !finished )
      {
        if( current.xPos < (cols-1) && current.yPos < (rows-1) )
        {
          if( checkVert )
          {
            if( blickGrid[current.xPos][current.yPos+1].isOccupied )
            {
              for( int i = 0; i < activeBlocks.size(); i++ )// MIGHT CRASH IDK
              {
                Block temp = activeBlocks.get(i);
                if( temp.xPos == current.xPos && temp.yPos == (current.yPos+1) )
                {
                  next = temp;
                  break;
                }
              }
              if( current.type == next.type )
              {
                connections++;
                current = next;
                checkVert = !checkVert;
              }
              else
              {
                finished = true;
              }
            }
            else
            {
              finished = true;
            }
          }
          else
          {
            if( blickGrid[current.xPos+1][current.yPos].isOccupied )
            {
              //if there is a block to the right of current
              for( int i = 0; i < activeBlocks.size(); i++ )// ALSO MIGHT CRASH
              {
                //Get the block to the right of current into next
                Block temp = activeBlocks.get(i);
                if( temp.xPos == (current.xPos+1) && temp.yPos == current.yPos )
                {
                  next = temp;
                  break;
                }
              }
              if( current.type == next.type )
              {
                //If current and next are same block type, move onto next set
                connections++;
                checkVert = !checkVert;
                current = next;
              }
              else
              {
                //If block to the right of current is different type
                finished = true;
              }
            }
            else
            {
              //If there is no block to the right of current
              finished = true;
            }
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
        blockSearchResult = 1;
        //Delete the blocks
        current = block;
        next = current;
        checkVert = false;
        for( int i = 0; i < 4; i++ )
        {
          if( i < 3 )
          {
            for( int j = 0; j < activeBlocks.size(); j++ )
            {
              Block temp = activeBlocks.get(j);
              if( checkVert )
              {
                if( temp.xPos == current.xPos && temp.yPos == (current.yPos+1) )
                {
                  next = temp;
                  checkVert = !checkVert;
                  break;
                }
              }
              else
              {
                if( temp.xPos == (current.xPos+1) && temp.yPos == current.yPos )
                {
                  next = temp;
                  checkVert = !checkVert;
                  break;
                }
              }
            }
          }
          for( int j = 0; j < activeBlocks.size(); j++ )
          {
            Block temp = activeBlocks.get(j);
            if( temp.xPos == current.xPos && temp.yPos == current.yPos )
            {
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
  }
  return blockSearchResult;
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
          int search = findI_block( temp );//Search for an I block (horizontal+vertical)
          if( search != -1 )
          {
            //If an I block was found
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
            settleBlocks();
          }
          search = findS_block( temp );
          if( search != -1 )
          {
            //If an S block was found
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
            settleBlocks();
          }
        }
      }
    }
    if( !allBlocksSettled() )
    {
      settleBlocks();
    }
  }
}
