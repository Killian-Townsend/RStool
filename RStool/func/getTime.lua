local string = require("string")

function getTime(time)
  -- 00:00:00:00
  local sec  = "00"
  local min  = "00"
  local hour = "00"
  local day  = "00"
  -- Seconds
  if(time > 59) then
    sec = string.sub("00" .. (time - (round(time / 60) * 60)), -4, -3)
  else
    sec = string.sub("00" .. time, -2)
  end
  -- Minutes
  if(time > 60) then
    min = string.sub("00" .. round(time / 60), -4, -3)
  else
    min = "00"
  end
  -- Hours
  if(time > 3600) then
    hour = string.sub("00" .. round(time / 60 / 60), -4, -3)
  else
    hour = "00"
  end
  -- Days
  if(time > 86400) then
    day = string.sub("00" .. round(time / 60 / 60 / 24), -4, -3)
  else
    day = "00"
  end
  return day..":"..hour..":"..min..":"..sec
end
