function getItemSize(table)
  local num = 0
  for i, item in ipairs(table) do
    num = num + item.size
  end
  return num
end
