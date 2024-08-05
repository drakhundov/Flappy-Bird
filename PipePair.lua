PipePair = Class {}

PIPE_SCROLL_SPEED = -60

PIPE_GAP = 90
PIPE_CHANGE = 50

-- How much pixels below the top should the pipe be spawned.
PIPE_SPAWN_TOP_LIMIT = 25

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    self.pipes = {
        upper = Pipe("top", self.x, self.y),
        lower = Pipe("bottom", self.x, self.y + PIPE_HEIGHT + PIPE_GAP)
    }
    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    if self.x < -PIPE_WIDTH then
        self.remove = true
    else
        self.x = self.x + PIPE_SCROLL_SPEED * dt
        for k, pipe in pairs(self.pipes) do
            pipe.x = self.x
        end
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
