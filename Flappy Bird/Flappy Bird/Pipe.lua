Pipe = Class {}

local pipe_image = love.graphics.newImage("assets/pipe.png")

PIPE_HEIGHT = pipe_image:getHeight()
PIPE_WIDTH = pipe_image:getWidth()
function Pipe:init(orientation,y)
    self.image = pipe_image
    self.height = self.image:getHeight()
    self.width = self.image:getWidth()
    self.x = virtual_width
    self.orientation = orientation
   self.y = y
    self.dx = 60
    
end

function Pipe:update(dt)
    self.x = self.x - self.dx * dt
    
end
    
function Pipe:draw()
    love.graphics.draw(self.image,self.x,
                        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
                    0,1,(self.orientation == 'top' and -1 or 1))
    love.graphics.draw()
    
end
