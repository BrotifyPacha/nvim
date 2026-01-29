local M = {}

function M.getGolangFunctionReceiverLetter(input)
  -- lua iterate over string chars
  local out_letter = input:sub(1,1)
  for i = 2, #input do
	local letter = input:sub(i,i)
	if letter:upper() == letter then
	  out_letter = letter
	end
  end
  return out_letter:lower()
end

return M
