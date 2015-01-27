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
        if( blickGrid[current.xPos][current.yPos+1].isOccupied )//if there is a block above current
        {
          next = getAdjacentBlock( current, 0 );//Get block above current into next
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
          next = getAdjacentBlock( current, 0 );
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
            next = getAdjacentBlock( current, 1 );
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
            next = getAdjacentBlock( current, 1 );
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
            next = getAdjacentBlock( current, 0 );
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
              next = getAdjacentBlock( current, 3 );
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
          if( checkVert )
          {
            next = getAdjacentBlock( current, 0 );
            checkVert = !checkVert;
          }
          else
          {
            next = getAdjacentBlock( current, 3 );
            checkVert = !checkVert;
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
              next = getAdjacentBlock( current, 0 );
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
              next = getAdjacentBlock( current, 1 );
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
            if( checkVert )
            {
              next = getAdjacentBlock( current, 0 );
              checkVert = !checkVert;
            }
            else
            {
              next = getAdjacentBlock( current, 1 );
              checkVert = !checkVert;
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

int findZ_block( Block block )
{
  //Returns -1 if Z block was not found
  //Returns 0 if Z block was found and Z block is vertical
  //Returns 1 if Z block was found and Z block is horizontal
  boolean found = false;
  int blockSearchResult = -1;
  if( blockTypeNearby( block ) )
  {
    int connections = 0;
    Block current = new Block(), next = new Block();
    current = block;
   
//---------VERTICAL 'Z' BlOCK --------- 

    //search for and remove vertical Z block
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
            next = getAdjacentBlock( current, 0 );
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
          if( current.xPos < (cols-1) )
          {
            if( blickGrid[current.xPos+1][current.yPos].isOccupied )
            {
              //if there is a block to the right of current
              next = getAdjacentBlock( current, 1 );
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
          else
          {
            //If too close to right side of the board
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
          if( checkVert )
          {
            next = getAdjacentBlock( current, 0 );
            checkVert = !checkVert;
          }
          else
          {
            next = getAdjacentBlock( current, 1 );
            checkVert = !checkVert;
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
    
//---------HORIZONTAL 'Z' BLOCK---------
    
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
        if( current.xPos > 0 && current.yPos < (rows-1) )
        {
          if( checkVert )
          {
            if( blickGrid[current.xPos][current.yPos+1].isOccupied )
            {
              next = getAdjacentBlock( current, 0 );
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
            if( blickGrid[current.xPos-1][current.yPos].isOccupied )
            {
              //if there is a block to the left of current
              next = getAdjacentBlock( current, 3 );
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
            if( checkVert )
            {
              next = getAdjacentBlock( current, 0 );
              checkVert = !checkVert;
            }
            else
            {
              next = getAdjacentBlock( current, 3 );
              checkVert = !checkVert;
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

int findL_block( Block block )
{
  //Returns -1 if L block was not found
  //Returns these integer values to show which rotation of shape was found
  //   0        1        2        3
  //--XX---- -------- --XXXX-- --------
  //--XX---- XXXXXXXX --XXXX-- ------XX
  //--XX---- XXXXXXXX ----XX-- ------XX
  //--XX---- XX------ ----XX-- XXXXXXXX
  //--XXXX-- XX------ ----XX-- XXXXXXXX
  //--XXXX-- -------- ----XX-- --------
  int blockSearchResult = -1;
  if( blockTypeNearby( block ) )
  {
    int connections = 0;
    Block current = new Block(), next = new Block();
    current = block;
    int[][] searchDirs = new int[][]{ 
                                   { 3, 0, 0 },
                                   { 0, 1, 1 },
                                   { 1, 2, 2 },
                                   { 2, 3, 3 } };
    int rotationSearch = 0; //Which rotation of shape currently being searched for, change to -1 if one was found to stop search
    int xDir = 0;
    int yDir = 0;
    for( int i = 0; i < 4; i++ )
    {
      current = block;
      connections = 0;
      for( int j = 0; j < 3; j++ )
      {
        boolean doSearch = false;
        switch( searchDirs[i][j] )
        {
          case 0:
            if( current.yPos < (rows-1) )
            {
              doSearch = true;
            }
            yDir = 1;
            xDir = 0;
            break;
        
          case 1:
            if( current.xPos < (cols-1) )
            {
               doSearch = true; 
            }
            yDir = 0;
            xDir = 1;
            break;
            
          case 2:
            if( current.yPos > 0 )
            {
              doSearch = true;
            }
            yDir = -1;
            xDir = 0;
            break;
            
          case 3:
            if( current.xPos > 0 )
            {
              doSearch = true;
            }
            yDir = 0;
            xDir = -1;
            break;
        }
        if( doSearch )
        {
          if( nearbyBlockExists( current, searchDirs[i][j] ) )
          {
            next = getAdjacentBlock( current, searchDirs[i][j] );
            if( sameBlockType( current, next ) )
            {
              connections++;
              current = next;
              if( connections == 3 )
              {
                blockSearchResult = i;//Found block, show type found
                break;
              }
            }
            else
            {
              break;
            }
          }
          else
          {
            break;
          }
        }
      }
      if( connections == 3 )
      {
        break;
      }
    }
    
    //Add code for removal here
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
          int search = findI_block( temp );//Search for an I block (horizontal+vertical)
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
            search = findS_block( temp );
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
            search = findZ_block( temp );
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
            search = findL_block( temp );
            if( search != -1 )
            {
              DEBUG_foundL = true;
              continueSearch = false;
              /*
              score += points.l;
              if( search == 0 )
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos-1), (temp.yPos+1) ) );
              }
              else if( search == 1 )
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos+2), (temp.yPos+1) ) );
              }
              else if( search == 2 )
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos+1), (temp.yPos-2) ) );
              }
              else if ( search == 3 ) 
              {
                pointMessages.add( new PointMessage( 'l', (temp.xPos-2), (temp.yPos-1) ) );
              }
              finishedRemovingBlocks = false;
              */
            }
          }
          if( !continueSearch )
          {
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
