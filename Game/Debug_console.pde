void drawDebugConsole()
{
  textSize(18);
  textAlign(LEFT);
  String s1, s2, s3, s4, s5, s6, s7, s8;
  s1 = "LeftClick to clear board!";
  s2 = "RightClick to add starting blocks!";
  s3 = "Press Enter to drop block!";
  s5 = str(activeBlocks.size());
  s6 = "blockInPlay - " + str(blockInPlay);
  s4 = "blockDropSpeed = " + str(blockDropSpeed);
  s7 = "Score: " + str(int(score));
  s8 = "found = " + str(DEBUG_foundL);
  
  text( s1, 20, 100 );
  text( s2, 20, 125 );
  text( s3, 20, 150 );
  textSize(14);
  text( s4, 20, 175 );
  text( s5, 20, 200 );
  text( s6, 20, 225 );
  text( s7, 20, 250 );
  text( s8, 20, 275 );
  if( DEBUG_showNumberGrid )
  {
    drawNumberGrid();
  }
}

void drawNumberGrid()
{
  textSize(12);
  float gameBoardLeft = ( screenCenterX - (gameBoardWidth/2) );
  for( int i = 0; i < rows; i++ )
  {
    text( str(i), ( gameBoardLeft - 20 ), ( height - ( ( blockSize/2 ) + (blockSize*i) ) ) );
  }
  for( int i = 0; i < cols; i++ )
  {
    text( str(i), gameBoardLeft + ( blockSize/2 + (blockSize*i) ), blockSize/2 );
  }
}
