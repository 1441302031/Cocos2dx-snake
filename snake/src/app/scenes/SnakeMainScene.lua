local SnakeMainScene = SnakeMainScene or class("SnakeMainScene", function()
	return display.newScene("SnakeMainScene")
	end)

function SnakeMainScene:ctor()
	self:setBackground()
	self:createStartButton()
	self:createSettingButton()
	self:createQuestionButton()
	self:createExitButton()
end

function SnakeMainScene:setBackground()
	display.newSprite("bg.png")
		:pos(display.cx, display.cy)
		:addTo(self)
end

function SnakeMainScene:createStartButton()
	local x = display.cx
	local y = display.cy - 80
	local image = "startGame.png"
	self:createButton(x, y, image, self.startGame)
end

function SnakeMainScene:createSettingButton()
	local x = display.cx - 200
	local y = display.bottom + 80
	local image = "setting.png"
	self:createButton(x, y, image, self.setting)
end

function SnakeMainScene:createQuestionButton()
	local x = display.cx
	local y = display.bottom + 80
	local image = "question.png"
	self:createButton(x, y, image, self.printInfo)
end

function SnakeMainScene:createExitButton()
	local x = display.cx + 200
	local y = display.bottom + 80
	local image = "exit.png"
	self:createButton(x, y, image, self.printInfo)
end

function SnakeMainScene:createButton(x, y, image, callback)
	cc.ui.UIPushButton.new({normal = image, pressed = image})
		:pos(x, y)
		:onButtonClicked(function(event)
			callback()
			end)
		:addTo(self)
end

function SnakeMainScene.startGame()
	print("Hello my friends, game has started!")
	local MainScene = import("app.scenes.MainScene").new()
	display.replaceScene(MainScene, "fade", 0.5)
end

function SnakeMainScene.setting()
	print("*********** enter EditorScene! ***********")
	local EditorScene = import("app.scenes.EditorScene").new()
	display.replaceScene(EditorScene, "fade", 0.5)
end

function SnakeMainScene.printInfo()
	print("*********** enter callback function! ***********")
end


return SnakeMainScene