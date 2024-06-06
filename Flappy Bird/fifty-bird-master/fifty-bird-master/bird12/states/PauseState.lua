PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.score = params.score
    self.timer = params.timer
    self.lastY = params.lastY
end 

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play',{
            bird = self.bird,
            pipePairs = self.pipePairs,
            score = self.score,
            timer = self.timer,
            lastY = self.lastY
        } )
    end
end

function PauseState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Paused', 0, 64, VIRTUAL_WIDTH, 'center')
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)



    self.bird:render()
end
