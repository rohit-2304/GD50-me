push = require 'push'

Class = require 'class'

require 'Paddle'

require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest' , 'nearest')

    smallfont = love.graphics.newFont('font.ttf', 8)
    scorefont = love.graphics.newFont('font.ttf',32)
    victoryfont = love.graphics.newFont('font.ttf',18)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1 = Paddle(20,30,5,20)
    player2 = Paddle(VIRTUAL_WIDTH-20,VIRTUAL_HEIGHT-50,5,20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.update(dt)
    if gameState== 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(100, 140)
        else
            ball.dx = -math.random(100, 140)
            
        end   
    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
    
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
    
        if ball.y < 0 then
            ball.y = 0
            ball.dy = - ball.dy
            sounds['wall_hit']:play()
        end
    
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()
            if player1Score == 10 then
                winningPlayer = 1 
                gameState = 'victory'
            else
                gameState = 'serve'
                ball:reset()
            end

        end
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()
            if player2Score == 10 then
                winningPlayer = 2 
                gameState = 'victory'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
        if ball.dx > 0 then
            if ball.y > player2.y+2 then
                player2.dy = PADDLE_SPEED
            elseif ball.y < player2.y+2 then
                player2.dy = -PADDLE_SPEED
            elseif ball.y == player2.y or ball.y == player2.y + 4 then
                player2.dy = 0
            end
            player2:update(dt)
        end
        
        
    end
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s')  then
        player1.dy = PADDLE_SPEED
        else
        player1.dy = 0
        end


    if gameState == 'play' then
       ball:update(dt)
    end

    player1:update(dt)
    
end

function love.resize(w,h)
    push:resize(w,h)
    
end

function love.keypressed(key)
    
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'serve' then
            gameState = 'play' 
        elseif gameState == 'victory' then
            gameState = 'start'

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
        
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    
    if gameState == 'start' then
        love.graphics.setFont(smallfont)
        love.graphics.printf('Welcome to pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to play', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallfont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory'  then
        love.graphics.setFont(victoryfont)
        love.graphics.printf('Player' .. tostring(winningPlayer) ..' wins!' ,0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallfont)
        love.graphics.printf('Press Enter to restart', 0, 30, VIRTUAL_WIDTH, 'center')

    end
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(player1Score),VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    
    player1:render()
    player2:render()
    ball:render()

    display_fps()
    push:apply('end')
end

function display_fps()
    love.graphics.setFont(smallfont)
    love.graphics.setColor((0), 255/255, 0, 255/255)
    love.graphics.print('FPS: ' ..tostring(love.timer.getFPS()), 10 ,10)
end
