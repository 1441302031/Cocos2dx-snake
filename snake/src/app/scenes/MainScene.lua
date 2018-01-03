
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)
-- local Body = require("app.scenes.Body")
require("app.model.collideManager")
require("app.model.Command")
local Snake = require("app.model.Snake")
local AppleFactory = require("app.model.AppleFactory")
local Fence = require("app.model.Fence")
local Portal = require("app.model.Portal")

-- 逻辑计算，确定方向
local function vector2Direction(x, y)
	-- 用横坐标和纵坐标做比较确定点击的大致方向，然后根据它距离中心的位置对其进行方向判断
	local direction
	if math.abs(x) > math.abs(y) then
		if x > 0 then
			direction = 'right'
		else
			direction = 'left'
		end
	else
		if y > 0 then
			direction = 'up'
		else
			direction = 'down'
		end
	end
	return direction
end

function MainScene:createKeyBoradEvent()
	local function keyboardPressed(keyBoard, event)
		-- pressed direction is up
		if keyBoard == 28 then
			print("enter up!")
			self.snake:setDirection('up')
		-- pressed direction is down
		elseif keyBoard == 29 then
			print("enter down!")
			self.snake:setDirection('down')
		-- pressed direction is left
		elseif keyBoard == 26 then
			print("enter left!")
			self.snake:setDirection('left')
		-- pressed direction is right
		elseif keyBoard == 27 then
			print("enter right!")
			self.snake:setDirection('right')
		end
	end
	-- 创建一个键盘间监听事件
	local listener = cc.EventListenerKeyboard:create()
	-- 注册键盘监听事件到句柄,keyboardPressed键盘按压下去的回调函数
	listener:registerScriptHandler(keyboardPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	-- 获取MainScene中的事件调度器
	local eventDispatcher = self:getEventDispatcher()
	-- 将监听器绑定到全局的屏幕调度器上
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

-- 屏幕点击监听器，获取点击的坐标
function MainScene:processInput()
	local function onTouchBegan(touch, event)
		local location = touch:getLocation()
		local visibleSize = cc.Director:getInstance():getVisibleSize()
		local origin = cc.Director:getInstance():getVisibleOrigin()

		local finalX = location.x - (origin.x + visibleSize.width/2) 
		local finalY = location.y - (origin.y + visibleSize.height/2)

		local direction = vector2Direction(finalX, finalY)

		-- 将点击获取的坐标进行逻辑运算，控制蛇头进行转向
		self.snake:setDirection(direction)
	end
	-- 注册一个监听器，用来监听鼠标点击的方向
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	self:setTouchSwallowEnabled(true)
	self:setTouchEnabled(true)

	-- 屏幕点击监听器，监听node节点信息
	-- self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	-- self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
	-- 	print("clicked position:", event.x, event.y)
	-- 	print("clicked node:", event.name)
	-- 	if event.name == "began" then 
	-- 		posBegan = {x = event.x, y = event.y}
	-- 		return true 
	-- 	end
	-- 	end)
end

-- 初始化一些游戏参数
function MainScene:init()
	self.cMoveSpeed = 0.3 -- 设置游戏帧，其实就是蛇移动的速度
	-- 增加一个计分板
	local appleFace = display.newSprite("score.png")
	appleFace:setPosition(display.right - 80, display.cy + 80)
	self:addChild(appleFace)

	local ttfconfig = {}
	ttfconfig.fontFilePath = "arial.ttf"
	ttfconfig.fontSize = 30
	local scoreTable = cc.Label:createWithTTF(ttfconfig, '0')
	scoreTable:setPosition(display.right - 80, display.cy + 35)
	self:addChild(scoreTable)

	self.scoreLabel = scoreTable
	-- 初始化分数为零
	self.score = 0
end


function MainScene:setScore()
	self.scoreLabel:setString(string.format("%d", self.score))
end


function MainScene:onEnter()
	-- 初始化游戏数据
	self:init()

	self:reset()
	self.status = "running"
	
	-- self:processInput()
	self:createKeyBoradEvent()
	local tick = function()
		if self.status == "running" then
			self.snake:update()
			local headX, headY = self.snake:getHeadGrid()
			local event = checkCollide(headX, headY)
			if event and event.name ~= 'body1' then
				if event.type == "Fence" or event.type == "Snake" then
					self.status = "dead"
					self.snake:blink(function()
						-- 本局游戏结束
						self:reset()
						-- 跳转到新的游戏
						end)
				elseif event.name == "Apple" then
					self.apple:init()
					self.snake:grow()
					-- 吃到苹果分数++
					self.score = self.score + 1
					self:setScore()
				elseif event.type == 'Portal' then
					self.snake:setHeadGrid(event.link.x, event.link.y)
				end
			end
		end
	end
	-- 设置一个时间调度器实时更新
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, self.cMoveSpeed, false)
end

-- 重置游戏场景，可能是开始的时候，也有可能是游戏结束的时候
function MainScene:reset()

	-- 重置游戏时，设置分数为零
	self.score = 0
	self:setScore()
	self.status = "running"
	-- 游戏结束，重置蛇类
	if self.snake then
		self.snake:reset()
	end
	-- 游戏结束，重置苹果
	if self.apple then
		self.apple:reset()
	end
	-- 重置围墙
	if self.fence then
		self.fence:reset()
	end
	-- 重置传送门
	if self.portal then
		self.portal:reset()
	end
	-- 重置碰撞器
	resetCollide()

	self.fence = Fence.new(CBOUND, self)
	self.portal = Portal.new(CBOUND, self)
	self.apple = AppleFactory.new(CBOUND, self)
	self.snake = Snake.new(self)
end

function MainScene:onExit()
end
return MainScene
