int findBlock_T( Block block )
{
  //Returns -1 if T block was not found
  //Returns these integer values to show which rotation of shape was found
  //   0        1        2        3
  //--XX---- -------- ----XX-- --------
  //--XX---- XXXXXXXX ----XX-- ---XX---
  //--XXXX-- XXXXXXXX --XXXX-- ---XX---
  //--XXXX-- ---XX--- --XXXX-- XXXXXXXX
  //--XX---- ---XX--- ----XX-- XXXXXXXX
  //--XX---- -------- ----XX-- --------
  
  int blockSearchResult = -1;
  if( blockTypeNearby( block ) )
  {
    int connections = 0;
    Block current = new Block(), next = new Block(), prev = new Block(); //Prev is a special placeholder needed for this particular shape as the search will have to reverse
    current = block;
    int[][] searchDirs = new int[][]{ 
                                   { 0, 0, 1 },
                                   { 1, 1, 2 },
                                   { 2, 2, 3 },
                                   { 3, 3, 0 } };
    int xDir = 0;
    int yDir = 0;
    for( int i = 0; i < 4; i++ )
    {
      current = block;
      prev = current;
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
          if( j == 2 )
          {
            current = prev;
          }
          if( nearbyBlockExists( current, searchDirs[i][j] ) )
          {
            next = getAdjacentBlock( current, searchDirs[i][j] );
            if( sameBlockType( current, next ) )
            {
              connections++;
              prev = current;
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
    
    if( blockSearchResult != -1 )//Remove shape if found
    {
      current = block;
      prev = current;
      for( int i = 0; i < 4; i++ )
      {
        if( i < 2 )
        {
          next = getAdjacentBlock( current, searchDirs[blockSearchResult][i] );
        }
        if( i == 2 )
        {
          next = prev;
          next = getAdjacentBlock( next, searchDirs[blockSearchResult][i] );
        }
        if( i == 3 )
        {
          current = next;
        }
        for( int j = 0; j < activeBlocks.size(); j++ )
        {
          Block temp = activeBlocks.get(j);
          if( temp.xPos == current.xPos && temp.yPos == current.yPos )
          {
            blickGrid[temp.xPos][temp.yPos].isOccupied = false;
            blickGrid[temp.xPos][temp.yPos].isSettled = false;
            activeBlocks.remove(j);
            break;
          }
        }
        prev = current;
        current = next;
      }
    }
    
  }
  return blockSearchResult;
}
