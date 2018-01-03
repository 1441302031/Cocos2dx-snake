local Snake = class("Snake")
local Body = require("app.model.Body")

local HVDirection = {
	["left"] = 'Horizontabl',
	["right"] = 'Horizontabl',
	["up"] = 'vertically',
	["down"] = 'vertically'
}
local rot = {
	["left"] = '90',
	["right"] = '-90',
	["down"] = '0',
	["up"] = '180'
}

function Snake:ctor(node)
	-- 父节点
	self.node = node  
	-- 负责存取身体每个部位
	self.bodyArray = {}

	self.direction = nil

	self:init(5)

	self:setDirection('left')

	

end

function Snake:init(snakeLen)
	for i = 1, snakeLen do
		self:grow(i == 1)
	end
end
function Snake:setDirection(direction)
	if not direction then return nil end

	if HVDirection[self.direction] == HVDirection[direction] then return end
	self.direction = direction

	local head = self.bodyArray[1]
	head.sp:setRotation(rot[self.direction])
end

function offeresetMoveDirection(x, y, direction)
	if direction == 'down' then
		x, y = x, y - 1
	elseif direction == 'up' then
		x, y = x, y + 1
	elseif direction == 'left' then
		x, y = x - 1, y
	elseif direction == 'right' then
		x, y = x + 1, y
	end
	print("unkown direction!", direction)
	return x, y
end

-- 获取蛇的最后面的位置
function Snake:getTailGrid()
	if #self.bodyArray == 0 then
		return 0, 0
	end

	local tail = self.bodyArray[#self.bodyArray]
	return tail.x, tail.y
end

-- 获取蛇头的位置
function Snake:getHeadGrid()
	-- 没有头部的情况是不存在的，直接报错
	if #self.bodyArray == 0 then 
		return nil 
	end

	local head = self.bodyArray[1]
	return head.x, head.y
end

-- 设置蛇头的位置
function Snake:setHeadGrid(x, y)
	local head = self.bodyArray[1]
	head.x = x
	head.y = y
end

-- 蛇的增长
function Snake:grow(isHead)
	local tailX, tailY = self:getTailGrid()
	local body = Body.new(self.node, tailX, tailY, isHead, self)
	table.insert(self.bodyArray, body)
end


function Snake:update()
	if #self.bodyArray == 0 then return end
	for i = #self.bodyArray, 1, -1 do
		local body = self.bodyArray[i]
		if i==1 then 
			body.x, body.y = offeresetMoveDirection(body.x, body.y, self.direction)
		else
			local front = self.bodyArray[i-1]
			body.x, body.y = front.x, front.y
		end
		setCollide(body.x, body.y, {type= "Snake", name = string.format("body%d",i)})
		body:update()
	end
end

function Snake:reset()
	for _, body in ipairs(self.bodyArray) do
		self.node:removeChild(body.sp)
	end
end

function Snake:blink(callBack)
	for index, body in ipairs(self.bodyArray) do
		local blink = cc.Blink:create(3, 5)

		if index == 1 then
			local headBlink = cc.Sequence:create(blink, cc.CallFunc:create(callBack))
			body.sp:runAction(headBlink)
		else
			body.sp:runAction(blink)
		end
	end
end 

return Snake