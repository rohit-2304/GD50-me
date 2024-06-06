Pipe1= Class {}

function Pipe1:init(y)
    --self.image = love.graphics.newImage("assets/pipe_upsidedown.png")
    --self.height = self.image:getHeight()
    --self.width = self.image:getWidth()
    self.x = virtual_width + 32
    self.y = y
    self.dx = 70

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + 90)
    }
    self.remove = false
    self.scored = false
    
end

function Pipe1:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - self.dx*dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end
    


function Pipe1:draw()
    for k,pipe in pairs(self.pipes) do
        pipe:draw()
    end
    
end
