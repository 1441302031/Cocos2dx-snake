CBOUND = 8	-- 设置游戏界面边界

-- 从逻辑位置获取屏幕真实位置
function grid2Pos(x, y)
	local cGrideSize = 33	-- 每个放格子的大小
	local scaleRate = 1/display.contentScaleFactor	-- 比例缩放，不需要
	-- 获取名屏幕的可视化大小
	local visibleSize = cc.Director:getInstance():getVisibleSize()

	local origin = cc.Director:getInstance():getVisibleOrigin()

	local finalX = origin.x + visibleSize.width/2 + x * cGrideSize * scaleRate
	local finalY = origin.y + visibleSize.height/2 + y * cGrideSize * scaleRate

	return finalX, finalY
end

-- 优化随机生成算法，保证苹果和传送门不会重合
function getPosition(bound)
	local x, y
	while true do
		x = math.random(-bound, bound)
		y = math.random(-bound, bound)
		local temp = string.format("%d,%d", x, y)
		if checkCollide(x, y) == nil then 
			break 
		end
	end
	return x, y
end

