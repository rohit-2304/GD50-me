Class = require "lib.class"
push = require "lib.push"

require "Bird"
require "Pipe"
require "Pipe1"

virtual_height = 288
virtual_width = 512

width = 1280
height = 720

score = 0

bg ={}
bg.x = 0
bg.y = 0
bg.speed = 50

ground ={}
ground.x = 0
ground.y = 0
ground.speed = 100

pipes = {}

math.randomseed(os.time())

looping = 413

local last_y = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    --love.window.setMode(window_width, window_height)
    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle("Flappy Bird")

    timer = 3

    push:setupScreen(virtual_width,virtual_height,width,height,{
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    bg_img = love.graphics.newImage('assets/background/bg.png')
    bird_img = love.graphics.newImage("assets/bird.png")
    ground_img = love.graphics.newImage("assets/background/ground.png")

    font = love.graphics.newFont("assets/flappy.ttf")
    largefont = love.graphics.newFont("assets/flappy.ttf", 30)
    scorefont = love.graphics.newFont("assets/flappy.ttf", 20)
    game_state = "start"

    bird = Bird()
    pipe = Pipe()

    love.keyboard.keysPressed = {}
    

end

function love.update(dt)
    if game_state == "start" or game_state == "play" then
        bg.x = (bg.x + bg.speed*dt)%looping
        ground.x =(ground.x + ground.speed*dt)%looping
    end

        
    if game_state == "play" then
        bird:update(dt)
        timer = timer + dt
    
        if timer >= 3 then
            y = math.max (-PIPE_HEIGHT + 40, 
            math.min(last_y + math.random(-40,40), virtual_height-90-PIPE_HEIGHT))
            table.insert(pipes, Pipe1(y))
            last_y = y
            timer = 0
        end

        for k , v in pairs(pipes) do
            v:update(dt)
            if not v.scored then
                if bird.x > v.x + PIPE_WIDTH then
                    v.scored = true
                    score = score + 1
                end
                
            end
            for l,pipe in pairs(v.pipes) do
                if bird:collision(pipe) then
                    game_state = 'finished'
            
                end
            end
        end

        for k , v in pairs(pipes) do
            if v.remove then
                table.remove(pipes,k)
            end
        end

    end

    love.keyboard.keysPressed = {}
end



function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == "space" then
        if game_state == "start" then
            game_state = "play"
        
        elseif game_state == 'finished' then
           
            for k,v in pairs(pipes) do
                table.remove(pipes,k)
            end
            bird:reset()
            score = 0
            game_state = "start"

        end    
    end 

    if key == "escape" then
        love.event.quit()
    end

    
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.resize(w,h)
    push:resize(w,h)
    
end


function love.draw() 

    push:start()

    love.graphics.draw(bg_img,-bg.x,bg.y)

    if game_state == 'finished' or game_state == 'play' then
        for key, value in pairs(pipes) do    
        value:draw()
        end
    end

    bird:draw()

    love.graphics.draw(ground_img,-ground.x,virtual_height-ground_img:getHeight())
   

    if game_state == "start" then
        love.graphics.setFont(largefont)
        love.graphics.printf("FLAPPY BIRD", 0, 20 , virtual_width , 'center')  
        love.graphics.printf("Press space to play", 0, 220, virtual_width,'center')
    elseif game_state == "finished" then
        love.graphics.setFont(largefont)
        love.graphics.printf("GAME OVER",0 ,30,virtual_width,'center')
        love.graphics.printf("Press space to restart", 0, 220, virtual_width,'center')
    end
    
    love.graphics.setFont(scorefont)
    love.graphics.print("SCORE:"..tostring(score), virtual_width - 120, 20)

   push:finish()
    
    
end
