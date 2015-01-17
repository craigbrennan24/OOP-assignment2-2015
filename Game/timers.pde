void updateTimers()
{
  if( activeBlockDrop_flag == false )
  {
    if( (millis() - activeBlockDrop) >= blockDropSpeed*1000 )
    {
      activeBlockDrop_flag = true;
    }
  }
  if( dropNext_flag )
  {
    if( (millis() - dropNext) >= dropNextDelay && allBlocksSettled() == true )
    {
      dropBlock();
      dropNext_flag = false;
    }
  }
  if( blockDown_flag )
  {
    if( !blockInPlay )
    {
      blockDown_flag = !blockDown_flag;
      blockDropSpeed = normalDropSpeed;
    }
  }
}

void timeDropNext()
{
  if( dropNext_flag == false && blockInPlay == false )
  {
    dropNext = millis();
    dropNext_flag = true;
  }
}