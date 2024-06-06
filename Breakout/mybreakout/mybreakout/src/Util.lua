function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetwidth = atlas:getWidth()/tilewidth
    local sheetheight = atlas:getHeight()/tileheight

    local sheetcounter = 1
    local spritesheet = {}

    for y = 0, sheetheight - 1 do
        for x = 0,sheetwidth - 1 do
            spritesheet[sheetcounter] = 
                love.graphics.newQuad(x*tilewidth , y*tileheight ,tilewidth,tileheight, atlas:getDimensions())

                sheetcounter = sheetcounter + 1
     
        end
    end

    return spritesheet
    
end

function table.slice(table,first,last,step)
    local sliced = {}

    for i = first or 1, last or #table, step or 1 do
        sliced[#sliced+1] = table[i]
    end 

    return sliced
    
end


function GenerateQuadsPaddles(atlas)

    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0,3 do
        --smallest
        quads[counter] = love.graphics.newQuad(x,y,32,16,atlas:getDimensions())
        counter = counter + 1

        --medium
        quads[counter] = love.graphics.newQuad(x+32,y,64,16,atlas:getDimensions())
        counter = counter + 1

        --large
        quads[counter]= love.graphics.newQuad(x+32+64,y,96,16,atlas:getDimensions())
        counter = counter + 1

        --xlarge
        quads[counter] = love.graphics.newQuad(x,y+16,128,16,atlas:getDimensions())
        counter = counter + 1

        x = 0
        y = y + 32
    end

    return quads
    
end

function GenerateQuadsHearts(atlas)
    local x = 128
    local y = 48
    local hearts = {}
    for i = 0, 1 do
        hearts[i+1] = love.graphics.newQuad(x, y, 10, 10, atlas:getDimensions())
        x = x + 10
    end
    return hearts
end


function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    x = 96
    y = 56

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    return quads
    
end

function GenerateQuadsBricks(atlas)
    local quads = {}

    quads = GenerateQuads(atlas,32,16)
    quads = table.slice(quads,1,21)
    return quads
end
