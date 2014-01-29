enum = function(vars)
	local obj = {}
	for i, v in ipairs(vars) do
		obj[v] = i
	end
	return obj
end
