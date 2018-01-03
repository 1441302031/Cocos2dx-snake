local Fence = class("fence")

-- 墙壁生成的回调函数
function Fence:fenceInit(node, bound, callBack)
	for i = -bound, bound do
		local sp = display.newSprite("fence.png")
		local posX, posY = callBack(i)
		sp:setPosition(posX, posY)
		node:addChild(sp)
		table.insert(self.spArrary, sp)
	end
end

function Fence:ctor(bound, node)
	self.bound = bound
	self.node = node 
	self.spArrary = {}
	-- 生成墙壁
	-- right
	self:fenceInit(node, bound, function(i)
			setCollide(bound, i, {type = "Fence"})
			return grid2Pos(bound, i)
		end)
	-- left
	self:fenceInit(node, bound, function(i)
			setCollide(-bound, i, {type = "Fence"})
			return grid2Pos(-bound, i)
		end)
	-- up
	self:fenceInit(node, bound, function(i)
			setCollide(i, bound, {type = "Fence"})
			return grid2Pos(i, bound)
		end)
	-- down
	self:fenceInit(node, bound, function(i)
			setCollide(i, -bound, {type = "Fence"})
			return grid2Pos(i, -bound)
		end)
end

function Fence:reset()
	for _, vSp in pairs(self.spArrary) do
		self.node:removeChild(vSp)
	end
end

return Fence