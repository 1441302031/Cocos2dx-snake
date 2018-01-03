local Body = class("Body")

function Body:ctor(node, x, y, isHead,snake)
	self.snake = snake
	self.x = x
	self.y = y

	if isHead then
		self.sp = display.newSprite("head.png")
	else
		self.sp = display.newSprite("body.png")
	end

	node:addChild(self.sp)

	self:update()
end

function Body:update()
	local posX, posY = grid2Pos(self.x, self.y)
	self.sp:setPosition(posX, posY)

end


return Body