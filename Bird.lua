Bird = Class{}

GRAVITY = 15
JUMP_FORCE = 5
HITBOX_MARGIN = 2

function Bird:init()
    self.image = love.graphics.newImage("assets/sprites/bird.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - self.width
    self.y = VIRTUAL_HEIGHT / 2 - self.height
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    if love.events.get["jump"] then
        self.dy = -JUMP_FORCE
        gSounds["jump"]:play()
    end
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    if self.x + self.width - HITBOX_MARGIN < pipe.x or pipe.x + PIPE_WIDTH < self.x + HITBOX_MARGIN then
        return false
    end
    if self.y + self.height - HITBOX_MARGIN < pipe.y or pipe.y + PIPE_HEIGHT < self.y + HITBOX_MARGIN then
        return false
    end
    return true
end
