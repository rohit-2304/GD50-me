GameOverState = Class{__includes = BaseState}

function GameOverState: enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        
        local highScore = false
        local index = 11

         for i = 10,1,-1 do
           if self.highScores[i].score < self.score then
            index = i
            highScore = true
           end
        end

        if highScore then
            gStateMachine:change('enter-highScore',{
                highScores = self.highScores,
                score = self.score,
                index = index
            })
        else
            gStateMachine:change('high-score',{highScores = self.highScores})
        end
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("GAME OVER", 0, VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
    
end
