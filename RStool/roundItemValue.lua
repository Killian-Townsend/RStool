local round = require("/round.lua")

function roundItemValue(num, bool)
  local out
  if(num > 999999999) then
    -- 1B
    num = num / 1000000000
    num = round(num, 1)
    out = num .. "B"
  elseif(num > 999999) then
    -- 1M
    num = num / 1000000
    num = round(num, 1)
    out = num .. "M"
  elseif(num > 999) then
    -- 1K
    num = num / 1000
    num = round(num, 1)
    out = num .. "K"
  else
    out = round(num, 0)
  end
  if(bool) then
    out = "       " .. out
    out = string.sub(out, -7)
  end
  return out
end
