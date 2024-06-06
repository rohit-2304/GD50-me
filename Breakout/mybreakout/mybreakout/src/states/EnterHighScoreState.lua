EnterHighScoreState = Class{__includes = BaseState}


local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

local highlighted = 1
function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.index = params.index 
end

function EnterHighScoreState:update()
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])


        for i = 10, self.index, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.index].name = name
        self.highScores[self.index].score = self.score

        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. self.highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakout.lst', scoresStr)

        gStateMachine:change('high-score', {
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('left') and highlighted > 1 then
        highlighted = highlighted - 1
        gSounds['select']:play()
    elseif love.keyboard.wasPressed('right') and highlighted < 3   then
        highlighted = highlighted + 1
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('up') then
        chars[highlighted] = chars[highlighted] + 1
        if chars[highlighted] > 90 then
            chars[highlighted] = 65
        end
    elseif love.keyboard.wasPressed('down') then
        chars[highlighted] = chars[highlighted] - 1
        if chars[highlighted] < 65 then
            chars[highlighted] = 90
        end
    end

end

function EnterHighScoreState:render()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Your Score: " .. tostring(self.score), 0 , 30 , VIRTUAL_WIDTH,'center')

    love.graphics.setFont(gFonts['large'])

    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
    
end
