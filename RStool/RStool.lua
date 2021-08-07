-- Libs
local sides = require("sides")
local component = require("component")
local serial = require("serialization")
local event = require("event")
local term = require("term")
local string = require("string")
local keyboard = require("keyboard")
local fs = require("filesystem")
local io = require("io")
-- Components
local rs = component.block_refinedstorage_interface
local gpu = component.gpu
-- Functions
local getFluidSize = require("/func/getFluidSize").getFluidSize
local getItemSize = require("/func/getItemSize").getItemSize
local getTime = require("/func/getTime").getTime
local roundItemValue = require("/func/roundItemValue").roundItemValue
local round = require("/func/round").round

--- Load Config
local cfg = require "config"
local stacks = cfg.stacks
local maxItems = cfg.maxItems
local maxFluids = cfg.maxFluids
local output = cfg.output


-- Screen Init
local rX, rY = gpu.getResolution()
term.clear()


print("Loading...")
os.sleep(0.5)
print(" ")



-- Get Items
local count = 0
for _ in ipairs(stacks) do count = count + 1 end
if(count > 0) then
  print("Added " ..count.. " Items")
  os.sleep(0.2)
  for i, v in ipairs(stacks) do
    print(v)
    os.sleep(0.2)
  end
  os.sleep(0.2)
else
  gpu.setForeground(0xFFB600)
  print("WARNING")
  print("No Items Added")
  os.sleep(0.2)
  gpu.setForeground(0xFFFFFF)
end

print(" ")
print("Max Items  : " ..maxItems)
print("Max Fluids : " ..maxFluids)
os.sleep(0.3)
print(" ")
gpu.setForeground(0x009200)
print("Ready!")
gpu.setForeground(0xFFFFFF)
os.sleep(1)
term.clear()
gpu.setResolution(20, 20)


-- Functions
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult) / mult
end

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

function getItemSize(table)
  local num = 0
  for i, item in ipairs(table) do
    num = num + item.size
  end
  return num
end

function getFluidSize(table)
  local num = 1000
  for i, item in ipairs(table) do
    num = num + item.amount
  end
  return num / 1000
end

function getItemBar()
  
end

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





-- Other
local carryNum = 0
local timeUp = 0




-- Main Loop
while(true) do
  
  -- Exit
  if(keyboard.isKeyDown(0x1D)) then
    term.clear()
    print("Exiting...")
    break
  end
  
  -- Get Stats
  local energy = rs.getEnergyUsage()
  local iTot = roundItemValue(getItemSize(rs.getItems()), true)
  local iMax = roundItemValue(maxItems)
  local iBar = "▓▓▓▓▓▓▓▓░░░░░░░░"
  local fTot = roundItemValue(getFluidSize(rs.getFluids()), true)
  local fMax = roundItemValue(maxFluids)
  local fBar = "▓▓▓▓▓▓▓▓░░░░░░░░"
  timeUp = timeUp + 1
  
  -- Print Stats
  term.clear()
  gpu.set(1, 2, "Refined Storage Tool")

  gpu.set(1, 4, "      " ..roundItemValue(energy).. " RF/t     ")          -- 4  chars

  gpu.set(1, 6, "        Items       ")
  gpu.set(1, 7, "   " ..iTot.. "/" ..iMax.. "  ")    -- 7  chars each
  gpu.set(1, 8, "  " ..iBar.. "  ")                        -- 16 chars
  
  gpu.set(1,10, "       Fluids       ")
  gpu.set(1,12, "   " ..fTot.. "/" ..fMax.. "  ")     -- 4  chars each
  gpu.set(1,13, "  " ..fBar.. "  ")                        -- 16 chars
  

  gpu.set(1,16, "  Moved  : " ..carryNum.. "    ")         -- 4  chars
  gpu.set(1,17, "     " ..getTime(timeUp).. "    ")         

  
  -- Move Stuff
  carryNum = 0
  for i,nstack in ipairs(stacks) do
  
    local stack = rs.getItem(nstack)
    
    -- If Amount is less than 129 skip
    if(stack.size < 129) then
      goto continue
    end
    
    -- Move items
    local extract = rs.extractItem(stack, 64, output)
    carryNum = carryNum + extract    

    ::continue::
  end

  -- Pause
  os.sleep(1)
end

-- Exit Process
os.sleep(2.5)
gpu.setResolution(rX, rY)
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
term.clear()
