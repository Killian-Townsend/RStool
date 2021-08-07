function getFluidSize(table)
  local num = 1000
  for i, item in ipairs(table) do
    num = num + item.amount
  end
  return num / 1000
end
