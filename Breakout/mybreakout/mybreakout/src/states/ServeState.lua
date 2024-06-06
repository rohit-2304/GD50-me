ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.health = params.health
    self.score = params.score
    self.bricks = params.bricks
    self.level = params.level
    self.ball = Ball()
    self.highScores = params.highScores
    self.ball.skin = math.random(7)

    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42
end

function ServeState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play',{
            ball = self.ball,
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            bricks = self.bricks,
            level = self.level,
            highScores = self.highScores
        })
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    
    self.paddle:update(dt)
 
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()
    for k,brick in pairs(self.bricks) do
        brick:render()
    end
    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press enter to serve", 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("LEVEL" .. tostring(self.level), 0, VIRTUAL_HEIGHT / 1.5,
        VIRTUAL_WIDTH, 'center')
    
end
