Brick = Class{}

paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

function Brick:init(x,y)
    self.width = 32
    self.height = 16
    self.x = x
    self.y = y

    self.tier = 0
    self.color = 1
    
    self.inPlay = true

    self.ParticleSystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

    self.ParticleSystem:setParticleLifetime(0.5,1)

    self.ParticleSystem:setLinearAcceleration(-15, 0, 15, 80)

    self.ParticleSystem:setEmissionArea('normal',10,10)

end

function Brick:hit()

    self.ParticleSystem:setColors(paletteColors[self.color].r / 255,
    paletteColors[self.color].g / 255,
    paletteColors[self.color].b / 255,
    55 * (self.tier + 1) / 255,
    paletteColors[self.color].r / 255,
    paletteColors[self.color].g / 255,
    paletteColors[self.color].b / 255,
    0)
    self.ParticleSystem:emit(64)

    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()
    if self.color == 1 then
        if self.tier > 0 then
            self.tier = self.tier - 1
        else
            self.inPlay = false
        end
        
    elseif self.color > 1  then
        if self.tier > 0 then
            self.tier = self.tier - 1
        else
            self.color = self.color - 1
        end 
    end
    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
    
end

function Brick:update(dt)
    self.ParticleSystem:update(dt)
end

function Brick:render()
    if self.inPlay then 
        love.graphics.draw(gTextures['main'], gFrames['bricks'][1 + ((self.color-1)*4) + self.tier],
        self.x, self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.ParticleSystem, self.x + 16, self.y + 8)
end
