Bird = Class {}

local gravity = 14
function Bird:init()
    self.image = love.graphics.newImage("assets/bird.png")
    self.width = self.image:getWidth()
    self.height= self.image:getHeight()
    self.x = virtual_width/2 - self.width /2
    self.y = virtual_height/2 - self.height /2
    self.dy = 0
    
    self.pass = true
    
    
end

function Bird:reset()
    self.width = self.image:getWidth()
    self.height= self.image:getHeight()
    self.x = virtual_width/2 - self.width /2
    self.y = virtual_height/2 - self.height /2
    self.dy = 0

end

function Bird:update(dt)
    --enabled = love.keyboard.setKeyRepeat(false)
    
    --gravity
    self.dy = self.dy + gravity*dt
    self.y = math.min(self.y + self.dy , virtual_height-self.height)
    

    if love.keyboard.wasPressed('space') then
        self.dy = -3.5
    end
end

function Bird:collision(target)

    return target.x < self.x+2 + self.width-4 and
    target.x + target.width > self.x+2 and
    target.y < self.y+2 + self.height-4 and
    target.y + target.height > self.y +2

    
end


function Bird:draw()
    love.graphics.draw(self.image,self.x,self.y)
    
end
