

LevelMaker = Class{} 

--[[
    Creates a table of Bricks to be returned to the main game, with different
    possible ways of randomizing rows and columns of bricks. Calculates the
    brick colors and tiers to choose based on the level passed in.
]]
function LevelMaker.createMap(level)
    local bricks = {}

    -- randomly choose the number of rows
    local numRows = math.random(1, 5)

    -- randomly choose the number of columns
    local numCols = math.random(7, 13)
    numCols = numCols%2 == 0 and numCols + 1 or numCols -- no. of columns is odd

    local highest_tier = math.min(3, math.floor(level/3))

   local highest_colour = math.min(5,level% 5 + 3)

    -- lay out bricks such that they touch each other and fill the space
    for y = 1, numRows do
        local skip = math.random(1,2) == 1 and true or false
        local skipflag = math.random(2) == 1 and true or false
    
        local alternate = math.random(1,2) == 1 and true or false
        local alternateflag = math.random(2) == 1 and true or false

        local alternate_colour1 = math.random(1,highest_colour)
        local alternate_colour2 = math.random(1,highest_colour)
        local alternate_tier1 = math.random(0,highest_tier)
        local alternate_tier2 = math.random(0,highest_tier)

        local solid_colour = math.random(1,highest_colour)
        local solid_tier = math.random(0,highest_tier)

        for x = 1, numCols do

            if skip then
                if skipflag then
                    skipflag = not skipflag
                    goto continue
                else
                    skipflag = not skipflag
                end

            end
            b = Brick(
                -- x-coordinate
                (x-1)                   -- decrement x by 1 because tables are 1-indexed, coords are 0
                * 32                    -- multiply by 32, the brick width
                + 8                     -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                + (13 - numCols) * 16,  -- left-side padding for when there are fewer than 13 columns
                
                -- y-coordinate
                y * 16                  -- just use y * 16, since we need top padding anyway
            ) 
                

            if alternate then
                if alternateflag then
                    alternateflag = not alternateflag
                    b.color = alternate_colour1
                    b.tier = alternate_tier2
                else
                    alternateflag = not alternateflag
                    b.color = alternate_colour2
                    b.tier = alternate_tier2
                end
            end

            if not alternate then
                b.color = solid_colour
                b.tier = solid_tier
            end 


            table.insert(bricks, b)
            ::continue::
        end
    end 

    return bricks
end
