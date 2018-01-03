Pos2EventMap = {}

local function makePosKey(x, y)
	return string.format("%d,%d", x, y)
end

function setCollide(x, y, event)
	if event.name then
		-- 这段代码还是不是特别明白,蛇移动更新的时候，碰撞标记跟着更新
		for key, ev in pairs(Pos2EventMap) do
			if ev.name == event.name then
				Pos2EventMap[key] = nil
			end
		end
	end

	local key = makePosKey(x, y)
	if Pos2EventMap[key] then
		return 
	end
	Pos2EventMap[key] = event
	-- print("After update:", key, Pos2EventMap[key].type, Pos2EventMap[key].name)
end

function checkCollide(x, y)
	return Pos2EventMap[makePosKey(x, y)]
end

function resetCollide()
	Pos2EventMap = {}
end