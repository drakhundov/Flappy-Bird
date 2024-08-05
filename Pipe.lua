Pipe = Class{}

PIPE_SPRITE = love.graphics.newImage("assets/sprites/pipe.png")
PIPE_WIDTH = PIPE_SPRITE:getWidth()
PIPE_HEIGHT = PIPE_SPRITE:getHeight()

function Pipe:init(orientation, x, y)
    self.x = x
    self.y = y
    -- "top" or "bottom"
    self.orientation = orientation
end

function Pipe:render()
    love.graphics.draw(
        PIPE_SPRITE,
        self.x,
        -- When we mirror an image, it will be shifted up by height amount.
        (self.orientation == "top" and self.y + PIPE_HEIGHT or self.y),
        0,  -- Orientation (radians).
        1,  -- Scale factor (X).
        (self.orientation == "top" and -1 or 1) -- Scale factor (Y).
    )
end
