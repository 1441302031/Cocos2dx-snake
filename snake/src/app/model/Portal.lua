Portal = class("Portal")

function Portal:ctor(bound, node)
	self.node = node
	self.bound = bound
	math.randomseed(os.time())

	self:init()
end


function Portal:createPortal(boundLimit)
	local posX, posY = getPosition(boundLimit)
	local x, y = grid2Pos(posX, posY)
	local portalSp = display.newSprite("portal.png")
	portalSp:setPosition(x, y)
	self.node:addChild(portalSp)
	return {x = posX, y = posY, sp = portalSp}
end

function Portal:init()
	if self.portalA then
		self.node:removeChild(self.portalA.sp)
	end
	if self.portalB then
		self.node:removeChild(self.portalB.sp)
	end

	local boundLimit = self.bound - 1

	self.portalA = self:createPortal(boundLimit)
	self.portalB = self:createPortal(boundLimit)

	setCollide(self.portalA.x, self.portalA.y, {type = "Portal", name = "posrtalA", link = self.portalB})
	setCollide(self.portalB.x, self.portalB.y, {type = "Portal", name = "posrtalB", link = self.portalA})
end

function Portal:reset()
	self.node:removeChild(self.portalA.sp)
	self.node:removeChild(self.portalB.sp)
end

return Portal