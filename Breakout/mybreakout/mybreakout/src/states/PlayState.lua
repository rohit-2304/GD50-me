PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.ball = params.ball
    self.bricks = params.bricks
    self.score = params.score
    self.health = params.health
    self.level = params.level
    self.highScores = params.highScores

    self.ball.dx = math.random(-200,200)
    self.ball.dy = math.random(-50,-60)

    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42

    self.paused = false
    
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end
    if  self:checkVictory() then
        
        gStateMachine:change('victory',{
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            level = self.level ,
            highScores = self.highScores
           
        })  
    end
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - 16
        self.ball.dy = -self.ball.dy
        local middle = self.paddle.x + (self.paddle.width/2)
        if self.paddle.dx > 0 and self.ball.x > middle then
            self.ball.dx = 50 + (7.5*math.abs(middle - self.ball.x))
        elseif self.paddle.dx < 0 and self.ball.x < middle then
            self.ball.dx = -50 + -(7.5 * (middle - self.ball.x))
        end
        gSounds['paddle-hit']:play()
    end

    for k,brick in pairs(self.bricks) do
        brick:update(dt)
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()

            --self.score = self.score + (brick.tier * 100 + brick.color * 10)
            self.score = self.score + 500
            --left edge ,ball moving right
            if self.ball.dx > 0  and self.ball.x + 2 < brick.x then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            -- right edge, ball moving left
            elseif self.ball.dx < 0 and brick.x + brick.width < self.ball.x + 6 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end

            self.ball.dy = self.ball.dy * 1.02

            break
        end
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()
        
        if self.health > 0 then
            gStateMachine:change('serve',{
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            bricks = self.bricks,
            level = self.level,
            highScores = self.highScores
        })
        else 
            gStateMachine:change('game-over',{score = self.score, highScores = self.highScores})
        end
     
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
 
end


function PlayState:render()
    self.paddle:render()
    self.ball:render()
    for k,brick in pairs(self.bricks) do
        brick:render()
        
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    renderHealth(self.health)
    renderScore(self.score)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
    
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end

