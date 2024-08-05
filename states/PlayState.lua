PlayState = Class {__includes = BaseState}

MIN_SPAWN_INTERVAL = 2
MAX_SPAWN_INTERVAL = 3.5

function PlayState:enter()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.spawn_interval = 0
    self.score = 0
    -- Store last pipe gap spawn position to ensure smooth change in gap.
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    if love.events.get["pause"] then
        gPaused = not gPaused
    end
    if gPaused then
        return
    end
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.spawn_interval then
        local yCoord =
            math.max(
                -PIPE_HEIGHT + PIPE_SPAWN_TOP_LIMIT,
                math.min(
                    self.lastY + math.random(-PIPE_CHANGE, PIPE_CHANGE), VIRTUAL_HEIGHT - PIPE_GAP - PIPE_HEIGHT
                )
            )
        self.lastY = yCoord
        table.insert(self.pipePairs, PipePair(yCoord))
        self.spawnTimer = 0
        self.spawn_interval = math.random(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)
    end
    self.bird:update(dt)
    for k, pair in pairs(self.pipePairs) do
        if not pair.scored and pair.x + PIPE_WIDTH < self.bird.x then
            self.score = self.score + 1
            pair.scored = true
            gSounds["score"]:play()
        elseif pair.remove then
            table.remove(self.pipePairs, k)
        end
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                self:gameover()
            end
        end
        pair:update(dt)
    end
    -- Ground collision.
    if self.bird.y > VIRTUAL_HEIGHT - self.bird.height then
        self:gameover()
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    self.bird:render()
    love.graphics.setFont(gFonts["small"])
    love.graphics.printf("Score: " .. tostring(self.score), 10, 10, VIRTUAL_WIDTH/3, "left")
end

function PlayState:gameover()
    gSounds["hurt"]:play()
    gSounds["explosion"]:play()
    gStateMachine:change("score", {score = self.score})
end
