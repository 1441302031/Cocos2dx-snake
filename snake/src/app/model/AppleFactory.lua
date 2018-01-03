local AppleFactory = class("AppleFactory")

function AppleFactory:ctor(bound, node)
	self.bound = bound
	self.node = node
	self.appleX = nil
	self.appleY = nil
	self.appleSprite = nil

	-- 获取随机种子
	math.randomseed(os.time())

	-- 生成一个苹果
	self:init()
end


function AppleFactory:init()
	-- 产生新苹果的时候将上次的苹果留下来的节点移除
	if self.appleSprite then 
		self.node:removeChild(self.appleSprite)
	end
	local sprite = display.newSprite("apple.png")
	local boundLimit = self.bound - 1
	-- 随机值获得逻辑坐标
	local x, y = getPosition(boundLimit), getPosition(boundLimit)
	-- 获取实际物理坐标的位置
	local finalX, finalY = grid2Pos(x, y)

	sprite:setPosition(finalX, finalY)
	self.node:addChild(sprite)
	-- 将精灵保存起来，以及苹果的坐标
	self.appleSprite = sprite
	self.appleX, self.appleY = x, y
	setCollide(self.appleX, self.appleY, {name = "Apple"})
end

function AppleFactory:reset()
	-- 移除上次的碰撞标记
	self.node:removeChild(self.appleSprite)
	print("苹果移除！")
end

return AppleFactory