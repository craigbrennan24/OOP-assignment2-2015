void setupPositions()
{
  //X spaces
  int tick = 0;
  
  for( tick = 0; tick < cols; tick++ )
  {
     xPositions[tick] = ((((screenCenterX - (gameBoardWidth/2)) + (blockSize/2))) + (blockSize*tick));
  }
  //Y spaces
  for( tick = 0; tick < rows; tick++ )
  {
    yPositions[tick] = ( (screenSizeY - (blockSize/2)) - (blockSize*tick));
  }
}

void setupColors()
{
  orange = color(255, 204, 0);
  darkBlue = color(50, 55, 100);
  green = color(0, 255, 0);
  yellow = color(255, 255, 0);
  red = color(255, 0, 0);
  pink = color(255, 0, 255);
  blue = color(0, 150, 255);
  grey = color(190, 190, 190);
}

color setColour(int z)
{
  color c = color(255);
  switch(z)
  {
     case 0:
       c = orange;
       break;
     case 1:
       c = darkBlue;
       break;
     case 2:
       c = green;
       break;
     case 3:
       c = yellow;
       break;
     case 4:
       c = red;;
       break;
     case 5:
       c = pink;
       break;
     case 6:
       c = blue;
       break;
  }
  return c;
}
