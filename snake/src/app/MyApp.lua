
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
     cc.FileUtils:getInstance():addSearchPath("res/")
    -- cc.Director:getInstance():setContentScaleFactor(1024/CONFIG_SCREEN_WIDTH)
    self:enterScene("SnakeMainScene")
    -- self:enterScene("MainScene")
end

return MyApp
