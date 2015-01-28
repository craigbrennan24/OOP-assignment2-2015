int findBlock_L( Block block )
{
  //Returns -1 if L block was not found
  //Returns these integer valuesfindBlock_L to show which rotation of shape was found
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
                blockSearchResult = i;//Found block, record type found
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
      for( int i = 0; i < 4; i++ )
      {
        if( i < 3 )
        {
          next = getAdjacentBlock( current, searchDirs[blockSearchResult][i] );
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
        current = next;
      }
    }
  }
  return blockSearchResult;
}
